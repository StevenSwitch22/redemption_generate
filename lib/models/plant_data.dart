class PlantItem {
  final String id;
  final String name;
  final String imagePath;

  PlantItem({
    required this.id,
    required this.name,
    required this.imagePath,
  });

  String get imageAsset => 'assets/images/plant_$id.png';
}

class CostumeItem {
  final String id;
  final String name;
  final String imagePath;

  CostumeItem({
    required this.id,
    required this.name,
    required this.imagePath,
  });

  String get imageAsset => 'assets/images/costume_$id.jpg';
}
