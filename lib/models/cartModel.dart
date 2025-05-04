class CartItem{
  final int idMenu;
  final String namaMakanan;
  final int harga;
  final String jenis;
  final String foto;
  final String deksripsi;
  final int idStan;
  final String namaStan;
  int quantity;

  CartItem({
    required this.idMenu,
    required this.namaMakanan,
    required this.harga,
    required this.jenis,
    required this.foto,
    required this.deksripsi,
    required this.idStan,
    required this.namaStan,
    this.quantity = 1,
    
  });

  //ambil data dari json (server) langsung diubah jadi objek siap pakai
  factory CartItem.fromJson(Map<String, dynamic> json){
    print("CartItem JSON: $json");



    return CartItem(
    idMenu: json['id_menu'] ?? 0,
    namaMakanan: json['nama_makanan'] ?? '',
    harga: json['harga'] ?? 0,
    jenis: json['jenis'] ?? '',
    foto: json['foto'] ?? '', // error kemungkinan besar dari sini
    deksripsi: json['deskripsi'] ?? '',
    idStan: json['id_stan'] ?? 0,
    namaStan: json['nama_pemilik'] ?? '',
    quantity: json['quantity'] ?? 1,
  );
  }

  //untuk kirim data dari yg diinput user ke server krn toJSON
  Map<String,dynamic> toJson(){
    return{
      'id_menu': idMenu,
      'nama_makanan': namaMakanan,
      'harga': harga,
      'jenis': jenis,
      'deskripsi': deksripsi,
      'id_stan': idStan,
      'nama_pemilik': namaStan,
      'quantity': quantity
    };
  }

}