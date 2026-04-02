import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShuffleBanner extends StatefulWidget {
  const ShuffleBanner({super.key});

  @override
  State<ShuffleBanner> createState() => _ShuffleBannerState();
}

class _ShuffleBannerState extends State<ShuffleBanner> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _controller;
  bool _isAnimating = false;
  Timer? _autoPlayTimer;

  final List<Map<String, dynamic>> _bannerData = [
    {
      'title': 'Get 50% OFF\non your first order',
      'promo': 'WELCOME50',
      'image': 'https://cdn-icons-png.flaticon.com/512/3132/3132693.png',
      'colors': [const Color(0xFF2D3436), const Color(0xFF000000)],
      'tag': 'PROMO',
    },
    {
      'title': 'Free Delivery\non all orders over \$30',
      'promo': 'FREESHIP',
      'image': 'https://cdn-icons-png.flaticon.com/512/1048/1048329.png',
      'colors': [const Color(0xFFFF4B2B), const Color(0xFFFF8E53)],
      'tag': 'OFFER',
    },
    {
      'title': 'Fresh Organic\nVegetables Every Day',
      'promo': 'ORGANIC20',
      'image': 'https://cdn-icons-png.flaticon.com/512/2329/2329865.png',
      'colors': [const Color(0xFF00B894), const Color(0xFF55E6C1)],
      'tag': 'FRESH',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) _shuffle();
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _shuffle() {
    if (_isAnimating) return;
    setState(() => _isAnimating = true);
    
    _controller.forward().then((_) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _bannerData.length;
          _controller.reset();
          _isAnimating = false;
        });
      }
    });
    
    // Restart autoplay timer on manual interaction
    _startAutoPlay();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          _shuffle();
        }
      },
      onTap: _shuffle,
      child: Container(
        height: 240,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: List.generate(_bannerData.length, (index) {
            int relativeIndex = (index - _currentIndex) % _bannerData.length;
            if (relativeIndex < 0) relativeIndex += _bannerData.length;

            if (relativeIndex > 2) return const SizedBox.shrink();

            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                double t = _controller.value;
                double xOffset = 0;
                double rotation = 0;
                double opacity = 1.0;
                double scale = 1.0 - (relativeIndex * 0.06);
                double yOffset = relativeIndex * 15.0;
                double tilt = 0;

                // Elastic and bounce curves for more realism
                final Curve slideOutCurve = Curves.easeInOutBack;
                final Curve moveForwardCurve = Curves.elasticOut;

                if (relativeIndex == 0) {
                  // Top card moves out with 3D tilt
                  double slideValue = slideOutCurve.transform(t);
                  xOffset = -slideValue * 450;
                  rotation = -slideValue * 0.4;
                  tilt = -slideValue * 0.5;
                  opacity = 1.0 - (t * 1.5).clamp(0.0, 1.0);
                } else {
                  // Other cards move forward with bounce
                  double forwardValue = moveForwardCurve.transform(t);
                  scale = (1.0 - (relativeIndex * 0.06)) + (forwardValue * 0.06);
                  yOffset = (relativeIndex * 15.0) - (forwardValue * 15.0);
                }

                return Positioned(
                  top: yOffset,
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001) // perspective
                      ..rotateZ(rotation)
                      ..rotateY(tilt),
                    alignment: Alignment.center,
                    child: Transform.translate(
                      offset: Offset(xOffset, 0),
                      child: Transform.scale(
                        scale: scale,
                        child: Opacity(
                          opacity: opacity,
                          child: _buildBannerCard(_bannerData[index], t, relativeIndex == 0),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }).reversed.toList(),
        ),
      ),
    );
  }

  Widget _buildBannerCard(Map<String, dynamic> data, double animValue, bool isTop) {
    // Parallax effect for the image/icon
    double parallaxOffset = isTop ? animValue * 30 : 0;

    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: data['colors'],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: (data['colors'][0] as Color).withOpacity(0.4),
            blurRadius: 25,
            spreadRadius: -5,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Background Parallax Icon
            Positioned(
              right: -30 + parallaxOffset,
              bottom: -30,
              child: Opacity(
                opacity: 0.15,
                child: Transform.rotate(
                  angle: animValue * 0.2,
                  child: const Icon(Icons.shopping_bag_rounded, size: 220, color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      data['tag'],
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    data['title'],
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Text(
                        'CODE:',
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          data['promo'],
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Floating Image with Parallax
            Positioned(
              right: 20 - parallaxOffset,
              top: 25,
              child: Transform.scale(
                scale: 1.0 + (animValue * 0.1),
                child: Image.network(
                  data['image'],
                  height: 110,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => const Icon(Icons.stars, size: 80, color: Colors.white),
                ),
              ),
            ),
            // "Peek" Indicator (visible on background cards)
            if (!isTop)
              Positioned(
                bottom: 10,
                right: 20,
                child: Icon(Icons.keyboard_double_arrow_left_rounded, color: Colors.white.withOpacity(0.3), size: 24),
              ),
          ],
        ),
      ),
    );
  }
}
