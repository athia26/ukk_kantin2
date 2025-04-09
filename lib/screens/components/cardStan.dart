import 'package:flutter/material.dart';
import 'package:kantin2_ukk/screens/pages/siswa/menuStanSiswa.dart';

class CardStan extends StatefulWidget {
  const CardStan({super.key});

  @override
  State<CardStan> createState() => _CardStanState();
}

class _CardStanState extends State<CardStan> {
  @override
  Widget build(BuildContext context) {

    List <Map<String, dynamic>> stans = [
      {
        'nama': 'Pak Yoyok',
        'image': 'lib/assets/makanan.jpg',
        'rate': '4.9',
       
        'makanan': [
          {
            'name': 'Nasi tempe', 
            'desc': 'enak bet dah',
            'harga': 10000,
            'imageItem': 'lib/assets/nasitempe.jpg'
            },
          {
            'name': 'Nasi telor', 
            'desc': 'enak bet dah',
            'harga': 10000,
            'imageItem': 'lib/assets/nasitelor.jpg'
            },
        ],
        'minuman': [
          {
            'name': 'es teh', 
            'desc': 'enak bet dah',
            'harga': 3000,
            'imageItem': 'lib/assets/esteh.jpg'
            },
          {
            'name': 'es jeruk', 
            'desc': 'enak bet dah',
            'harga': 4000,
            'imageItem': 'lib/assets/esjeruk.jpg'
            },
        ],
      },
      {
        'nama': 'Bu Sari',
        'image': 'lib/assets/makanan.jpg',
        'rate': '4.5',
        'makanan': [
          {
            'name': 'Ayam geprek', 
            'desc': 'enak bet dah',
            'harga': 12000,
            'imageItem': 'lib/assets/geprek.jpg'
            },
          {
            'name': 'Nasi uduk', 
            'desc': 'enak bet dah',
            'harga': 15000,
            'imageItem': 'lib/assets/nasiuduk.jpg'
            },
        ],
        'minuman': [
          {
            'name': 'es teh', 
            'desc': 'enak bet dah',
            'harga': 3000,
            'imageItem': 'lib/assets/esteh.jpg'
            },
          {
            'name': 'es jeruk', 
            'desc': 'enak bet dah',
            'harga': 4000,
            'imageItem': 'lib/assets/esjeruk.jpg'
            },
        ],
      },

      {
        'nama': 'Pak Sholeh',
        'image': 'lib/assets/makanan.jpg',
        'rate': '4.8',
        'makanan': [
          {
            'name': 'Nasi tempe', 
            'desc': 'enak bet dah',
            'harga': 7000,
            'imageItem': 'lib/assets/nasitempe.jpg'
            },
          {
            'name': 'Nasi telor', 
            'desc': 'enak bet dah',
            'harga': 10000,
            'imageItem': 'lib/assets/nasitelor.jpg'},
        ],
        'minuman': [
          {
            'name': 'es teh', 
            'desc': 'enak bet dah',
            'harga': 3000,
            'imageItem': 'lib/assets/esteh.jpg'
            },
          {
            'name': 'es jeruk', 
            'desc': 'enak bet dah',
            'harga': 4000,
            'imageItem': 'lib/assets/esjeruk.jpg'
            },
        ],
      },

      {
        'nama': 'Bu Rani',
        'image': 'lib/assets/makanan.jpg',
        'rate': '4.6',
        'makanan': [
          {
            'name': 'Nasi pecel', 
            'desc': 'enak bet dah',
            'harga': 8000,
            'imageItem': 'lib/assets/nasipecel.jpg'
            },
          {
            'name': 'Lontong sayur', 
            'desc': 'enak bet dah',
            'harga': 15000,
            'imageItem': 'lib/assets/lonsay.jpg'
            },
        ],
        'minuman': [
          {
            'name': 'es teh', 
            'desc': 'enak bet dah',
            'harga': 3000,
            'imageItem': 'lib/assets/esteh.jpg'
            },
          {
            'name': 'es jeruk', 
            'desc': 'enak bet dah',
            'harga': 4000,
            'imageItem': 'lib/assets/esjeruk.jpg'
            },
        ],
      },

      {
        'nama': 'Bu Inul',
        'image': 'lib/assets/makanan.jpg',
        'rate': '4.6',
        'makanan': [
          {
            'name': 'Nasi pecel', 
            'desc': 'enak bet dah',
            'harga': 8000,
            'imageItem': 'lib/assets/nasipecel.jpg'
            },
          {
            'name': 'Lontong sayur', 
            'desc': 'enak bet dah',
            'harga': 15000,
            'imageItem': 'lib/assets/lonsay.jpg'
            },
        ],
        'minuman': [
          {
            'name': 'es teh', 
            'desc': 'enak bet dah',
            'harga': 3000,
            'imageItem': 'lib/assets/esteh.jpg'
            },
          {
            'name': 'es jeruk', 
            'desc': 'enak bet dah',
            'harga': 4000,
            'imageItem': 'lib/assets/esjeruk.jpg'
            },
        ],
      },

    ];
    return ListView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: stans.length,
      itemBuilder: (context, index) {
        final stan = stans[index];
        return InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MenuStanSiswa(stans: stan)));
          },
          child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xffE8DCCC),
                  width: 2.5),
                borderRadius: const BorderRadius.all(Radius.circular(20))
              ),
              margin: const EdgeInsets.only(bottom: 8, left: 13, right: 13),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        stan ['image']!,
                        width: 120,
                        
                      ),
                    ),
                  ),
          
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10,27,10,10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            stan['nama']!,
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 27,
                              fontWeight: FontWeight.w700,
                              color: Color(0xffD74339),
                            ),
                          ),
          
                          Text(
                            (stan['makanan'] as List <Map<String, dynamic>>)
                            .map((makanan) => makanan ['name'])
                            .join(', '),
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                              color: Color(0xffD74339),
                            ),
                          ),
          
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.star_rate_rounded, color: Color(0xffFFD700)),
                               Text(stan['rate'], 
                               style: const TextStyle(
                                  fontFamily: 'Outfit',
                                  fontWeight: FontWeight.w300,
                                  fontSize: 17,
                                  color: Color(0xffD74339),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ),
        );
      },
    );
  }
}