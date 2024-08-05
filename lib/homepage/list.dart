class RateItem {
  final String itemName;
  final double rate;

  RateItem({required this.itemName, required this.rate});

  factory RateItem.fromJson(Map<String, dynamic> json) {
    print("Creating RateItem from JSON: $json");
    return RateItem(
       itemName: json['itemName'] as String,
      rate: (json['rate'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'rate': rate,
    };
  }
}
