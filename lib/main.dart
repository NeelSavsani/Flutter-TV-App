import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const TvPhotoApp());
}

class TvPhotoApp extends StatelessWidget {
  const TvPhotoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TV Photo App',
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Ubuntu',
      ),
      home: const HomeScreen(),
    );
  }
}

// ============================================================
// HOME SCREEN
// ============================================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<TvApp> apps = const [
    TvApp(
      imagePath: 'assets/images/AmazonPrime.png',
      title: 'Amazon Prime',
    ),
    TvApp(
      imagePath: 'assets/images/AppleTV.png',
      title: 'Apple TV',
    ),
    TvApp(
      imagePath: 'assets/images/Netflix.png',
      title: 'Netflix',
    ),
    TvApp(
      imagePath: 'assets/images/YouTube.png',
      title: 'YouTube',
    ),
  ];

  final List<FocusNode> focusNodes = [];

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < apps.length; i++) {
      focusNodes.add(FocusNode());
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (focusNodes.isNotEmpty) {
        focusNodes[0].requestFocus();
      }
    });
  }

  @override
  void dispose() {
    for (final node in focusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  // ==========================================================
  // OPEN FULL-SCREEN IMAGE
  // ==========================================================

  void openImage(int index) {
    setState(() {
      selectedIndex = index;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenImage(
          imagePath: apps[index].imagePath,
          title: apps[index].title,
        ),
      ),
    ).then((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (selectedIndex < focusNodes.length) {
          focusNodes[selectedIndex].requestFocus();
        }
      });
    });
  }

  // ==========================================================
  // HOME UI
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ----------------------------------------------------
          // BACKGROUND IMAGE
          // ----------------------------------------------------

          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
            ),
          ),

          // ----------------------------------------------------
          // SUBTLE DARK OVERLAY
          // ----------------------------------------------------

          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.15),
            ),
          ),

          // ----------------------------------------------------
          // CONTENT
          // ----------------------------------------------------

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'My TV Apps',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 40),

                  Expanded(
                    child: GridView.builder(
                      itemCount: apps.length,

                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 30,
                        mainAxisSpacing: 45,
                        childAspectRatio: 1.25,
                      ),

                      itemBuilder: (context, index) {
                        return TvImageCard(
                          imagePath: apps[index].imagePath,
                          title: apps[index].title,
                          focusNode: focusNodes[index],
                          autofocus: index == 0,

                          onFocused: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },

                          onSelected: () {
                            openImage(index);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// TV APP MODEL
// ============================================================

class TvApp {
  final String imagePath;
  final String title;

  const TvApp({
    required this.imagePath,
    required this.title,
  });
}

// ============================================================
// TV IMAGE CARD
// ============================================================

class TvImageCard extends StatefulWidget {
  final String imagePath;
  final String title;
  final FocusNode focusNode;
  final bool autofocus;
  final VoidCallback onFocused;
  final VoidCallback onSelected;

  const TvImageCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.focusNode,
    required this.autofocus,
    required this.onFocused,
    required this.onSelected,
  });

  @override
  State<TvImageCard> createState() => _TvImageCardState();
}

class _TvImageCardState extends State<TvImageCard> {
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,

      // --------------------------------------------------------
      // FOCUS CHANGE
      // --------------------------------------------------------

      onFocusChange: (hasFocus) {
        setState(() {
          isFocused = hasFocus;
        });

        if (hasFocus) {
          widget.onFocused();
        }
      },

      // --------------------------------------------------------
      // ENTER / OK
      // --------------------------------------------------------

      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          final key = event.logicalKey;

          if (key == LogicalKeyboardKey.enter ||
              key == LogicalKeyboardKey.select ||
              key == LogicalKeyboardKey.gameButtonA) {
            widget.onSelected();

            return KeyEventResult.handled;
          }
        }

        return KeyEventResult.ignored;
      },

      // --------------------------------------------------------
      // CARD SCALE
      // --------------------------------------------------------

      child: AnimatedScale(
        scale: isFocused ? 1.08 : 1.0,

        duration: const Duration(
          milliseconds: 180,
        ),

        curve: Curves.easeOut,

        // ------------------------------------------------------
        // IMAGE + TITLE
        // ------------------------------------------------------

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --------------------------------------------------
            // IMAGE
            // --------------------------------------------------

            AspectRatio(
              aspectRatio: 16 / 9,

              child: AnimatedContainer(
                duration: const Duration(
                  milliseconds: 180,
                ),

                curve: Curves.easeOut,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),

                  // ------------------------------------------------
                  // FOCUS BORDER
                  // ------------------------------------------------

                  border: Border.all(
                    color: isFocused
                        ? Colors.white
                        : Colors.transparent,

                    width: isFocused ? 5 : 0,
                  ),

                  // ------------------------------------------------
                  // FOCUS GLOW
                  // ------------------------------------------------

                  boxShadow: isFocused
                      ? [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.25),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                      : [],
                ),

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),

                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // --------------------------------------------------
            // NAME BELOW IMAGE
            // --------------------------------------------------

            AnimatedOpacity(
              opacity: isFocused ? 1.0 : 0.0,

              duration: const Duration(
                milliseconds: 150,
              ),

              child: Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                ),

                child: Text(
                  widget.title,

                  textAlign: TextAlign.center,

                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// FULL-SCREEN IMAGE VIEWER
// ============================================================

class FullScreenImage extends StatelessWidget {
  final String imagePath;
  final String title;

  const FullScreenImage({
    super.key,
    required this.imagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,

      child: Scaffold(
        backgroundColor: Colors.black,

        body: Focus(
          autofocus: true,

          // ----------------------------------------------------
          // ESC KEY
          // ----------------------------------------------------

          onKeyEvent: (node, event) {
            if (event is KeyDownEvent) {
              if (event.logicalKey == LogicalKeyboardKey.escape) {
                Navigator.of(context).pop();

                return KeyEventResult.handled;
              }
            }

            return KeyEventResult.ignored;
          },

          child: Stack(
            children: [
              // ------------------------------------------------
              // FULL-SCREEN IMAGE
              // ------------------------------------------------

              Center(
                child: InteractiveViewer(
                  minScale: 1.0,
                  maxScale: 3.0,

                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),

              // ------------------------------------------------
              // BACK INDICATOR
              // ------------------------------------------------

              Positioned(
                top: 30,
                left: 30,

                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: const Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),

                      SizedBox(width: 10),

                      Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ------------------------------------------------
              // FULL-SCREEN IMAGE TITLE
              // ------------------------------------------------

              Positioned(
                left: 0,
                right: 0,
                bottom: 30,

                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.65),
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Text(
                      title,

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}