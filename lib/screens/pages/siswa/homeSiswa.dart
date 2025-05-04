import 'package:flutter/material.dart';
import 'package:kantin2_ukk/screens/components/bottomNavbar.dart';
import 'package:kantin2_ukk/screens/components/cardStan.dart';
import 'package:kantin2_ukk/services/apiServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageSiswa extends StatefulWidget {
  const HomePageSiswa({super.key});

  @override
  State<HomePageSiswa> createState() => _HomePageSiswaState();
}

class _HomePageSiswaState extends State<HomePageSiswa> {
  String? userRole;
  String? userName;
  String? makerId;

  List<Map<String,dynamic>> stanList = [];
  bool isLoading = true;
  String searchQuery = "";

  String capitalizeEachWord(String text) {
  return text.split(' ').map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}


  
  
  @override 
  void initState(){
    super.initState();
    
    checkAuthentication();
    fetchStan();
  }

  Future<void> checkAuthentication() async{
    final prefs = await SharedPreferences.getInstance();
    final apiService = Apiservices();
    final siswaList = await apiService.getProfile();

    if (siswaList.isEmpty){
      if(mounted){
        Navigator.pushReplacementNamed(context, "/login");
      }
      return;
    }

    if(mounted){
      setState(() {
        userRole = "Siswa";
        userName = siswaList[0]["nama_siswa"] ?? "Siswa";
        makerId = prefs.getString("makerID");

        prefs.setString("username", userName!);
        prefs.setInt("id_user", siswaList[0]["id"]);

        print(siswaList);
      });
    }
  }


  Future<void> fetchStan() async{
    final api = Apiservices();
    final result = await api.getAllStan();
    if (mounted){
      setState(() {
        stanList = List<Map<String,dynamic>>.from(result);
        isLoading = false;
      });
    }
  }

  void navigateToStan(int stanId){
    Navigator.push(
      context, MaterialPageRoute(
        builder: (context)=> DefaultTabController(
          length: 3, 
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: TextField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.search),
                          hintText: "Mau makan apa hari ini?",
                          hintStyle: TextStyle(
                            color: Color(0xffD74339),
                            fontFamily: 'Outfit',
                            fontSize: 17,
                            fontWeight: FontWeight.w300,
                          ),
                          border: InputBorder.none,
                        ),
                        onChanged: (query) {
                          setState(() {
                            searchQuery = query;
                          });
                        },
                      ),
                    ),
                  ),
              
                const SizedBox(height: 20),
                        
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  
                  child: TabBar(
                    labelColor: Colors.white,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                    unselectedLabelColor: Colors.black,
                    indicatorColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: const Color.fromRGBO(240, 94, 94, 1),
                      borderRadius: BorderRadius.circular(16),
                      ),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    tabs: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Tab(text: "Semua Menu",),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Tab(text: "Makanan",),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Tab(text: "Minuman",),
                      ),
                    ]
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: TabBarView(
                      children: [
                        CardStan(searchQuery: searchQuery,idStan: stanId,),
                        Padding(
                          padding: const EdgeInsets.only(left: 50),
                          child: CardStan(category: "makanan", searchQuery: searchQuery, idStan: stanId,),
                        ),
                        CardStan(category: "minuman", searchQuery: searchQuery, idStan: stanId,)
                    ]),
                  ))
                ],
              ),
            ),
          ))
        )
      );
  }


  
  @override
  Widget build(BuildContext context) {
    return 
    
    Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
      ? const Center(
        child: CircularProgressIndicator(),
      )
      : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 70),
                child: Text(
                  "Halo, ${userName ?? 'User'}!",
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
      
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24,vertical: 10),
                child: Text(
                  "Ayo pilih stanmu",
                  style: TextStyle(
                    fontFamily: "Outfit",
                    fontSize: 18,
                    fontWeight: FontWeight.w600
                  ),
                ),
            ),


      
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 3/2), 
                  itemCount: stanList.length ,
                  itemBuilder: (context, index){
                    final stan = stanList[index];
                    return InkWell(
                      onTap: () => navigateToStan(stan["id"]),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                
                        ),
                
                        elevation: 4,
                        color: Color(0xffe8dccc),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${capitalizeEachWord(stan["nama_stan"] ?? stan["nama_stan"])}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Outfit",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              Text(
                                "Kantin ${capitalizeEachWord(stan["nama_pemilik"] ?? stan["nama_stan"])}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Outfit",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                
                  }
                ),
              )
            )

      
      
          ],
      ),

      bottomNavigationBar: const BottomNavbar(),
    );
    
  }
}