import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/constants/navItems.dart';
import 'package:my_portfolio/widgets/custom_card.dart';
import 'package:my_portfolio/widgets/send_email.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      appBar: AppBar(
        backgroundColor: CustomColors.container2bl,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Image.asset("assets/images/logo.png", width: 70),
        ),
        actions: [
          for (int i = 0; i < pages.length; i++)
            TextButton(
              onPressed: () => _scrollToSection(sectionKeys[i]),
              child: Text(
                pages[i],
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  fontSize: 15,
                ),
              ),
            ),
        ],
      ),
      backgroundColor: Colors.blueGrey,
      body: ListView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        children: [
          // ================= HOME =================
          Container(
            key: homeKey,
            height: 500,
            width: double.maxFinite,
            color: const Color(0xff2E4252),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Left side: text + button
                Padding(
                  padding: const EdgeInsets.only(right: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '''
Hi,
I am Mohamed Ayman
A Flutter Developer and Software Engineer
                        ''',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: 400,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.container2bl,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            _scrollToSection(contactKey);
                          },
                          child: const Text(
                            "Get in Touch",
                            style: TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset("assets/images/welcome.png"),
              ],
            ),
          ),

          // ================= ABOUT ME =================
          Container(
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
          ),

          // ================= EDUCATION =================
          Container(
            key: educationKey,
            height: 500,
            width: double.maxFinite,
            color: const Color(0xff2E4252),
            child: custom_card(
              image: "assets/images/education.png",
              scetionTitle: "Education",
              subTitle: "my education",
              content:
                  "Cairo University \n"
                  "Faculty of Computer Science and Artificial Intelligence \n"
                  "2022-2026",
            ),
          ),

          // ================= SKILLS =================
          Container(
            key: skillsKey,
            height: 500,
            width: double.maxFinite,
            color: const Color(0xff111111),
            child: const custom_card(
              image: "assets/images/skill.png",
              scetionTitle: "Skills",
              subTitle: "my skills",
              content: "",
            ),
          ),

          // ================= CERTIFICATES =================
          Container(
            key: certificatesKey,
            height: 500,
            width: double.maxFinite,
            color: const Color(0xff2E4252),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Certificates",
                  style: TextStyle(
                    fontSize: 50,
                    fontFamily: "NightPumpkind",
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Image.asset(
                        "assets/images/certifcates/sprints.png",
                        width: 400,
                        height: 400,
                      ),
                      const SizedBox(width: 20),
                      Image.asset(
                        "assets/images/certifcates/redhat1.png",
                        width: 400,
                        height: 400,
                      ),
                      const SizedBox(width: 20),
                      Image.asset(
                        "assets/images/certifcates/redhat2.png",
                        width: 400,
                        height: 400,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ================= PROJECTS =================
          Container(
            key: projectsKey,
            height: 500,
            width: double.maxFinite,
            color: const Color(0xff111111),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Projects",
                  style: TextStyle(
                    fontSize: 50,
                    fontFamily: "NightPumpkind",
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                Card(
                  color: const Color(0xff2E4252),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 100,
                    vertical: 10,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.flutter_dash, size: 50),
                    title: const Text(
                      "My Portfolio website using Flutter",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text(
                      "A personal portfolio  built with Flutter to showcase my skills, projects, and contact details.",
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        _launchURL(
                          "https://github.com/Mohamed-Ayman28/MyPortfolio/",
                        );
                      },
                      icon: const Icon(Icons.link),
                    ),
                  ),
                ),

                Card(
                  color: const Color(0xff2E4252),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 100,
                    vertical: 10,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.flutter_dash, size: 50),
                    title: const Text(
                      "My HiddenTreasures Flutter UI App",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text(
                      "A travel companion app UI that helps tourists discover landmarks, restaurants, and transport options based on budget.",
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        _launchURL(
                          "https://github.com/Mohamed-Ayman28/HiddenTreasures/",
                        );
                      },
                      icon: const Icon(Icons.link),
                    ),
                  ),
                ),

                Card(
                  color: const Color(0xff2E4252),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 100,
                    vertical: 10,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.flutter_dash, size: 50),
                    title: const Text(
                      "Learn German App Flutter UI",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text(
                      "An educational app UI designed to help users learn German vocabulary and phrases with a simple, user-friendly interface.",
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        _launchURL(
                          "https://github.com/Mohamed-Ayman28/DeutschApp",
                        );
                      },
                      icon: const Icon(Icons.link),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ================= CONTACT ME =================
          Container(
            key: contactKey,
            width: double.infinity,
            color: const Color(0xff2E4252),
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Contact Me",
                  style: TextStyle(
                    fontSize: 50,
                    fontFamily: "NightPumpkind",
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'Enter your name',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: messageController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: 'Enter your message',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: 400,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.container2bl,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      sendEmail(
                        nameController.text,
                        emailController.text,
                        messageController.text,
                      );
                    },
                    child: const Text(
                      "Send Message",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ================= SOCIAL LINKS =================
          Container(
            key: socialKey,
            height: 70,
            color: const Color(0xff111111),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _launchURL(
                      "https://www.linkedin.com/in/mohamed-ayman-429942290/",
                    );
                  },
                  child: Image.asset(
                    "assets/images/social/linkedin.png",
                    width: 50,
                    height: 50,
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  height: 60,
                  child: GestureDetector(
                    onTap: () {
                      _launchURL("https://github.com/Mohamed-Ayman28");
                    },
                    child: Image.asset(
                      "assets/images/social/github.png",
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    _launchURL("mailto:mohameda.ayman8@gmail.com");
                  },
                  child: Image.asset(
                    "assets/images/social/gmail.png",
                    width: 50,
                    height: 50,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
