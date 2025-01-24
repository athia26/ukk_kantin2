import 'package:flutter/material.dart';

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
          {'name': 'Nasi tempe', 'desc': 'enak bet dah'},
          {'name': 'Nasi telor', 'desc': 'enak bet dah'},
        ],
        'minuman': [
          {'name': 'es teh', 'desc': 'enak bet dah'},
          {'name': 'es jeruk', 'desc': 'enak bet dah'},
        ],
      },
      {
        'nama': 'Bu Sari',
        'image': 'lib/assets/makanan.jpg',
        'rate': '4.5',
        'makanan': [
          {'name': 'Ayam geprek', 'desc': 'enak bet dah'},
          {'name': 'Nasi uduk', 'desc': 'enak bet dah'},
        ],
        'minuman': [
          {'name': 'es teh', 'desc': 'enak bet dah'},
          {'name': 'es jeruk', 'desc': 'enak bet dah'},
        ],
      },

      {
        'nama': 'Pak Sholeh',
        'image': 'lib/assets/makanan.jpg',
        'rate': '4.8',
        'makanan': [
          {'name': 'Nasi tempe', 'desc': 'enak bet dah'},
          {'name': 'Nasi telor', 'desc': 'enak bet dah'},
        ],
        'minuman': [
          {'name': 'es teh', 'desc': 'enak bet dah'},
          {'name': 'es jeruk', 'desc': 'enak bet dah'},
        ],
      },

      {
        'nama': 'Bu Rani',
        'image': 'lib/assets/makanan.jpg',
        'rate': '4.6',
        'makanan': [
          {'name': 'Nasi pecel', 'desc': 'enak bet dah'},
          {'name': 'Lontong sayur', 'desc': 'enak bet dah'},
        ],
        'minuman': [
          {'name': 'es teh', 'desc': 'enak bet dah'},
          {'name': 'es jeruk', 'desc': 'enak bet dah'},
        ],
      },

      {
        'nama': 'Bu Inul',
        'image': 'lib/assets/makanan.jpg',
        'rate': '4.6',
        'makanan': [
          {'name': 'Nasi pecel', 'desc': 'enak bet dah'},
          {'name': 'Lontong sayur', 'desc': 'enak bet dah'},
        ],
        'minuman': [
          {'name': 'es teh', 'desc': 'enak bet dah'},
          {'name': 'es jeruk', 'desc': 'enak bet dah'},
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
                      padding: EdgeInsets.fromLTRB(10,27,10,10),
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
                              ),)
                            ],
                          )
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