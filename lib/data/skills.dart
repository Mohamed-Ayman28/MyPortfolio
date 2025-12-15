class Skillslist {
  final String skillName;
  final String imagePath;
  final bool isNetwork;
  final bool isSvg;

  Skillslist({
    required this.skillName,
    required this.imagePath,
    this.isNetwork = false,
    this.isSvg = false,
  });
}
