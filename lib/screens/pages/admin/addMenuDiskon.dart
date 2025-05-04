import 'package:flutter/material.dart';
import 'package:kantin2_ukk/services/apiServices.dart';

class AddMenuDiskon extends StatefulWidget {
  final int idDiskon;
  final int idStan;
  const AddMenuDiskon({super.key, required this.idDiskon, required this.idStan});

  @override
  State<AddMenuDiskon> createState() => _AddMenuDiskonState();
}

class _AddMenuDiskonState extends State<AddMenuDiskon> {
  List<Map<String,dynamic>> daftarAllMenu = [];
  Set<int> selectedMenuIds = {};
  bool isLoading = true;

  final String baseUrl = 'https://ukk-p2.smktelkom-mlg.sch.id/';

  @override
  void initState(){
    super.initState();
    fetchMenus();

  }

  Future<void> fetchMenus() async{
    final api = Apiservices();

    final makanan = await api.getMenuMakanan();
    final minuman = await api.getMenuMinuman();

    final semuaMenu = [...makanan, ...minuman]
      .cast<Map<String,dynamic>>()
      .where((menu)=> 
        menu['maker_id'].toString() == '55' &&
        menu['id_stan'] == widget.idStan
      ).toList();

      setState(() {
        daftarAllMenu = semuaMenu;
        isLoading = false;
      });
  }

  Future<void> toggleMenuSelection(int idMenu, bool selected) async {
    if (selected){
      final success = await Apiservices().tambahMenuDiskon(
        idDiskon: widget.idDiskon, 
        idMenu: idMenu);

        if (success){
          setState(() {
            selectedMenuIds.add(idMenu);
          });
        }
    } else{
      setState(() {
        selectedMenuIds.remove(idMenu);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      body: isLoading 
        ? Center(child: CircularProgressIndicator(),)
        : ListView.builder(
          itemCount: daftarAllMenu.length,
          itemBuilder: (context, index){
            final menu = daftarAllMenu[index];

            //harga setelah diskon 
            int hargaAsli = menu['harga'];
            int persenDiskon = menu ['persentase_diskon']?? 0;
            int hargaSetelahDiskon = hargaAsli - ((hargaAsli *persenDiskon) ~/100);

            return Card(
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    '$baseUrl${menu["foto"]}',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => 
                      Image.asset("lib/assets/placehorder.jpg", width: 50, height: 50),
                  ),
                ),
                title: Text(menu['nama_makanan']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Harga asli: Rp $hargaAsli',
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'Diskon $persenDiskon% → Rp $hargaSetelahDiskon',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                trailing: Checkbox(
                  value: selectedMenuIds.contains(menu['id']), 
                  onChanged: (bool? selected){
                    if (selected != null){
                      toggleMenuSelection(menu['id'], selected);
                    }
                  }),
              ),
            );
          })
    );
  }
}