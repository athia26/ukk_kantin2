import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Pesanan {
  final int idMenu;
  final int qty;

  Pesanan({required this.idMenu, required this.qty});

  // Konversi ke Map agar bisa dikirim sebagai parameter URL
  Map<String, dynamic> toMap() {
    return {
      'id_menu': idMenu.toString(),
      'qty': qty.toString(),
    };
  }
}


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
    required String alamat,
    required String noTelp,
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
          'alamat': alamat,
          'telp': noTelp,

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
    required String alamat,
    required String noTelp,
    File? foto,
  }) async{
    var uri = Uri.parse('$baseUrl/update_siswa/$id');

    var request = http.MultipartRequest("POST", uri);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");
    request.headers.addAll({
      "Authorization": "Bearer $token",
      "makerID": makerID,
    });

    request.fields['nama_siswa'] = namaSiswa;
    request.fields['email'] = email;
    request.fields['username'] = username;
    request.fields['maker_id'] = makerID;
    request.fields['alamat'] = alamat;
    request.fields['telp'] = noTelp;

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
        Uri.parse('$baseUrl/hapus_siswa/$siswaId'),
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

      if (response.statusCode != 200){
        return {'success': false, 'messsage': 'Server error'};
      }

      var responseData;
      try{
        responseData = jsonDecode(response.body);
        print("DEBUG: full response dari API -> $responseData");

      }catch (e){
        print("JSON Decode error: $e");
        return {'success': false, 'message': 'Invalid response format'};
      }

      if (responseData['access_token'] != null){
        String token = responseData ['access_token'];
        String username = responseData ['user']['username'];
        String role = responseData ['user']['role'];
        String id = responseData ['user']['id'].toString();
        String makerID = responseData['user']['maker_id'].toString();

        await _saveToken(token);

        
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('role', role);
        await prefs.setString('username', username);
        await prefs.setString('id', id);
        await prefs.setString('maker_id', makerID);
        await prefs.reload();

        String? cekToken = prefs.getString('token');
        print("📌 Cek ulang token setelah disimpan: $cekToken");

        print("✅ Token berhasil disimpan: $token");

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

    Future <List<dynamic>> getProfile() async{
      try{
        final token = await _getToken();
        print("🔑 Token digunakan: $token");
        if(token==null){
          print("token kosong, tidak bisa lanjut");
          return []; 
          //kalau token kosong (null) langsung return (mengembalikan) list kosong karena gabs lanjut request tanpa token 
        }

        final prefs = await SharedPreferences.getInstance();
        final storedMakerId = prefs.getString("makerID") ?? '55';

        print("🔍 Mengirim request dengan makerID: $storedMakerId");



        final response = await http.get(
          Uri.parse('${baseUrl}get_profile'),
          headers: {
            'Authorization' : 'Bearer $token',
            'Content-Type': 'application/json',
            'makerID': storedMakerId,
          },
        );

        print("🛠️ Status Code: ${response.statusCode}");
        print("📩 Raw API Response: ${response.body}");

        if (response.statusCode == 200){
          final jsonResponse = jsonDecode(response.body);

          if (jsonResponse is Map<String,dynamic> && jsonResponse.containsKey("data")){
            //cek jsonresponse nya map dan apakah punya key "data"
            
            final data = jsonResponse['data'];
            //datanya diambil dari jsonresponse 

            if (data is List){
              print("✅ Data diterima (List): ${data.length} item");
              return data;
            } else if (data is Map<String,dynamic>){
              print("✅ Data diterima (Map), mengubah ke List");
              return [data];
            }
            //kalau data berbentuk list langsung return datanya, 
            //tapi kalau data nya bentuk map ubah dulu jadi list pake satu elemen [data]
          }
        }
        return[];
        //kalau gak ada "data" di response, direturn list kosong

      }catch(e){
        print("error getProfile: $e");
        return [];
      }
    }

    Future <List<Map<String,dynamic>>> getSiswa() async {
      try {
        final token = await _getToken();
        if (token == null){
          return [];
        }

        final prefs = await SharedPreferences.getInstance();
        final storedMakerId = prefs.getString("makerID") ?? '55';

        final response = await http.post(
          Uri.parse('${baseUrl}get_siswa'),
          headers: {
            'Authorization': "Bearer $token",
            'Content-Type': 'application/json',
            'makerID': storedMakerId,
          }
        );

        if (response.statusCode == 200){
          final jsonResposne = jsonDecode(response.body);

          if (jsonResposne is Map<String,dynamic> && jsonResposne.containsKey("data")){
            final data = jsonResposne ["data"];

            if (data is List){
              return List<Map<String,dynamic>>.from(data);
            } else if (data is Map<String,dynamic>){
              return [data];
            }
          }   
        }

        return [];
      } catch (e){
        print("Error di   getSiswa: $e");
        return  []; 
      }
    }

    //getmenumakanan

    Future<List<dynamic>> getMenuMakanan () async{
      try{
        final token = await _getToken();
        final response = await http.post(
          Uri.parse('${baseUrl}getmenufood'),
          headers:  {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'makerID': makerID,
          },
        );

        print("Response menu makanan: ${response.body}");

        if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        return responseData['data'] ?? [];
      } else {
        return [];
      }
    } catch (e) {
      print("Error getMenuMakanan: $e");
      return [];
     
      }
    }

    //getallstan

    Future<List<dynamic>> getAllStan() async{
      try{
        final token = await _getToken();
        final response = await http.post(
          Uri.parse('${baseUrl}get_all_stan'),
          headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'makerID': makerID,
          },
        );

        print("Respponse get all stan: ${response.body}");

        if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        return responseData['data'] ?? [];
      } else {
        return [];
      }
    } catch (e) {
      print("Error get all Stan: $e");
      return [];
      }
    }

    //getminuman 

    Future<List<dynamic>> getMenuMinuman() async {
    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse('${baseUrl}getmenudrink'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'makerID': makerID,
        },
      );

      print("Response Menu Minuman: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        return responseData['data'] ?? [];
      } else {
        return [];
      }
    } catch (e) {
      print("Error getMenuMinuman: $e");
      return [];
    }
  }


    //getordersiswa 

