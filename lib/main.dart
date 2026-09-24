import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const CustomerFeedbackApp());
}

// ============================================================
// APP
// ============================================================

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
// REVIEW MODEL
// ============================================================

class CustomerReview {
  final double star;
  final String review;
  final String client;
  final String time;

  const CustomerReview({
    required this.star,
    required this.review,
    required this.client,
    required this.time,
  });
}

// ============================================================
// CUSTOMER FEEDBACK SCREEN
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
  // REVIEWS
  // ==========================================================

  final List<CustomerReview> reviews = const [
    CustomerReview(
      star: 5.0,
      review:
      'The team went above and beyond for our anniversary dinner. Prompt seating, delicious dishes and very reasonable pricing.',
      client: 'Marcus Vance',
      time: '1 week ago',
    ),
    CustomerReview(
      star: 5.0,
      review:
      'Consistently high quality and clean setup. Great place for informal lunch meetings. Coffee bar is top notch.',
      client: 'Elena Rostova',
      time: '2 weeks ago',
    ),
    CustomerReview(
      star: 5.0,
      review:
      'Exceptional service and friendly staff! The attention to detail was beyond anything we anticipated. Definitely returning with colleagues.',
      client: 'John Smith',
      time: '2 days ago',
    ),
    CustomerReview(
      star: 4.8,
      review:
      'Great experience! Delicious food, cozy ambience, and excellent service. Definitely a place worth visiting again.',
      client: 'Neel Savsani',
      time: '18 days ago',
    ),
    CustomerReview(
      star: 4.5,
      review:
      'Really enjoyed the food and the pleasant ambience. The service was good, and overall it was a lovely dining experience. Would definitely visit again!',
      client: 'Bob',
      time: '13 days ago',
    ),
  ];

  int currentIndex = 0;

  Timer? slideshowTimer;

  @override
  void initState() {
    super.initState();

    // Change review every 6 seconds.
    slideshowTimer = Timer.periodic(
      const Duration(seconds: 6),
          (_) {
        if (!mounted) return;

        setState(() {
          currentIndex =
              (currentIndex + 1) % reviews.length;
        });
      },
    );
  }

  @override
  void dispose() {
    slideshowTimer?.cancel();
    super.dispose();
  }

  // ==========================================================
  // SCREEN
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(
                70,
                45,
                70,
                30,
              ),

              child: Stack(
                children: [
                  // ==================================================
                  // REVIEW AREA
                  // ==================================================

                  Positioned(
                    left: 0,
                    top: 0,
                    right: 360,
                    bottom: 75,

                    child: AnimatedSwitcher(
                      duration:
                      const Duration(milliseconds: 700),

                      switchInCurve:
                      Curves.easeOutCubic,

                      switchOutCurve:
                      Curves.easeInCubic,

                      transitionBuilder:
                          (child, animation) {
                        // New review enters from RIGHT.
                        final slideAnimation =
                        Tween<Offset>(
                          begin:
                          const Offset(1.0, 0.0),
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

                      child: ReviewContent(
                        key: ValueKey(currentIndex),
                        review:
                        reviews[currentIndex],
                      ),
                    ),
                  ),

                  // ==================================================
                  // QR CARD - BOTTOM RIGHT
                  // ==================================================

                  const Positioned(
                    right: 0,
                    bottom: 5,
                    child: ReviewQrCard(),
                  ),

                  // ==================================================
                  // SLIDESHOW DOTS
                  // ==================================================

                  Positioned(
                    left: 0,
                    right: 390,
                    bottom: 5,

                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,

                      children: List.generate(
                        reviews.length,
                            (index) {
                          final isActive =
                              index == currentIndex;

                          return AnimatedContainer(
                            duration:
                            const Duration(
                              milliseconds: 250,
                            ),

                            margin:
                            const EdgeInsets.symmetric(
                              horizontal: 6,
                            ),

                            width:
                            isActive ? 28 : 9,

                            height: 9,

                            decoration:
                            BoxDecoration(
                              color: isActive
                                  ? Colors.white
                                  : Colors.white
                                  .withOpacity(
                                0.30,
                              ),

                              borderRadius:
                              BorderRadius.circular(
                                20,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ============================================================
// REVIEW CONTENT
// ============================================================

class ReviewContent extends StatelessWidget {
  final CustomerReview review;

  const ReviewContent({
    super.key,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,

      crossAxisAlignment:
      CrossAxisAlignment.start,

      mainAxisAlignment:
      MainAxisAlignment.center,

      children: [
        // ======================================================
        // STARS + RATING
        // ======================================================

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
              review.star.toStringAsFixed(1),

              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),

        // ======================================================
        // GAP
        // ======================================================

        const SizedBox(height: 28),

        // ======================================================
        // REVIEW
        // ======================================================

        Flexible(
          child: Text(
            '"${review.review}"',

            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w500,
              height: 1.35,
              letterSpacing: -0.3,
            ),

            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // ======================================================
        // GAP
        // ======================================================

        const SizedBox(height: 25),

        // ======================================================
        // CLIENT
        // ======================================================

        Text(
          review.client,

          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 5),

        // ======================================================
        // TIME
        // ======================================================

        Text(
          review.time,

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
// QR CARD
// ============================================================

class ReviewQrCard extends StatelessWidget {
  const ReviewQrCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 120,

      padding: const EdgeInsets.all(16),

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
          // ====================================================
          // QR CODE
          // ====================================================

          Container(
            width: 80,
            height: 80,

            padding: const EdgeInsets.all(1),

            decoration: BoxDecoration(
              color: Colors.black,

              borderRadius:
              BorderRadius.circular(14),
            ),

            child: Image.asset(
              'assets/images/review_qr.png',

              fit: BoxFit.contain,

              errorBuilder:
                  (context, error, stackTrace) {
                return const Center(
                  child: Text(
                    'QR',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 18),

          // ====================================================
          // QR INFORMATION
          // ====================================================

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
                    fontSize: 15,
                    fontWeight:
                    FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  'Scan to leave a review',

                  maxLines: 1,

                  style: TextStyle(
                    color: Colors.white
                        .withOpacity(0.65),

                    fontSize: 13,
                    fontWeight:
                    FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 2),

                const Text(
                  'Scan the QR code',

                  maxLines: 1,

                  style: TextStyle(
                    color: Color(0xFFFFB000),
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w600,
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