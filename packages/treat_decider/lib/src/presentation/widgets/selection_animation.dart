import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

import '../../domain/entities/location.dart';
import '../../domain/entities/team_member.dart';

class SelectionAnimation extends StatefulWidget {
  const SelectionAnimation({
    super.key,
    required this.teamMembers,
    required this.locations,
    required this.onComplete,
    required this.selectedMember,
    required this.selectedLocation,
  });

  final List<TeamMember> teamMembers;
  final List<Location> locations;
  final VoidCallback onComplete;
  final TeamMember selectedMember;
  final Location selectedLocation;

  @override
  State<SelectionAnimation> createState() => _SelectionAnimationState();
}

class _SelectionAnimationState extends State<SelectionAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  Timer? _shuffleTimer;
  int _currentMemberIndex = 0;
  int _currentLocationIndex = 0;
  bool _isComplete = false;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _startShuffling();
  }

  void _startShuffling() {
    var intervalMs = 50;
    var iterations = 0;
    const maxIterations = 30;

    void shuffle() {
      if (iterations >= maxIterations) {
        _finishAnimation();
        return;
      }

      setState(() {
        _currentMemberIndex = _random.nextInt(widget.teamMembers.length);
        _currentLocationIndex = _random.nextInt(widget.locations.length);
      });

      iterations++;
      // Slow down progressively
      intervalMs = 50 + (iterations * 10);

      _shuffleTimer = Timer(Duration(milliseconds: intervalMs), shuffle);
    }

    shuffle();
  }

  void _finishAnimation() {
    // Set to final selected values
    setState(() {
      _currentMemberIndex = widget.teamMembers.indexOf(widget.selectedMember);
      _currentLocationIndex = widget.locations.indexOf(widget.selectedLocation);
      _isComplete = true;
    });

    _controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 500), widget.onComplete);
    });
  }

  @override
  void dispose() {
    _shuffleTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentMember = widget.teamMembers[_currentMemberIndex];
    final currentLocation = widget.locations[_currentLocationIndex];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Selecting...',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _isComplete ? _scaleAnimation.value : 1.0,
                child: child,
              );
            },
            child: Card(
              elevation: _isComplete ? 4 : 2,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 100),
                      child: Text(
                        currentMember.name,
                        key: ValueKey('member-${currentMember.id}'),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 100),
                          child: Text(
                            currentLocation.name,
                            key: ValueKey('location-${currentLocation.id}'),
                            style: theme.textTheme.titleLarge,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