Future<List<Map<String, dynamic>>> getOrderSiswa(String status) async {
    try {
      final token = await _getToken();
      if (token == null) {
        print("Token tidak ditemukan, harap login kembali.");
        return [];
      }

      final prefs = await SharedPreferences.getInstance();
      final storedMakerId = prefs.getString("maker_id") ?? makerID;

      final response = await http.get(
        Uri.parse('${baseUrl}showorder/$status'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'makerID': storedMakerId,
        },
      );

      print("Response showOrder: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse.containsKey("data")) {
          final data = jsonResponse["data"];

          if (data is List) {
            return data.cast<Map<String, dynamic>>();
          } else if (data is Map<String, dynamic>) {
            return [data];
          }
        }
      }
      return [];
    } catch (e) {
      print("Error showOrder: $e");
      return [];
    }
  }


    //cetaknota 


    Future<List<Map<String, dynamic>>> cetakNota(String id) async {
      try {
        final token = await _getToken();
        if (token == null) {
          print("Token tidak ditemukan, harap login kembali.");
          return [];
        }

        final prefs = await SharedPreferences.getInstance();
        final storedMakerId = prefs.getString("maker_id") ?? makerID;

        final response = await http.get(
          Uri.parse('${baseUrl}cetaknota/$id'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'makerID': storedMakerId,
          },
        );

        print("Response cetakNota: ${response.body}");

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);

          if (jsonResponse is Map<String, dynamic> &&
              jsonResponse.containsKey("data")) {
            final data = jsonResponse["data"];

            if (data is List) {
              return data.cast<Map<String, dynamic>>();
            } else if (data is Map<String, dynamic>) {
              return [data];
            }
          }
        }
        return [];
      } catch (e) {
        print("Error cetakNota: $e");
        return [];
      }
    }


    Future<List<int>> getAllFoodMenuIds() async{
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("access_token");
      var headers = {
          "Authorization": "Bearer $token",
          'Content-Type': 'application/json',
          "makerID": makerID
        };

        try{
          //fetch(ambil dari server) food menu
          var responseFood = await http.post(
            Uri.parse('$baseUrl/getmenufood'),
            body: {"search" : ""},
            headers: headers,
          );

          //fetch menu minuman 
          var responseDrink = await http.post(
            Uri.parse("$baseUrl/getmenudrink"),
            body: {"search": ""},
            headers: headers
          );

          if (responseFood.statusCode == 200 && responseDrink.statusCode == 200){
            List<int> menuIds = [];

            Map<String,dynamic> foodData = jsonDecode(responseFood.body);
            Map<String,dynamic> drinkData = jsonDecode(responseDrink.body);

            for (var item in foodData["data"]){
              menuIds.add(item['id_menu']);
            }

            for (var item in drinkData['data']){
              menuIds.add(item['id_menu']);
            }

            return menuIds;
          } else {
            print("Failed to fetch menu, status: ${responseFood.statusCode}, ${responseDrink.statusCode}");
            return[];
          }
 
        }catch (e){
          print("Error fetching menu Ids: $e");
          return[];
      }
    }

    Future <String?> getFoodName (int idMenu) async{
      try{
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString("access_token");

        if (token == null){
          print("token tidak ditemukan, harap login");
          return null;
        }

        var headers = {
        "Authorization": "Bearer $token",
        'Content-Type': 'application/json',
        "makerID": makerID
        };

        print("Fetching food and drink menu");

        final foodResponse = await http.post(
          Uri.parse('$baseUrl/getmenufood'),
          body: jsonEncode({"search": ""}),
          headers: headers,
        );

        final drinkResponse = await http.post(
          Uri.parse('$baseUrl/getmenudrink'),
          body: jsonEncode({"search": ""}),
          headers: headers,
        );

if (foodResponse.statusCode == 200) {
        final foodData = jsonDecode(foodResponse.body);
        print("Food Menu Response: ${foodData["data"]}"); // Debugging

        for (var item in foodData["data"]) {
          if (item["id_menu"] == idMenu) {
            print("Ditemukan di makanan: ${item["nama_makanan"]}");
            return item["nama_makanan"];
          }
        }
      } else {
        print(
            "Gagal mendapatkan makanan, status code: ${foodResponse.statusCode}");
      }

      if (drinkResponse.statusCode == 200) {
        final drinkData = jsonDecode(drinkResponse.body);
        print("Drink Menu Response: ${drinkData["data"]}"); // Debugging

        for (var item in drinkData["data"]) {
          if (item["id_menu"] == idMenu) {
            print("Ditemukan di minuman: ${item["nama_makanan"]}");
            return item["nama_makanan"];
          }
        }
      } else {
        print(
            "Gagal mendapatkan minuman, status code: ${drinkResponse.statusCode}");
      }

      return null;
    } catch (e) {
      print("Error getFoodName: $e");
      return null;
      }
    }

    

    Future<bool> pesanMakanan(int idStan, List<Pesanan> pesanan) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        throw Exception('Token tidak ditemukan, harap login kembali.');
      }

      // Bangun parameter pesan[] dalam bentuk array query
      final queryParams = {
        'id_stan': idStan.toString(),
        for (int i = 0; i < pesanan.length; i++) ...{
          'pesan[$i][id_menu]': pesanan[i].idMenu.toString(),
          'pesan[$i][qty]': pesanan[i].qty.toString(),
        }
      };

      final url =
          Uri.parse('${baseUrl}pesan').replace(queryParameters: queryParams);

      final headers = {
        'Authorization': 'Bearer $token',
        'makerID': '55',
      };

      final response = await http.get(url, headers: headers);

      print('[DEBUG] URL: $url');
      print('[DEBUG] Status Code: ${response.statusCode}');
      print('[DEBUG] Response Body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print("⚠️ Terjadi kesalahan saat memesan makanan: $e");
      return false;
    }
  }

    Future<Map<String, dynamic>> pesan() async{
      try{
        final token = await _getToken();
        if (token==null){
          print("token tidak ditemukan silakan login kembali");
          return{};
        }

        final response = await http.get(
          Uri.parse('${baseUrl}pesan'),
          headers: {
          "Authorization": "Bearer $token",
          'Content-Type': 'application/json',
          'makerID': makerID,
          },
          
        );



        print("Response Body: ${response.body}");

        if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse.containsKey("data")) {
          return jsonResponse["data"];
        }
      } else {
        print(
            "Gagal mengambil data, status code: ${response.statusCode},");
        }
      } catch (e) {
        print("Error Pesan: $e");
      }
      return {};
    }


    //stan
    
    //loginstand
  Future<Map<String,dynamic>> loginStand({
    required String username,
    required String password,
  }) async {
    var response = 
      await _login('${baseUrl}login_stan', username, password, 'admin_stan');

    print("Response API: $response");

    if (response['success']){
      var user = response['user'];
      
      if (user != null && user ['maker_id'] != null){
        String makerID = user['maker_id'].toString();

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('maker_id', makerID);

        print("makerID berhasil disimpan: $makerID");
      }

      else{
        print("Warning: MakerID tidak ditemukan dalam response");
      }
    }

    return response;
  }

    Future<bool> registerStan ({
      required String namaLengkap,
      required String email,
      required String username,
      required String password,
      required String namaStan,
      required String namaPemilik,
      required String telp,
    }) async{
      try{
        var request = 
        http.MultipartRequest('POST', Uri.parse('${baseUrl}register_stan'))
        ..headers.addAll(await _getAuthHeaders())
        ..fields.addAll({
          'nama_lengkap': namaLengkap,
          'email': email,
          'username': username,
          'password': password,
          'nama_stan': namaStan,
          'nama_pemilik': namaPemilik,
          'telp': telp,
        });

        var response = await request.send();
        var responseBody = await response.stream.bytesToString();
        print("register stand response: $responseBody");

        return response.statusCode == 200;
      } catch(e){
        print("exception: $e");
        return false;
      }
    }

    Future <bool> updateStan ({
      required int id,
      required String namaStan,
      required String namaPemilik,
      required String telp,
      required String username,

    }) async {
      var uri = Uri.parse("$baseUrl/update_stan/$id");

      var request = http.MultipartRequest("POST", uri);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("access_token");
      request.headers.addAll({
        "Authorization": "Bearer $token",
        'Content-Type': 'application/json',
        'makerID': makerID,
      });

      request.fields['nama_stan'] = namaStan;
      request.fields['nama_pemilik'] = namaPemilik;
      request.fields['telp'] = telp;
      request.fields['username'] = username;
      request.fields['maker_id'] = "55";

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseBody);

      if (response.statusCode == 200 && jsonResponse['status'] == true){
        print("Update sukses: ${jsonResponse['message']}");
        return true;
      } else {
        print("Update gagal: ${jsonResponse['message']}");
        return false; 
      }
    }

    //GET STAN
    Future <List<dynamic>> getStan() async {
      try{
        final token = await _getToken();
        if (token==null){
          return [];
        }

        final prefs = await SharedPreferences.getInstance();
        final storedMakerId = prefs.getString("makerID") ?? '55';

        final response = await http.get(
          Uri.parse('${baseUrl}get_stan'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'makerID': storedMakerId,
          }
        );

        if (response.statusCode == 200){
          final jsonResponse = jsonDecode(response.body);
          if (jsonResponse is Map<String,dynamic> && jsonResponse.containsKey("data")){
            final data = jsonResponse["data"];

            if (data is List){
              return data;
            } else if (data is Map<String,dynamic>){
              return [data];
            }
          }
        }

        return[];
      }catch(e){
        print("error getStan: $e");
        return[];
      }
    }

    Future <bool> ubahSiswa({
    required int id,
    required String namaSiswa,
    required String email,
    required String username,
    required String alamat,
    required String noTelp,
    File? foto,
  }) async{
    var uri = Uri.parse('$baseUrl/ubah_siswa/$id');

    var request = http.MultipartRequest("POST", uri);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");
    request.headers.addAll({
      "Authorization": "Bearer $token",
      "makerID": makerID,
    });

    request.fields['nama_siswa'] = namaSiswa;
    request.fields['email'] = email;
    request.fields['username'] = username;
    request.fields['maker_id'] = makerID;
    request.fields['alamat'] = alamat;
    request.fields['telp'] = noTelp;

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


    //SHOW MENU
    Future<List<dynamic>> showMenu() async{
      try{
      final token = await _getToken();
      final response = await http.post(
        Uri.parse('${baseUrl}showmenu'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'makerID': makerID,
        },
      );

      print("Response Show Menu: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        return responseData['data'] ?? [];
      } else {
        return [];
      }
    } catch (e) {
      print("Error Show Menu: $e");
      return [];
      }
    }


    //TAMBAH MENU
    Future <bool> tambahMenu({
      required String namaMakanan,
      required String jenis,
      required String harga,
      required String deskripsi,
      required int makerID,
      File? foto,
    }) async{
      try {

        var request = http.MultipartRequest('POST', Uri.parse('${baseUrl}tambahmenu'))
        ..headers.addAll(await _getAuthHeaders())
        ..fields.addAll({
          'nama_makanan' : namaMakanan,
          'jenis': jenis,
          'harga': harga,
          'deskripsi': deskripsi,
          'makerID': makerID.toString(),
        });

        if (foto != null){
          request.files.add(await http.MultipartFile.fromPath('foto', foto.path));
        }

        var response = await request.send();
        var responseBody = await response.stream.bytesToString();
        print ('Tambah menu response: $responseBody');

        return response.statusCode == 200;

      } catch(e){
        print('Exception occured: $e');
        return false;
      }
    }


    //HAPUS MENU
    Future<bool> hapusMenu({required String menuID}) async{
      try {
      var response = await http.delete(
        Uri.parse('${baseUrl}hapus_menu/$menuID'),
        headers: await _getAuthHeaders(),
        body: jsonEncode({'id': menuID}),
      );

      print("Response Hapus Menu: ${response.body}");

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error hapusMenu: $e");
      return false;
      }
    }



    //GET PEMASUKAN 
    Future <List<dynamic>> getPemasukan (String tanggal) async {
      try {
        final token = await _getToken();
        if (token == null){
          print("Token tidak ditemukan, harap login lagi");
          return [];
        }

        final prefs = await SharedPreferences.getInstance();
        final storedMakerId = prefs.getString("maker_id")?? makerID;

        final response = await http.get(
          Uri.parse('${baseUrl}showpemasukanbybulan/$tanggal'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'makerID': storedMakerId,
          },
        );

        print("response getPemasukan: ${response.body}");

        if (response.statusCode == 200){
          final jsonResponse = jsonDecode(response.body);

          if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey("data")){
            final data = jsonResponse ["data"];

            if (data is List){
              return data;
            } else if (data is Map<String,dynamic>){
              return [data];
            }
          }
        }

        return[];
      } catch (e){
        print("error getPemasukan: $e");
        return [];
      }
    }

    //GET ORDER ADMIN 
    Future<List<Map<String, dynamic>>> getOrderAdmin(String status) async {
    try {
      final token = await _getToken();
      if (token == null) {
        print("Token tidak ditemukan, harap login kembali.");
        return [];
      }

      final prefs = await SharedPreferences.getInstance();
      final storedMakerId = prefs.getString("maker_id") ?? makerID;

      final response = await http.get(
        Uri.parse('${baseUrl}getorder/$status'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'makerID': storedMakerId,
        },
      );

      print("Response getOrder: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse.containsKey("data")) {
          final data = jsonResponse["data"];

          if (data is List) {
            return data.cast<Map<String, dynamic>>();
          } else if (data is Map<String, dynamic>) {
            return [data];
          }
        }
      }
      return [];
    } catch (e) {
      print("Error getOrder: $e");
      return [];
    }
  }



    //GET ORDER ADMIN BELUM 
    Future<List<Map<String,dynamic>>> getOrderAdminBelum() async{
      try {
      final token = await _getToken();
      if (token == null) {
        print("Token tidak ditemukan, harap login kembali.");
        return [];
      }

      final prefs = await SharedPreferences.getInstance();
      final storedMakerId = prefs.getString("maker_id") ?? makerID;

      final response = await http.get(
        Uri.parse('${baseUrl}getorder/belum dikonfirm'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'makerID': storedMakerId,
        },
      );

      print("Response getOrder: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse.containsKey("data")) {
          final data = jsonResponse["data"];

          if (data is List) {
            return data.cast<Map<String, dynamic>>();
          } else if (data is Map<String, dynamic>) {
            return [data];
          }
        }
      }
      return [];
    } catch (e) {
      print("Error getOrder: $e");
      return [];
    }
  }



  //GET ORDER ADMIN SELESAI
  Future<List<Map<String, dynamic>>> getOrderAdminSelesai() async {
    try {
      final token = await _getToken();
      if (token == null) {
        print("Token tidak ditemukan, harap login kembali.");
        return [];
      }

      final prefs = await SharedPreferences.getInstance();
      final storedMakerId = prefs.getString("maker_id") ?? makerID;

      final response = await http.get(
        Uri.parse('${baseUrl}getorder/sampai'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'makerID': storedMakerId,
        },
      );

      print("Response getOrder: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse.containsKey("data")) {
          final data = jsonResponse["data"];

          if (data is List) {
            return data.cast<Map<String, dynamic>>();
          } else if (data is Map<String, dynamic>) {
            return [data];
          }
        }
      }
      return [];
    } catch (e) {
      print("Error getOrder: $e");
      return [];
    }
  }

  Future<bool> updateOrderStatus(String idPesanan, String status) async{
     try {
      final token = await _getToken();
      if (token == null) {
        print("Token tidak ditemukan, harap login kembali.");
        return false;
      }

      final prefs = await SharedPreferences.getInstance();
      final storedMakerId = prefs.getString("maker_id") ?? makerID;

      final response = await http.put(
        Uri.parse('${baseUrl}updatestatus/$idPesanan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'makerID': storedMakerId,
        },
        body: jsonEncode({"status": status}),
      );

      print("Response updateOrder: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse["status"] == true;
      }
      return false;
    } catch (e) {
      print("Error updateOrderStatus: $e");
      return false;
    }
  }

  Future<List<dynamic>> showDiskon() async {
      try {
        final token = await _getToken();
        final response = await http.post(
          Uri.parse('${baseUrl}showdiskon'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'makerID': makerID,
          },
        );

        print("Response Show Diskon: ${response.body}");

        if (response.statusCode == 200) {
          var responseData = jsonDecode(response.body);
          return responseData['data'] ?? [];
        } else {
          return [];
        }
      } catch (e) {
        print("Error Show Diskon: $e");
        return [];
      }
    }

  Future<bool> tambahDiskon({
    required String namaDiskon,
    required int presentase,
    required DateTime tanggalMulai,
    required DateTime tanggalSelesai,
  }) async {
    try {
      String makerID = "55";

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${baseUrl}tambahdiskon'),
      )
        ..headers.addAll(await _getAuthHeaders())
        ..fields.addAll({
          'nama_diskon': namaDiskon,
          'persentase_diskon': presentase.toString(),
          'tanggal_awal': tanggalMulai.toIso8601String().split('T')[0],
          'tanggal_akhir': tanggalSelesai.toIso8601String().split('T')[0],
          'makerID': makerID,
        });

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      print('Tambah Diskon Response: $responseBody');

      return response.statusCode == 200;
    } catch (e) {
      print('Exception occurred: $e');
      return false;
    }
  }

  Future <List<dynamic>> getDiskon() async{
    try{
      final token = await _getToken();
      final response = await http.post(
        Uri.parse('${baseUrl}getmenudiskonsiswa'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'makerID': makerID,
        }
      );

      print("Response get diskon: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        return responseData['data'] ?? [];
      } else {
        return [];
      }
    } catch(e){
      print("Error get diskon: $e");
      return[];
    }
  }


  Future<bool> tambahMenuDiskon({
    required int idDiskon,
    required int idMenu,
  }) async{
    try{
      String makerID = "55";
      var request = http.MultipartRequest(
        'POST', 
        Uri.parse('${baseUrl}insert_menu_diskon'),

      )
        ..headers.addAll(await _getAuthHeaders())
        ..fields.addAll({
          'id_diskon': idDiskon.toString(),
          'id_menu': idMenu.toString(),
          'maker_id': makerID

        });

        print('Request URL: ${request.url}');
        print('Fields: ${request.fields}');

        var response = await request.send();
        var responseBody = await response.stream.bytesToString();
        print('Tambah Menu Diskon Response: $responseBody');

        return response.statusCode == 200;
      } catch (e) {
        print('Error di tambahMenuDiskon: $e');
        return false;
      
        }
      }

  Future <List<dynamic>> getDiskonMenu() async{
    try{
      final token = await _getToken();
      final response = await http.post(
        Uri.parse('${baseUrl}getmenudiskon'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'makerID': makerID,
        }
      );

      print("Response get diskon: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        return responseData['data'] ?? [];
      } else {
        return [];
      }
    } catch(e){
      print("Error get diskon: $e");
      return[];
    }
  }

  Future<List<Map<String, dynamic>>> getRekapPemesananStan(String bulan) async {
  try {
    final token = await _getToken();
    if (token == null) {
      print("Token tidak ditemukan, harap login kembali.");
      return [];
    }

    final prefs = await SharedPreferences.getInstance();
    final storedMakerId = prefs.getString("maker_id") ?? makerID;

    final response = await http.get(
      Uri.parse('${baseUrl}showorderbymonth/$bulan'), // <- di sini pakai format YYYY-MM
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'makerID': storedMakerId,
      },
    );

    print("Response showorderbymonth: ${response.body}");

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse is Map<String, dynamic> &&
          jsonResponse.containsKey("data")) {
        final data = jsonResponse["data"];

        if (data is List) {
          return data.cast<Map<String, dynamic>>();
        } else if (data is Map<String, dynamic>) {
          return [data];
        }
      }
    }
    return [];
  } catch (e) {
    print("Error getRekapPemesananStanByMonth: $e");
    return [];
  }
}



