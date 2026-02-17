import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/navItems.dart';
import 'package:my_portfolio/data/projects.dart';
import 'package:my_portfolio/widgets/animated_project_card.dart';
import 'package:my_portfolio/widgets/animated_stat_card.dart';
import 'package:my_portfolio/widgets/animated_timeline.dart';
import 'package:my_portfolio/widgets/custom_card.dart';
import 'package:my_portfolio/widgets/floating_particles.dart';
import 'package:my_portfolio/widgets/scroll_to_top_button.dart';
import 'package:my_portfolio/widgets/send_email.dart';
import 'package:my_portfolio/widgets/typewriter_text.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  final homeKey = GlobalKey();
  final aboutKey = GlobalKey();
  final educationKey = GlobalKey();
  final skillsKey = GlobalKey();
  final certificatesKey = GlobalKey();
  final projectsKey = GlobalKey();
  final contactKey = GlobalKey();
  final socialKey = GlobalKey();

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Certificate page controller
  final PageController _certPageController = PageController(
    viewportFraction: 0.75,
  );
  int _currentCertPage = 0;

  // Certificates list (including the two latest ones)
  final List<Map<String, String>> certificates = [
    {
      'image': 'assets/images/certifcates/flutter-depi.png',
      'title': 'Flutter Development - DEPI',
    },
    {
      'image': 'assets/images/certifcates/sprints.png',
      'title': 'Sprints Program',
    },
    {
      'image': 'assets/images/certifcates/redhat1.png',
      'title': 'Red Hat System Administration I',
    },
    {
      'image': 'assets/images/certifcates/redhat2.png',
      'title': 'Red Hat System Administration II',
    },
    {
      'image': 'assets/images/certifcates/redhat3.png',
      'title': 'Red Hat System Administration III',
    },
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _certPageController.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<GlobalKey> sectionKeys = [
      homeKey,
      aboutKey,
      educationKey,
      skillsKey,
      certificatesKey,
      projectsKey,
      contactKey,
      socialKey,
    ];

    return Scaffold(
      appBar: _buildAppBar(sectionKeys),
      drawer: MediaQuery.of(context).size.width <= 800
          ? _buildDrawer(sectionKeys)
          : null,
      backgroundColor: const Color(0xff0a0a0a),
      floatingActionButton: ScrollToTopButton(
        scrollController: _scrollController,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ListView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            children: [
              _buildHeroSection(),
              _buildStatsSection(),
              _buildAboutSection(),
              _buildTimelineSection(),
              _buildEducationSection(),
              _buildSkillsSection(),
              _buildCertificatesSection(),
              _buildProjectsSection(),
              _buildContactSection(),
              _buildSocialSection(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(List<GlobalKey> sectionKeys) {
    return AppBar(
      backgroundColor: const Color(0xff0a0a0a),
      elevation: 0,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.cyan, Colors.blue],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset("assets/images/logo.png", width: 40),
            ),
            const SizedBox(width: 12),
            const Text(
              "Mohamed Ayman",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      actions: MediaQuery.of(context).size.width > 800
          ? [
              for (int i = 0; i < pages.length; i++)
                _buildNavButton(
                  pages[i],
                  () => _scrollToSection(sectionKeys[i]),
                ),
              const SizedBox(width: 20),
            ]
          : null,
    );
  }

  Widget _buildNavButton(String text, VoidCallback onTap) {
    return _HoverNavButton(text: text, onTap: onTap);
  }

  Widget? _buildDrawer(List<GlobalKey> sectionKeys) {
    return Drawer(
      backgroundColor: const Color(0xff0a0a0a),
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.cyan.withValues(alpha: 0.2),
                  Colors.blue.withValues(alpha: 0.2),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.cyan, Colors.blue],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Image.asset("assets/images/logo.png", width: 60),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Mohamed Ayman",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          for (int i = 0; i < pages.length; i++)
            ListTile(
              leading: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.cyan,
                size: 16,
              ),
              title: Text(
                pages[i],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _scrollToSection(sectionKeys[i]);
              },
            ),
        ],
      ),
    );
  }

  // ================= HERO SECTION =================
  Widget _buildHeroSection() {
    return FloatingParticles(
      particleCount: 25,
      child: Container(
        key: homeKey,
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xff0a0a0a),
              const Color(0xff1a2a3a).withValues(alpha: 0.8),
              const Color(0xff0a0a0a),
            ],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isMobile = constraints.maxWidth < 800;
            return isMobile ? _buildMobileHero(constraints) : _buildDesktopHero();
          },
        ),
      ),
    );
  }

  Widget _buildMobileHero(BoxConstraints constraints) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildAnimatedAvatar(constraints.maxWidth * 0.5),
        const SizedBox(height: 30),
        _buildHeroText(true),
        const SizedBox(height: 30),
        _buildCTAButton(true),
      ],
    );
  }

  Widget _buildDesktopHero() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroText(false),
                const SizedBox(height: 30),
                _buildCTAButton(false),
              ],
            ),
          ),
        ),
        Flexible(child: _buildAnimatedAvatar(300)),
      ],
    );
  }

  Widget _buildAnimatedAvatar(double size) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.cyan, Colors.blue, Colors.purple],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyan.withValues(alpha: 0.4),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            padding: const EdgeInsets.all(4),
            child: ClipOval(
              child: Image.asset(
                "assets/images/welcome.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeroText(bool isMobile) {
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.cyan, Colors.blue, Colors.purple],
          ).createShader(bounds),
          child: Text(
            "Hello, I'm",
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Mohamed Ayman",
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 32 : 48,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        TypewriterText(
          texts: const [
            "Flutter Developer",
            "Mobile App Engineer",
            "Software Engineer",
            "UI/UX Enthusiast",
          ],
          style: TextStyle(
            color: Colors.cyan,
            fontSize: isMobile ? 18 : 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Building beautiful cross-platform apps with passion",
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: isMobile ? 14 : 16,
          ),
        ),
      ],
    );
  }

  Widget _buildCTAButton(bool isMobile) {
    return Wrap(
      alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
      spacing: 16,
      runSpacing: 12,
      children: [
        _buildGradientButton(
          "Get in Touch",
          Icons.email_outlined,
          () => _scrollToSection(contactKey),
          isPrimary: true,
        ),
        _buildGradientButton(
          "View Projects",
          Icons.work_outline,
          () => _scrollToSection(projectsKey),
          isPrimary: false,
        ),
        _buildGradientButton(
          "Download CV",
          Icons.download_rounded,
          () => _launchURL("https://drive.google.com/your-cv-link"),
          isPrimary: false,
          isDownload: true,
        ),
      ],
    );
  }

  Widget _buildGradientButton(
    String text,
    IconData icon,
    VoidCallback onTap, {
    bool isPrimary = true,
    bool isDownload = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: isPrimary
              ? const LinearGradient(colors: [Colors.cyan, Colors.blue])
              : isDownload
              ? LinearGradient(
                  colors: [
                    Colors.green.withValues(alpha: 0.2),
                    Colors.teal.withValues(alpha: 0.2),
                  ],
                )
              : null,
          border: Border.all(
            color: isPrimary
                ? Colors.transparent
                : isDownload
                ? Colors.green.withValues(alpha: 0.5)
                : Colors.cyan.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isPrimary
                  ? Colors.white
                  : isDownload
                  ? Colors.green
                  : Colors.cyan,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: isPrimary
                    ? Colors.white
                    : isDownload
                    ? Colors.green
                    : Colors.cyan,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= STATS SECTION =================
  Widget _buildStatsSection() {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xff0a0a0a),
            const Color(0xff111111).withValues(alpha: 0.8),
          ],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          final isTablet = constraints.maxWidth < 900;

          return Column(
            children: [
              _buildSectionTitle("Quick Stats", isMobile),
              const SizedBox(height: 10),
              Text(
                "Numbers that define my journey",
                style: TextStyle(
                  fontSize: isMobile ? 14 : 16,
                  color: Colors.cyan,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isMobile ? 2 : (isTablet ? 3 : 4),
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: isMobile ? 1.0 : 1.2,
                children: const [
                  AnimatedStatCard(
                    title: "Years of Experience",
                    value: "3+",
                    icon: Icons.timeline,
                    color: Colors.cyan,
                    delay: 0,
                  ),
                  AnimatedStatCard(
                    title: "Projects Completed",
                    value: "15+",
                    icon: Icons.folder_special,
                    color: Colors.purple,
                    delay: 100,
                  ),
                  AnimatedStatCard(
                    title: "Technologies",
                    value: "10+",
                    icon: Icons.code,
                    color: Colors.orange,
                    delay: 200,
                  ),
                  AnimatedStatCard(
                    title: "Certificates",
                    value: "5",
                    icon: Icons.workspace_premium,
                    color: Colors.green,
                    delay: 300,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  // ================= ABOUT SECTION =================
  Widget _buildAboutSection() {
    return Container(
      key: aboutKey,
      width: double.infinity,
      color: const Color(0xff111111),
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: custom_card(
        image: "assets/images/myPhoto.jpg",
        scetionTitle: "About me",
        subTitle: "who am I",
        content:
            "Hello, my name is Mohamed Ayman. I am 20 years old. "
            "I specialize in building cross-platform mobile applications using Flutter, "
            "and I follow clean architecture principles to keep apps scalable and maintainable.\n"
            "I am passionate about learning, collaborating across teams, and managing full "
            "software development lifecycles—from initial concept through deployment.",
      ),
    );
  }

  // ================= TIMELINE SECTION =================
  Widget _buildTimelineSection() {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xff111111),
            const Color(0xff0a0a0a).withValues(alpha: 0.9),
          ],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;

          return Column(
            children: [
              _buildSectionTitle("My Journey", isMobile),
              const SizedBox(height: 10),
              Text(
                "Experience & Achievements",
                style: TextStyle(
                  fontSize: isMobile ? 14 : 16,
                  color: Colors.cyan,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: const AnimatedTimeline(
                  items: [
                    TimelineItem(
                      year: "2025",
                      title: "Flutter Developer",
                      subtitle: "DEPI Program Graduate",
                      description:
                          "Completed intensive Flutter development program, building production-ready mobile applications with clean architecture and state management.",
                      icon: Icons.flutter_dash,
                      color: Colors.cyan,
                    ),
                    TimelineItem(
                      year: "2024",
                      title: "Red Hat Certified",
                      subtitle: "System Administration",
                      description:
                          "Earned Red Hat certifications in system administration, gaining expertise in Linux server management and DevOps practices.",
                      icon: Icons.verified,
                      color: Colors.red,
                    ),
                    TimelineItem(
                      year: "2023",
                      title: "Sprints Program",
                      subtitle: "Software Engineering",
                      description:
                          "Participated in Sprints intensive program, learning agile methodologies, clean code practices, and collaborative development.",
                      icon: Icons.rocket_launch,
                      color: Colors.purple,
                    ),
                    TimelineItem(
                      year: "2022",
                      title: "Started University",
                      subtitle: "Cairo University - FCAI",
                      description:
                          "Began studying Computer Science and Artificial Intelligence at Cairo University, building a strong foundation in programming and algorithms.",
                      icon: Icons.school,
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ================= EDUCATION SECTION =================
  Widget _buildEducationSection() {
    return Container(
      key: educationKey,
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 40),
      color: const Color(0xff0a0a0a),
      child: custom_card(
        image: "assets/images/education.png",
        scetionTitle: "Education",
        subTitle: "my education",
        content:
            "Cairo University \n"
            "Faculty of Computer Science and Artificial Intelligence \n"
            "2022-2026",
      ),
    );
  }

  // ================= SKILLS SECTION =================
  Widget _buildSkillsSection() {
    return Container(
      key: skillsKey,
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 40),
      color: const Color(0xff111111),
      child: const custom_card(
        image: "assets/images/skill.png",
        scetionTitle: "Skills",
        subTitle: "my skills",
        content: "",
      ),
    );
  }

  // ================= CERTIFICATES SECTION =================
  Widget _buildCertificatesSection() {
    return Container(
      key: certificatesKey,
      width: double.maxFinite,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xff0a0a0a),
            const Color(0xff1a2a3a).withValues(alpha: 0.5),
            const Color(0xff0a0a0a),
          ],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 600;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildSectionTitle("Certificates", isMobile),
              const SizedBox(height: 10),
              Text(
                "My Professional Certifications",
                style: TextStyle(
                  fontSize: isMobile ? 14 : 16,
                  color: Colors.cyan,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: isMobile ? 320 : 450,
                child: PageView.builder(
                  controller: _certPageController,
                  onPageChanged: (index) {
                    setState(() => _currentCertPage = index);
                  },
                  itemCount: certificates.length,
                  itemBuilder: (context, index) {
                    return _buildCertificateCard(index, isMobile);
                  },
                ),
              ),
              const SizedBox(height: 20),
              _buildCertificateIndicators(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCertificateCard(int index, bool isMobile) {
    final isActive = _currentCertPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: isActive ? 0 : 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Colors.cyan.withValues(alpha: 0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ]
            : [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(certificates[index]['image']!, fit: BoxFit.contain),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.9),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Text(
                  certificates[index]['title']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 14 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificateIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        certificates.length,
        (index) => GestureDetector(
          onTap: () {
            _certPageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 6),
            width: _currentCertPage == index ? 32 : 12,
            height: 12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              gradient: _currentCertPage == index
                  ? const LinearGradient(colors: [Colors.cyan, Colors.blue])
                  : null,
              color: _currentCertPage == index ? null : Colors.white24,
              boxShadow: _currentCertPage == index
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
    );
  }

  // ================= PROJECTS SECTION =================
  Widget _buildProjectsSection() {
    return Container(
      key: projectsKey,
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 0),
      color: const Color(0xff0a0a0a),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 600;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildSectionTitle("Projects", isMobile),
              const SizedBox(height: 10),
              Text(
                "Check out my latest work",
                style: TextStyle(
                  fontSize: isMobile ? 14 : 16,
                  color: Colors.cyan,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),
              ...List.generate(
                projects.length,
                (index) =>
                    AnimatedProjectCard(project: projects[index], index: index),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isMobile) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Colors.cyan, Colors.blue, Colors.purple],
      ).createShader(bounds),
      child: Text(
        title,
        style: TextStyle(
          fontSize: isMobile ? 35 : 50,
          fontFamily: "NightPumpkind",
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ================= CONTACT SECTION =================
  Widget _buildContactSection() {
    return Container(
      key: contactKey,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xff0a0a0a),
            const Color(0xff1a2a3a).withValues(alpha: 0.8),
          ],
        ),
      ),
      padding: const EdgeInsets.all(40),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 600;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildSectionTitle("Contact Me", isMobile),
              const SizedBox(height: 10),
              Text(
                "Let's work together",
                style: TextStyle(
                  fontSize: isMobile ? 14 : 16,
                  color: Colors.cyan,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),

              isMobile
                  ? Column(
                      children: [
                        _buildTextField(
                          emailController,
                          'Enter your email',
                          Icons.email,
                        ),
                        const SizedBox(height: 15),
                        _buildTextField(
                          nameController,
                          'Enter your name',
                          Icons.person,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            emailController,
                            'Enter your email',
                            Icons.email,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _buildTextField(
                            nameController,
                            'Enter your name',
                            Icons.person,
                          ),
                        ),
                      ],
                    ),

              const SizedBox(height: 20),
              _buildTextField(
                messageController,
                'Enter your message',
                Icons.message,
                maxLines: 6,
              ),
              const SizedBox(height: 30),

              GestureDetector(
                onTap: () {
                  sendEmail(
                    nameController.text,
                    emailController.text,
                    messageController.text,
                  );
                },
                child: Container(
                  width: isMobile ? double.infinity : 300,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [Colors.cyan, Colors.blue],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyan.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.send_rounded, color: Colors.white),
                      SizedBox(width: 12),
                      Text(
                        "Send Message",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(maxLines > 1 ? 20 : 30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
          prefixIcon: maxLines == 1 ? Icon(icon, color: Colors.cyan) : null,
          filled: true,
          fillColor: const Color(0xff1a2a3a),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(maxLines > 1 ? 20 : 30),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(maxLines > 1 ? 20 : 30),
            borderSide: const BorderSide(color: Colors.cyan, width: 2),
          ),
        ),
      ),
    );
  }

  // ================= SOCIAL SECTION =================
  Widget _buildSocialSection() {
    return Container(
      key: socialKey,
      padding: const EdgeInsets.symmetric(vertical: 30),
      color: const Color(0xff0a0a0a),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton(
                "assets/images/social/linkedin.png",
                "https://www.linkedin.com/in/mohamed-ayman-429942290/",
              ),
              const SizedBox(width: 24),
              _buildSocialButton(
                "assets/images/social/github.png",
                "https://github.com/Mohamed-Ayman28",
              ),
              const SizedBox(width: 24),
              _buildSocialButton(
                "assets/images/social/gmail.png",
                "mailto:mohameda.ayman8@gmail.com",
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "© 2026 Mohamed Ayman. All rights reserved.",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite,
                color: Colors.red.withValues(alpha: 0.7),
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                "Built with Flutter",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.flutter_dash, color: Colors.cyan, size: 14),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(String imagePath, String url) {
    return _HoverSocialButton(
      imagePath: imagePath,
      onTap: () => _launchURL(url),
    );
  }
}

// Enhanced Nav Button with hover effect
class _HoverNavButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const _HoverNavButton({required this.text, required this.onTap});

  @override
  State<_HoverNavButton> createState() => _HoverNavButtonState();
}

class _HoverNavButtonState extends State<_HoverNavButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: _isHovered
                ? Colors.cyan.withValues(alpha: 0.1)
                : Colors.transparent,
            border: Border.all(
              color: _isHovered
                  ? Colors.cyan.withValues(alpha: 0.5)
                  : Colors.transparent,
            ),
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              color: _isHovered ? Colors.cyan : Colors.white70,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

// Enhanced Social Button with glow effect
class _HoverSocialButton extends StatefulWidget {
  final String imagePath;
  final VoidCallback onTap;

  const _HoverSocialButton({required this.imagePath, required this.onTap});

  @override
  State<_HoverSocialButton> createState() => _HoverSocialButtonState();
}

class _HoverSocialButtonState extends State<_HoverSocialButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(12),
          transform: _isHovered
              ? (Matrix4.identity()..scale(1.15))
              : Matrix4.identity(),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isHovered
                ? const Color(0xff2a4a5a)
                : const Color(0xff1a2a3a),
            border: Border.all(
              color: _isHovered
                  ? Colors.cyan
                  : Colors.cyan.withValues(alpha: 0.3),
              width: _isHovered ? 2 : 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: Colors.cyan.withValues(alpha: 0.5),
                      blurRadius: 20,
                      spreadRadius: 3,
                    ),
                  ]
                : [],
          ),
          child: Image.asset(widget.imagePath, width: 36, height: 36),
        ),
      ),
    );
  }
}
