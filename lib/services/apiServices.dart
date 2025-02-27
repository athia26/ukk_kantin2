import 'dart:io';
import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Apiservices {
  final String baseUrl = 'https://ukk-p2.smktelkom-mlg.sch.id/api/';
  final String makerID = '55';

  //ambil token
  Future <String?> _getToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance(); 
    String? token = prefs.getString('access_token');
    print('token diambil: $token');
    return token; //ngembalikan token yang sudah diambil 
  }

  //simpan token biar bisa dipake lagi nanti 
  Future<void> _saveToken (String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
    print("Token disimpan: $token");
  }

  Future<bool> registerSiswa({
    required String namaSiswa,
    required String emailSiswa,
    required String username,
    required String password,
    File? foto,
  }) async {
    try{
      var request = 
        http.MultipartRequest('POST', Uri.parse('${baseUrl}register_siswa'))
        ..headers.addAll(await _getAuthHeaders())
        ..fields.addAll({
          'nama_siswa': namaSiswa,
          'email': emailSiswa,
          'username': username,
          'password': password,
        });

        if (foto != null){
          request.files.add(await http.MultipartFile.fromPath('foto', foto.path));
        }

        var response = await request.send();
        var responseBody = await response.stream.bytesToString();
        print('Register siswa response: $responseBody');

        return response.statusCode == 200;
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }

  Future <bool> updateSiswa({
    required int id,
    required String namaSiswa,
    required String email,
    required String username,
    File? foto,
  }) async{
    var uri = Uri.parse('$baseUrl/ubah_siswa/$id');

    var request = http.MultipartRequest("POST", uri);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");
    request.headers.addAll({
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "makerID": makerID,
    });

    request.fields['nama_siswa'] = namaSiswa;
    request.fields['email'] = email;
    request.fields['username'] = username;
    request.fields['maker_id'] = makerID;

    if (foto!=null){
      request.files.add(await http.MultipartFile.fromPath('foto', foto.path));
    }

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    var jsonResponse = jsonDecode(responseBody);

    if (response.statusCode == 200 && jsonResponse['status'] == true){
      print("update sukses: ${jsonResponse['message']}");
      return true;
    } else{
      print('update gagal: ${jsonResponse['message']}');
      return false;
    }
  }

  Future <bool> hapusSiswa ({required String siswaId}) async{
    try{
      var response = await http.delete(
        Uri.parse('${baseUrl}/hapus_siswa/$siswaId'),
        headers: await _getAuthHeaders(),
        body: jsonEncode({'id_user': siswaId}),
      );

      print('Response hapus user: ${response.body}');

      if(response.statusCode == 200){
        return true;
      } else{
        return false;
      }

    }catch (e){
      print('Error saat menghapus user: $e');
      return false;
    }
  }

  //login siswa 
  Future<Map<String,dynamic>> loginSiswa ({
    required String username,
    required String password,
  }) async{
    return _login('${baseUrl}login_siswa', username, password, 'siswa');
  }


  //loginstand
  Future<Map<String,dynamic>> loginStand({
    required String username,
    required String password,
  }) async {
    var response = await _login('${baseUrl}login_stan', username, password, 'admin_stan');

    print("Response API: $response");

    if (response['success']){
      var user = response ['user'];
      if (user != null && user['maker_id'] != null){
        String makerID = user['maker_id'].toString();

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('maker_id', makerID);

        print('MakerID berhasil disimpan: $makerID');
      } else{
        print("Warning: MakerID tidak ditemukan dalam response");
      }
    }

    return response;
  }



  //proses login, nantinya dipanggil di loginsiswa/loginstan
  Future <Map<String,dynamic>> _login(
    String url, String username, String password, String roleType) async{
      var headers = {
        'Content-Type': 'application/json',
        'makerID': makerID,
      };

      var body = jsonEncode({'username': username, 'password': password});

      var response = await http.post(Uri.parse(url), headers: headers, body: body);
      print("Login response($roleType): ${response.body}");

      if (response.statusCode == 200){
        return {'success': false, 'messsage': 'Server error'};
      }

      var responseData;
      try{
        responseData = jsonDecode(response.body);

      }catch (e){
        print("JSON Decode error: $e");
        return {'success': false, 'message': 'Invalid response format'};
      }

      if (responseData ['access_token'] != null){
        String token = responseData ['access_token'];
        String username = responseData ['user']['username'];
        String role = responseData ['user']['role'];
        String id = responseData ['user']['id'].toString();
        String makerID = responseData ['user']['maker_id'].toString();

        await _saveToken(token);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('role', role);
        await prefs.setString('username', username);
        await prefs.setString('id', id);
        await prefs.setString('maker_id', makerID);

        return{
          'success': true,
          'role': role,
          'username': username,
          'token': token,
          'id': id,
          'maker_id': makerID,
        };
      } else{
        return {
          'success': false,
          'message': responseData ['message'] ?? 'Login gagal'
        };
      }
    }



  Future<Map<String, String>> _getAuthHeaders() async{
    String? token = await _getToken();
    return{
      'Content-Type': 'application/json',
      'makerID': makerID,
      if (token != null)'Authorization' : 'Bearer $token',
    };
  }


}