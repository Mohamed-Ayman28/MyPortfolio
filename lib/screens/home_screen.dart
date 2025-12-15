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
        actions: MediaQuery.of(context).size.width > 800
            ? [
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
              ]
            : null,
      ),
      drawer: MediaQuery.of(context).size.width <= 800
          ? Drawer(
              backgroundColor: CustomColors.container2bl,
              child: ListView(
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(color: CustomColors.container2bl),
                    child: Image.asset("assets/images/logo.png"),
                  ),
                  for (int i = 0; i < pages.length; i++)
                    ListTile(
                      title: Text(
                        pages[i],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
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
            )
          : null,
      backgroundColor: Colors.blueGrey,
      body: ListView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        children: [
          // ================= HOME =================
          Container(
            key: homeKey,
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            color: const Color(0xff2E4252),
            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isMobile = constraints.maxWidth < 800;
                return isMobile
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/welcome.png",
                            width: constraints.maxWidth * 0.8,
                            height: 250,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 30),
                          Text(
                            'Hi,\nI am Mohamed Ayman\nA Flutter Developer and Software Engineer',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: constraints.maxWidth < 600 ? 18 : 24,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: constraints.maxWidth * 0.8,
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
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '''Hi,
I am Mohamed Ayman
A Flutter Developer and Software Engineer''',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: 400,
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            CustomColors.container2bl,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
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
                          ),
                          Flexible(
                            child: Image.asset(
                              "assets/images/welcome.png",
                              width: 350,
                              height: 350,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      );
              },
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
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(vertical: 40),
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
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(vertical: 40),
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
            width: double.maxFinite,
            padding: const EdgeInsets.all(20),
            color: const Color(0xff2E4252),
            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isMobile = constraints.maxWidth < 600;
                double imageWidth = isMobile
                    ? constraints.maxWidth * 0.85
                    : 400;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Certificates",
                      style: TextStyle(
                        fontSize: isMobile ? 35 : 50,
                        fontFamily: "NightPumpkind",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: isMobile ? 300 : 420,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Image.asset(
                            "assets/images/certifcates/sprints.png",
                            width: imageWidth,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 20),
                          Image.asset(
                            "assets/images/certifcates/redhat1.png",
                            width: imageWidth,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 20),
                          Image.asset(
                            "assets/images/certifcates/redhat2.png",
                            width: imageWidth,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // ================= PROJECTS =================
          Container(
            key: projectsKey,
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            color: const Color(0xff111111),
            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isMobile = constraints.maxWidth < 600;
                double horizontalMargin = isMobile ? 10 : 100;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Projects",
                      style: TextStyle(
                        fontSize: isMobile ? 35 : 50,
                        fontFamily: "NightPumpkind",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Card(
                      color: const Color(0xff2E4252),
                      margin: EdgeInsets.symmetric(
                        horizontal: horizontalMargin,
                        vertical: 10,
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.flutter_dash,
                          size: isMobile ? 35 : 50,
                        ),
                        title: Text(
                          "My Portfolio website using Flutter",
                          style: TextStyle(
                            fontSize: isMobile ? 18 : 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "A personal portfolio  built with Flutter to showcase my skills, projects, and contact details.",
                          style: TextStyle(fontSize: isMobile ? 14 : 16),
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
                      margin: EdgeInsets.symmetric(
                        horizontal: horizontalMargin,
                        vertical: 10,
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.flutter_dash,
                          size: isMobile ? 35 : 50,
                        ),
                        title: Text(
                          "My HiddenTreasures Flutter App",
                          style: TextStyle(
                            fontSize: isMobile ? 18 : 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "A travel companion app that helps tourists discover landmarks, restaurants, and transport options based on budget.",
                          style: TextStyle(fontSize: isMobile ? 14 : 16),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            _launchURL(
                              "https://github.com/Mohamed-Ayman28/HiddenTreasures-DEPI",
                            );
                          },
                          icon: const Icon(Icons.link),
                        ),
                      ),
                    ),

                    Card(
                      color: const Color(0xff2E4252),
                      margin: EdgeInsets.symmetric(
                        horizontal: horizontalMargin,
                        vertical: 10,
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.flutter_dash,
                          size: isMobile ? 35 : 50,
                        ),
                        title: Text(
                          "Learn German App Flutter ",
                          style: TextStyle(
                            fontSize: isMobile ? 18 : 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "An educational app designed to help users learn German vocabulary and phrases with a simple, user-friendly interface.",
                          style: TextStyle(fontSize: isMobile ? 14 : 16),
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

                    Card(
                      color: const Color(0xff2E4252),
                      margin: EdgeInsets.symmetric(
                        horizontal: horizontalMargin,
                        vertical: 10,
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.flutter_dash,
                          size: isMobile ? 35 : 50,
                        ),
                        title: Text(
                          "Rick and Morty App",
                          style: TextStyle(
                            fontSize: isMobile ? 18 : 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "A Flutter app that displays Rick and Morty characters using the Rick and Morty API with clean architecture.",
                          style: TextStyle(fontSize: isMobile ? 14 : 16),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            _launchURL(
                              "https://github.com/Mohamed-Ayman28/RickAndMortyApp",
                            );
                          },
                          icon: const Icon(Icons.link),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // ================= CONTACT ME =================
          Container(
            key: contactKey,
            width: double.infinity,
            color: const Color(0xff2E4252),
            padding: const EdgeInsets.all(40),
            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isMobile = constraints.maxWidth < 600;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Contact Me",
                      style: TextStyle(
                        fontSize: isMobile ? 35 : 50,
                        fontFamily: "NightPumpkind",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),

                    isMobile
                        ? Column(
                            children: [
                              TextField(
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
                              const SizedBox(height: 15),
                              TextField(
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
                            ],
                          )
                        : Row(
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
                      width: isMobile ? double.infinity : 400,
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
                );
              },
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
