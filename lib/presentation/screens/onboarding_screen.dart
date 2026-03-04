import 'dart:math';

import 'package:flutter/material.dart';

import '../../data/datasources/onboarding_storage.dart';

class _OnboardingStep {
  final String title;
  final String description;
  final IconData icon;

  const _OnboardingStep({
    required this.title,
    required this.description,
    required this.icon,
  });
}

const _steps = [
  _OnboardingStep(
    title: 'Swipe!',
    description:
        'Swipe left to like a cat,\n'
        'or right to skip.\n'
        'Bottom buttons work too!',
    icon: Icons.swipe,
  ),
  _OnboardingStep(
    title: 'Discover Breeds',
    description:
        'Tap on a card to see details about the breed:\n'
        'details about the breed: description,\n'
        'weight, lifespan.',
    icon: Icons.info_outline,
  ),
  _OnboardingStep(
    title: 'All Breeds',
    description:
        'Switch to the «Breeds» tab\n'
        'to view the full catalog\n'
        'of cat breeds with photos.',
    icon: Icons.list_alt,
  ),
];

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  int _currentPage = 0;

  // Cat bounce animation
  late final AnimationController _bounceController;
  late final Animation<double> _bounceAnimation;

  // Fade-in to hide emoji font loading delay
  late final AnimationController _fadeController;

  // Cat rotation driven by page scroll
  double _pageOffset = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController()..addListener(_onPageScroll);

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _fadeController.forward();
    });
  }

  void _onPageScroll() {
    setState(() {
      _pageOffset = _pageController.page ?? 0;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bounceController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await markOnboardingCompleted();
    widget.onComplete();
  }

  void _next() {
    if (_currentPage < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Animated cat
            SizedBox(
              height: 180,
              child: AnimatedBuilder(
                animation: Listenable.merge([_bounceController]),
                builder: (context, child) {
                  // Rotate cat based on page scroll offset
                  final rotation =
                      sin((_pageOffset - _pageOffset.floor()) * pi) * 0.3;
                  // Bounce vertically
                  final bounce = _bounceAnimation.value;

                  return Transform.translate(
                    offset: Offset(0, bounce),
                    child: Transform.rotate(angle: rotation, child: child),
                  );
                },
                child: FadeTransition(
                  opacity: _fadeController,
                  child: Text('🐱', style: TextStyle(fontSize: 120)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _steps.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, index) {
                  final step = _steps[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        Icon(
                          step.icon,
                          size: 64,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          step.title,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          step.description,
                          style: theme.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_steps.length, (i) {
                final isActive = i == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.primary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                children: [
                  if (_currentPage < _steps.length - 1)
                    TextButton(onPressed: _finish, child: const Text('Skip')),
                  const Spacer(),
                  FilledButton(
                    onPressed: _next,
                    child: Text(
                      _currentPage < _steps.length - 1
                          ? 'Next'
                          : 'Get Started!',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
