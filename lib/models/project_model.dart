class ProjectModel {
  final String title;
  final String description;
  final String githubUrl;
  final List<String> images;
  final List<String> technologies;
  final String icon;
  final String? liveUrl;
  final String status; // "completed", "in-progress", "maintained"
  final String category; // "mobile", "web", "desktop"
  final List<String> features;
  final String? playStoreUrl;
  final String? appStoreUrl;

  const ProjectModel({
    required this.title,
    required this.description,
    required this.githubUrl,
    required this.images,
    required this.technologies,
    this.icon = 'flutter',
    this.liveUrl,
    this.status = 'completed',
    this.category = 'mobile',
    this.features = const [],
    this.playStoreUrl,
    this.appStoreUrl,
  });
}
