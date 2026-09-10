class Station {
  final String id;
  final String gestore;
  final String bandiera;
  final String nome;
  final String indirizzo;
  final String comune;
  final String provincia;

  String? petrolPriceSelf;
  String? petrolPriceServ;
  String? dieselPriceSelf;
  String? dieselPriceServ;

  Station({
    required this.id,
    required this.gestore,
    required this.bandiera,
    required this.nome,
    required this.indirizzo,
    required this.comune,
    required this.provincia,
  });

  String get pumpType {
    if (petrolPriceSelf != null || dieselPriceSelf != null) return 'Self';
    return 'Full';
  }
}

enum SortBy { price, distance }