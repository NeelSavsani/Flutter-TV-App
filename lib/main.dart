import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const CustomerFeedbackApp());
}

class CustomerFeedbackApp extends StatelessWidget {
  const CustomerFeedbackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Customer Feedback',
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Ubuntu',
        scaffoldBackgroundColor: const Color(0xFF070C20),
      ),
      home: const CustomerFeedbackScreen(),
    );
  }
}

// ============================================================
// FEEDBACK TYPE
// ============================================================

enum FeedbackType {
  text,
  image,
  video,
}

// ============================================================
// FEEDBACK MODEL
// ============================================================

class FeedbackItem {
  final FeedbackType type;

  // Text feedback
  final String? review;
  final double? star;
  final String? client;
  final String? time;

  // Image feedback
  final String? imagePath;

  // Video feedback
  // This is already supported in the model.
  // Actual video playback will be added later.
  final String? videoPath;

  const FeedbackItem({
    required this.type,
    this.review,
    this.star,
    this.client,
    this.time,
    this.imagePath,
    this.videoPath,
  });
}

// ============================================================
// MAIN SCREEN
// ============================================================

class CustomerFeedbackScreen extends StatefulWidget {
  const CustomerFeedbackScreen({super.key});

  @override
  State<CustomerFeedbackScreen> createState() =>
      _CustomerFeedbackScreenState();
}

