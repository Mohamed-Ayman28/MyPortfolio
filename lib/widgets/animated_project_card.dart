import 'package:flutter/material.dart';
import 'package:my_portfolio/models/project_model.dart';
import 'package:url_launcher/url_launcher.dart';

class AnimatedProjectCard extends StatefulWidget {
  final ProjectModel project;
  final int index;

  const AnimatedProjectCard({
    super.key,
    required this.project,
    required this.index,
  });

  @override
  State<AnimatedProjectCard> createState() => _AnimatedProjectCardState();
}

class _AnimatedProjectCardState extends State<AnimatedProjectCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isHovered = false;
  final ScrollController _scrollController = ScrollController();
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: widget.index * 150), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  void _showFullScreenImage(BuildContext context, int initialIndex) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.95),
      builder: (context) => _FullScreenImageViewer(
        images: widget.project.images,
        initialIndex: initialIndex,
        projectTitle: widget.project.title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1000;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(opacity: _fadeAnimation.value, child: child),
        );
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 40,
            vertical: 20,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xff1a2a3a),
                const Color(0xff2E4252),
                _isHovered ? const Color(0xff3a5a6a) : const Color(0xff2E4252),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? Colors.cyan.withValues(alpha: 0.4)
                    : Colors.black.withValues(alpha: 0.4),
                blurRadius: _isHovered ? 40 : 20,
                offset: const Offset(0, 12),
                spreadRadius: _isHovered ? 8 : 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProjectHeader(isMobile),
                _buildImageGallery(isMobile, isTablet),
                _buildImageNavigation(),
                _buildContentSection(isMobile),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectHeader(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.cyan.withValues(alpha: 0.1), Colors.transparent],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.cyan, Colors.blue, Colors.purple],
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyan.withValues(alpha: 0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: Text(
                "0${widget.index + 1}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.project.title,
                  style: TextStyle(
                    fontSize: isMobile ? 22 : 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.folder_outlined,
                      size: 14,
                      color: Colors.cyan.withValues(alpha: 0.8),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Flutter Project",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.image_outlined,
                      size: 14,
                      color: Colors.cyan.withValues(alpha: 0.8),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "${widget.project.images.length} Screenshots",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildGithubButton(),
        ],
      ),
    );
  }

  Widget _buildImageGallery(bool isMobile, bool isTablet) {
    final imageHeight = isMobile ? 420.0 : (isTablet ? 500.0 : 550.0);
    final cardWidth = isMobile
        ? MediaQuery.of(context).size.width * 0.78
        : (isTablet ? 340.0 : 400.0);

    return Container(
      height: imageHeight,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            final itemWidth = cardWidth + 16;
            final newIndex = (_scrollController.offset / itemWidth).round();
            if (newIndex != _currentImageIndex &&
                newIndex >= 0 &&
                newIndex < widget.project.images.length) {
              setState(() => _currentImageIndex = newIndex);
            }
          }
          return true;
        },
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: widget.project.images.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _showFullScreenImage(context, index),
              child: _buildImageCard(index, cardWidth, imageHeight),
            );
          },
        ),
      ),
    );
  }

  Widget _buildImageCard(int index, double width, double height) {
    final isActive = _currentImageIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: width,
      height: height,
      margin: EdgeInsets.only(
        right: 16,
        top: isActive ? 0 : 20,
        bottom: isActive ? 0 : 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive
              ? Colors.cyan.withValues(alpha: 0.8)
              : Colors.white.withValues(alpha: 0.1),
          width: isActive ? 3 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isActive
                ? Colors.cyan.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.3),
            blurRadius: isActive ? 25 : 10,
            offset: const Offset(0, 8),
            spreadRadius: isActive ? 5 : 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Full Image Container
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color(0xff0a1520),
              child: Image.asset(
                widget.project.images[index],
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          // Gradient Overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.85),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Image Number Badge
          Positioned(
            bottom: 14,
            left: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.cyan.withValues(alpha: 0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.photo, color: Colors.cyan, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    "${index + 1} / ${widget.project.images.length}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Expand Icon
          Positioned(
            bottom: 14,
            right: 14,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.cyan, Colors.blue],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyan.withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.fullscreen_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageNavigation() {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet =
        MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 1000;
    final cardWidth = isMobile
        ? MediaQuery.of(context).size.width * 0.78
        : (isTablet ? 340.0 : 400.0);
    final itemWidth = cardWidth + 16;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous Button
          _buildNavButton(
            icon: Icons.arrow_back_ios_rounded,
            onTap: () {
              if (_currentImageIndex > 0) {
                _scrollController.animateTo(
                  (_currentImageIndex - 1) * itemWidth,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              }
            },
            isEnabled: _currentImageIndex > 0,
          ),
          const SizedBox(width: 20),
          // Page Indicators
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              widget.project.images.length,
              (index) => GestureDetector(
                onTap: () {
                  _scrollController.animateTo(
                    index * itemWidth,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: _currentImageIndex == index ? 30 : 12,
                  height: 12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    gradient: _currentImageIndex == index
                        ? const LinearGradient(
                            colors: [Colors.cyan, Colors.blue],
                          )
                        : null,
                    color: _currentImageIndex == index ? null : Colors.white24,
                    boxShadow: _currentImageIndex == index
                        ? [
                            BoxShadow(
                              color: Colors.cyan.withValues(alpha: 0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          // Next Button
          _buildNavButton(
            icon: Icons.arrow_forward_ios_rounded,
            onTap: () {
              if (_currentImageIndex < widget.project.images.length - 1) {
                _scrollController.animateTo(
                  (_currentImageIndex + 1) * itemWidth,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              }
            },
            isEnabled: _currentImageIndex < widget.project.images.length - 1,
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isEnabled,
  }) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isEnabled
              ? LinearGradient(
                  colors: [
                    Colors.cyan.withValues(alpha: 0.3),
                    Colors.blue.withValues(alpha: 0.3),
                  ],
                )
              : null,
          color: isEnabled ? null : Colors.white.withValues(alpha: 0.05),
          border: Border.all(
            color: isEnabled
                ? Colors.cyan.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.1),
            width: 2,
          ),
        ),
        child: Icon(
          icon,
          color: isEnabled ? Colors.cyan : Colors.white24,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildContentSection(bool isMobile) {
    return Padding(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Badge
          Row(
            children: [
              _buildStatusBadge(),
              const SizedBox(width: 12),
              _buildCategoryBadge(),
            ],
          ),
          const SizedBox(height: 20),

          // Description
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.cyan.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: Colors.cyan,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  widget.project.description,
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    color: Colors.white.withValues(alpha: 0.85),
                    height: 1.7,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Technologies
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.code_rounded,
                  color: Colors.purple,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              const Text(
                "Tech Stack",
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: widget.project.technologies.asMap().entries.map((entry) {
              final colors = [
                [Colors.cyan, Colors.blue],
                [Colors.purple, Colors.pink],
                [Colors.orange, Colors.deepOrange],
                [Colors.green, Colors.teal],
              ];
              final colorPair = colors[entry.key % colors.length];

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorPair[0].withValues(alpha: 0.2),
                      colorPair[1].withValues(alpha: 0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: colorPair[0].withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorPair[0].withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getTechIcon(entry.value),
                      color: colorPair[0],
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      entry.value,
                      style: TextStyle(
                        color: colorPair[0],
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          // Features Section
          if (widget.project.features.isNotEmpty) ...[
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.star_rounded,
                    color: Colors.green,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                const Text(
                  "Key Features",
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.project.features.map((feature) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.green.withValues(alpha: 0.8),
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        feature,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    final statusColors = {
      'completed': Colors.green,
      'in-progress': Colors.orange,
      'maintained': Colors.blue,
    };
    final statusIcons = {
      'completed': Icons.check_circle,
      'in-progress': Icons.pending,
      'maintained': Icons.update,
    };

    final color = statusColors[widget.project.status] ?? Colors.grey;
    final icon = statusIcons[widget.project.status] ?? Icons.circle;
    final label = widget.project.status.replaceAll('-', ' ').toUpperCase();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBadge() {
    final categoryIcons = {
      'mobile': Icons.phone_android,
      'web': Icons.web,
      'desktop': Icons.desktop_windows,
    };

    final icon = categoryIcons[widget.project.category] ?? Icons.devices;
    final label = widget.project.category.toUpperCase();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.purple.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.purple.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.purple, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.purple,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTechIcon(String tech) {
    switch (tech.toLowerCase()) {
      case 'flutter':
        return Icons.flutter_dash;
      case 'firebase':
        return Icons.local_fire_department;
      case 'bloc':
        return Icons.widgets;
      case 'clean architecture':
        return Icons.architecture;
      case 'sqlite':
        return Icons.storage;
      case 'provider':
        return Icons.account_tree;
      case 'rest api':
        return Icons.api;
      case 'google maps':
        return Icons.map;
      default:
        return Icons.code;
    }
  }

  Widget _buildGithubButton() {
    return GestureDetector(
      onTap: () => _launchURL(widget.project.githubUrl),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          gradient: _isHovered
              ? const LinearGradient(colors: [Colors.cyan, Colors.blue])
              : LinearGradient(
                  colors: [
                    Colors.cyan.withValues(alpha: 0.15),
                    Colors.blue.withValues(alpha: 0.15),
                  ],
                ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.cyan.withValues(alpha: _isHovered ? 0.8 : 0.4),
            width: 2,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.cyan.withValues(alpha: 0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.code_rounded,
              color: _isHovered ? Colors.white : Colors.cyan,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              "GitHub",
              style: TextStyle(
                color: _isHovered ? Colors.white : Colors.cyan,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Full Screen Image Viewer Widget
class _FullScreenImageViewer extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final String projectTitle;

  const _FullScreenImageViewer({
    required this.images,
    required this.initialIndex,
    required this.projectTitle,
  });

  @override
  State<_FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<_FullScreenImageViewer> {
  late PageController _pageController;
  late int _currentIndex;
  final TransformationController _transformController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Image PageView with Zoom
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
              _transformController.value = Matrix4.identity();
            },
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return InteractiveViewer(
                transformationController: _transformController,
                minScale: 0.5,
                maxScale: 5.0,
                child: Center(
                  child: Image.asset(widget.images[index], fit: BoxFit.contain),
                ),
              );
            },
          ),

          // Top Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 10,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.9),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.projectTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.photo,
                              color: Colors.cyan,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "${_currentIndex + 1} of ${widget.images.length}",
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Reset Zoom Button
                  GestureDetector(
                    onTap: () {
                      _transformController.value = Matrix4.identity();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.cyan.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.cyan.withValues(alpha: 0.5),
                        ),
                      ),
                      child: const Icon(
                        Icons.fit_screen_rounded,
                        color: Colors.cyan,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Navigation
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Page Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.images.length,
                    (index) => GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width: _currentIndex == index ? 28 : 10,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: _currentIndex == index
                              ? const LinearGradient(
                                  colors: [Colors.cyan, Colors.blue],
                                )
                              : null,
                          color: _currentIndex == index ? null : Colors.white38,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Navigation Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFullScreenNavButton(
                      icon: Icons.arrow_back_ios_rounded,
                      onTap: _currentIndex > 0
                          ? () => _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            )
                          : null,
                    ),
                    const SizedBox(width: 50),
                    _buildFullScreenNavButton(
                      icon: Icons.arrow_forward_ios_rounded,
                      onTap: _currentIndex < widget.images.length - 1
                          ? () => _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            )
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullScreenNavButton({
    required IconData icon,
    VoidCallback? onTap,
  }) {
    final isEnabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isEnabled
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.05),
          shape: BoxShape.circle,
          border: Border.all(
            color: isEnabled
                ? Colors.cyan.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.1),
            width: 2,
          ),
        ),
        child: Icon(
          icon,
          color: isEnabled ? Colors.white : Colors.white24,
          size: 24,
        ),
      ),
    );
  }
}
