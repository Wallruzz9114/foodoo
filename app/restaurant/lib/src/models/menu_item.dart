class MenuItem {
  MenuItem({
    required this.name,
    required this.description,
    required this.unitPrice,
    this.imageUrls,
  });

  final String name;
  final String description;
  final double unitPrice;
  List<String>? imageUrls;
}