class _CustomerFeedbackScreenState
    extends State<CustomerFeedbackScreen> {
  // ==========================================================
  // FEEDBACK DATA
  // ==========================================================

  final List<FeedbackItem> feedbacks = const [

    // --------------------------------------------------------
    // TEXT FEEDBACK 1
    // --------------------------------------------------------

    FeedbackItem(
      type: FeedbackType.text,
      review:
      'The team went above and beyond for our anniversary dinner. Prompt seating, delicious dishes and very reasonable pricing.',
      star: 5.0,
      client: 'Marcus Vance',
      time: '1 week ago',
    ),

    // --------------------------------------------------------
    // IMAGE FEEDBACK
    // --------------------------------------------------------

    FeedbackItem(
      type: FeedbackType.image,
      imagePath: 'assets/images/customer1.jpg',
    ),

    // --------------------------------------------------------
    // TEXT FEEDBACK 2
    // --------------------------------------------------------

    FeedbackItem(
      type: FeedbackType.text,
      review:
      'Consistently high quality and clean setup. Great place for informal lunch meetings. Coffee bar is top notch.',
      star: 5.0,
      client: 'Elena Rostova',
      time: '2 weeks ago',
    ),

    // --------------------------------------------------------
    // IMAGE FEEDBACK 2
    // --------------------------------------------------------

    FeedbackItem(
      type: FeedbackType.image,
      imagePath: 'assets/images/customer2.jpg',
    ),

    // --------------------------------------------------------
    // TEXT FEEDBACK 3
    // --------------------------------------------------------

    FeedbackItem(
      type: FeedbackType.text,
      review:
      'Exceptional service and friendly staff! The attention to detail was beyond anything we anticipated. Definitely returning with colleagues.',
      star: 5.0,
      client: 'John Smith',
      time: '2 days ago',
    ),

    // --------------------------------------------------------
    // TEXT FEEDBACK 4
    // --------------------------------------------------------

    FeedbackItem(
      type: FeedbackType.text,
      review:
      'Great experience! Delicious food, cozy ambience, and excellent service. Definitely a place worth visiting again.',
      star: 4.8,
      client: 'Neel Savsani',
      time: '18 days ago',
    ),

    // --------------------------------------------------------
    // TEXT FEEDBACK 5
    // --------------------------------------------------------

    FeedbackItem(
      type: FeedbackType.text,
      review:
      'Really enjoyed the food and the pleasant ambience. The service was good, and overall it was a lovely dining experience. Would definitely visit again!',
      star: 4.5,
      client: 'Bob',
      time: '13 days ago',
    ),

    // ========================================================
    // FUTURE VIDEO EXAMPLE
    // ========================================================
    //
    // You can later add:
    //
    // FeedbackItem(
    //   type: FeedbackType.video,
    //   videoPath: 'assets/videos/customer_video.mp4',
    // ),
    //
    // It will NOT currently crash the application.
    // Video playback will be implemented later.
  ];

  // ==========================================================
  // SLIDESHOW STATE
  // ==========================================================

  int currentIndex = 0;

  Timer? slideshowTimer;

  @override
  void initState() {
    super.initState();

    // Start the timer for the first feedback.
    _startTimerForCurrentFeedback();
  }

  // ==========================================================
  // START TIMER BASED ON FEEDBACK TYPE
  // ==========================================================

  void _startTimerForCurrentFeedback() {
    slideshowTimer?.cancel();

    if (feedbacks.isEmpty) {
      return;
    }

    final currentFeedback = feedbacks[currentIndex];

    switch (currentFeedback.type) {
      case FeedbackType.text:

      // Text feedback stays for 6 seconds.
        slideshowTimer = Timer(
          const Duration(seconds: 6),
          _nextFeedback,
        );

        break;

      case FeedbackType.image:

      // Image feedback stays for 6 seconds.
        slideshowTimer = Timer(
          const Duration(seconds: 6),
          _nextFeedback,
        );

        break;

      case FeedbackType.video:

      // ----------------------------------------------------
      // FUTURE VIDEO LOGIC
      // ----------------------------------------------------
      //
      // Later this will NOT use a fixed 6-second timer.
      //
      // Instead:
      //
      // Video starts
      //       ↓
      // Video finishes
      //       ↓
      // _nextFeedback()
      //
      // For now, if a video item is added before
      // video support is implemented, we safely display
      // a placeholder and move to the next item after 6 sec.
      // ----------------------------------------------------

        slideshowTimer = Timer(
          const Duration(seconds: 6),
          _nextFeedback,
        );

        break;
    }
  }

  // ==========================================================
  // NEXT FEEDBACK
  // ==========================================================

  void _nextFeedback() {
    if (!mounted || feedbacks.isEmpty) {
      return;
    }

    setState(() {
      currentIndex = (currentIndex + 1) % feedbacks.length;
    });

    // Start the correct timer for the new feedback.
    _startTimerForCurrentFeedback();
  }

  @override
  void dispose() {
    slideshowTimer?.cancel();
    super.dispose();
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            70,
            45,
            70,
            30,
          ),
          child: Stack(
            children: [

              // =================================================
              // FEEDBACK CONTENT
              // =================================================

              Positioned(
                left: 0,
                top: 0,
                right: 0,
                bottom: 75,
                child: AnimatedSwitcher(
                  duration: const Duration(
                    milliseconds: 700,
                  ),

                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,

                  transitionBuilder: (
                      Widget child,
                      Animation<double> animation,
                      ) {
                    final slideAnimation =
                    Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      ),
                    );

                    return SlideTransition(
                      position: slideAnimation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },

                  child: FeedbackRenderer(
                    key: ValueKey(currentIndex),
                    feedback: feedbacks[currentIndex],
                  ),
                ),
              ),

              // =================================================
              // QR CARD
              // =================================================

              const Positioned(
                right: -1,
                bottom: 0,
                child: ReviewQrCard(),
              ),

              // =================================================
              // SLIDESHOW DOTS
              // =================================================

              Positioned(
                left: 0,
                right: 0,
                bottom: 5,
                child: FeedbackDots(
                  total: feedbacks.length,
                  currentIndex: currentIndex,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// FEEDBACK RENDERER
// ============================================================
//
// This is the most important part.
//
// It checks the feedback type and chooses the correct layout.
//
// TEXT  → TextFeedbackLayout
// IMAGE → ImageFeedbackLayout
// VIDEO → VideoFeedbackLayout
//
// ============================================================

class FeedbackRenderer extends StatelessWidget {
  final FeedbackItem feedback;

  const FeedbackRenderer({
    super.key,
    required this.feedback,
  });

  @override
  Widget build(BuildContext context) {
    switch (feedback.type) {
      case FeedbackType.text:
        return TextFeedbackLayout(
          feedback: feedback,
        );

      case FeedbackType.image:
        return ImageFeedbackLayout(
          feedback: feedback,
        );

      case FeedbackType.video:
        return VideoFeedbackLayout(
          feedback: feedback,
        );
    }
  }
}

// ============================================================
// TEXT FEEDBACK LAYOUT
// ============================================================

class TextFeedbackLayout extends StatelessWidget {
  final FeedbackItem feedback;

  const TextFeedbackLayout({
    super.key,
    required this.feedback,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        // =====================================================
        // STARS + RATING
        // =====================================================

        Row(
          children: [

            Row(
              children: List.generate(
                5,
                    (index) {
                  return const Padding(
                    padding: EdgeInsets.only(
                      right: 6,
                    ),
                    child: Icon(
                      Icons.star,
                      color: Color(0xFFFFA000),
                      size: 48,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 15),

            Text(
              (feedback.star ?? 5.0).toStringAsFixed(1),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),

        const SizedBox(height: 28),

        // =====================================================
        // REVIEW TEXT
        // =====================================================

        Text(
          '"${feedback.review ?? ''}"',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w500,
            height: 1.35,
            letterSpacing: -0.3,
          ),
        ),

        const SizedBox(height: 25),

        // =====================================================
        // CLIENT NAME
        // =====================================================

        Text(
          feedback.client ?? '',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 5),

        // =====================================================
        // TIME
        // =====================================================

        Text(
          feedback.time ?? '',
          style: TextStyle(
            color: Colors.white.withOpacity(0.55),
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// IMAGE FEEDBACK LAYOUT
// ============================================================

class ImageFeedbackLayout extends StatelessWidget {
  final FeedbackItem feedback;

  const ImageFeedbackLayout({
    super.key,
    required this.feedback,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(10),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
        ),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),

          child: Image.asset(
            feedback.imagePath ?? '',

            fit: BoxFit.contain,

            // =================================================
            // IMPORTANT
            // =================================================
            //
            // If image file is missing, Flutter will NOT crash.
            //
            // Instead, this errorBuilder will be displayed.
            //
            errorBuilder: (
                context,
                error,
                stackTrace,
                ) {
              return const Center(
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.white54,
                      size: 70,
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Image not available',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ============================================================
// VIDEO FEEDBACK LAYOUT
// ============================================================
//
// VIDEO SUPPORT IS PREPARED HERE.
//
// We are intentionally NOT importing video_player yet.
//
// Later we can replace this widget with the actual video
// player.
//
// If a video feedback is accidentally added now, the app
// will NOT crash.
//
// ============================================================

class VideoFeedbackLayout extends StatelessWidget {
  final FeedbackItem feedback;

  const VideoFeedbackLayout({
    super.key,
    required this.feedback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,

      decoration: BoxDecoration(
        color: const Color(0xFF11182D),
        borderRadius: BorderRadius.circular(24),
      ),

      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(
              Icons.video_library_outlined,
              color: Colors.white54,
              size: 80,
            ),

            const SizedBox(height: 20),

            const Text(
              'Video feedback',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              feedback.videoPath ??
                  'Video file not specified',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.55),
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Video playback will be added later',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// SLIDESHOW DOTS
// ============================================================

class FeedbackDots extends StatelessWidget {
  final int total;
  final int currentIndex;

  const FeedbackDots({
    super.key,
    required this.total,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        total,
            (index) {
          final bool isActive =
              index == currentIndex;

          return AnimatedContainer(
            duration: const Duration(
              milliseconds: 250,
            ),

            margin: const EdgeInsets.symmetric(
              horizontal: 6,
            ),

            width: isActive ? 28 : 9,
            height: 9,

            decoration: BoxDecoration(
              color: isActive
                  ? Colors.white
                  : Colors.white.withOpacity(0.30),

              borderRadius:
              BorderRadius.circular(20),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// QR CARD
// ============================================================

class ReviewQrCard extends StatelessWidget {
  const ReviewQrCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 115,

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: const Color(0xFF222B43),

        borderRadius:
        BorderRadius.circular(20),

        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1.5,
        ),
      ),

      child: Row(
        children: [

          // =================================================
          // QR CODE
          // =================================================

          Container(
            width: 75,
            height: 75,

            padding:
            const EdgeInsets.all(6),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius:
              BorderRadius.circular(12),
            ),

            child: Image.asset(
              'assets/images/review_qr.png',

              fit: BoxFit.contain,

              // Prevent crash if QR file is missing.
              errorBuilder: (
                  context,
                  error,
                  stackTrace,
                  ) {
                return const Icon(
                  Icons.qr_code_2,
                  color: Colors.black,
                  size: 65,
                );
              },
            ),
          ),

          const SizedBox(width: 12),

          // =================================================
          // QR TEXT
          // =================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              mainAxisAlignment:
              MainAxisAlignment.center,

              children: [

                const Text(
                  'LOVE OUR SERVICE?',
                  maxLines: 1,

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Scan to leave a review',
                  maxLines: 1,

                  style: TextStyle(
                    color:
                    Colors.white.withOpacity(0.65),
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Scan the QR code',
                  maxLines: 1,

                  style: TextStyle(
                    color: Color(0xFFFFB000),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
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