Future<Map<String, dynamic>> getRekapPemasukanStan(String bulan) async {
  try {
    final token = await _getToken();
    if (token == null) {
      print("Token tidak ditemukan, harap login kembali.");
      return {};
    }

    final prefs = await SharedPreferences.getInstance();
    final storedMakerId = prefs.getString("maker_id") ?? makerID;

    final response = await http.get(
      Uri.parse('${baseUrl}showpemasukanbybulan/$bulan'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'makerID': storedMakerId,
      },
    );

    print("Response showorderbymonth: ${response.body}");

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey("data")) {
        final data = jsonResponse["data"];

        if (data is Map<String, dynamic> && data.containsKey("data_transaksi")) {
          final transaksiList = data["data_transaksi"] as List;

          int totalPemasukan = 0;

          // Loop untuk hitung pemasukan berdasarkan harga_beli
          for (var transaksi in transaksiList) {
            final detail = transaksi["detailTrans"] as List;

            // Hitung total harga_beli untuk setiap transaksi
            for (var item in detail) {
              final hargaBeliRaw = item["harga_beli"];
              final hargaBeli = hargaBeliRaw is int
                  ? hargaBeliRaw
                  : int.tryParse(hargaBeliRaw.toString()) ?? 0;

              totalPemasukan += hargaBeli; // Akumulasi total pemasukan
            }
          }

          // Return hasil rekap data
          return {
            "bulan": data["bulan"] ?? "Unknown",
            "total_pemasukan": totalPemasukan,
            "data_transaksi": transaksiList,
          };
        }
      }
    }

    return {}; // Jika tidak ada data
  } catch (e) {
    print("Error getRekapPemasukanStanByMonth: $e");
    return {}; // Jika terjadi error
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

  getRekapPemesananStanByMonth(String selectedMonth) {}

}