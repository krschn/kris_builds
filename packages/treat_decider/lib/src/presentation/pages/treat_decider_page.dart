import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgets/widgets.dart';

import '../../domain/entities/location.dart';
import '../../domain/entities/team_member.dart';
import '../bloc/treat_decider_bloc.dart';
import '../theme/treat_decider_theme.dart';
import '../widgets/location_input_section.dart';
import '../widgets/member_input_section.dart';
import '../widgets/selection_animation.dart';
import '../widgets/winner_announcement.dart';
import 'treat_history_page.dart';

class TreatDeciderPage extends StatelessWidget {
  const TreatDeciderPage({
    super.key,
    this.onNavigateToHistory,
  });

  final VoidCallback? onNavigateToHistory;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: TreatDeciderTheme.light,
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('Treat Decider'),
              actions: [
                IconButton(
                  onPressed: () {
                    if (onNavigateToHistory != null) {
                      onNavigateToHistory!();
                    } else {
                      _navigateToHistory(context);
                    }
                  },
                  icon: const Icon(Icons.history),
                  tooltip: 'History',
                ),
              ],
            ),
            body: BlocConsumer<TreatDeciderBloc, TreatDeciderState>(
              listener: (context, state) {
                if (state is TreatDeciderError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: theme.colorScheme.error,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return switch (state) {
                  TreatDeciderInitial() ||
                  TreatDeciderInput() ||
                  TreatDeciderError() =>
                    _buildInputForm(context, state),
                  TreatDeciderSelecting(
                    :final teamMembers,
                    :final locations,
                    :final selectedMember,
                    :final selectedLocation,
                  ) =>
                    _buildSelecting(
                      context,
                      teamMembers,
                      locations,
                      selectedMember,
                      selectedLocation,
                    ),
                  TreatDeciderResult(:final result) => WinnerAnnouncement(
                      result: result,
                      onNewDecision: () {
                        context.read<TreatDeciderBloc>().add(const ResetForm());
                      },
                      onViewHistory: () {
                        if (onNavigateToHistory != null) {
                          onNavigateToHistory!();
                        } else {
                          _navigateToHistory(context);
                        }
                      },
                    ),
                  TreatDeciderHistoryLoaded() => _buildInputForm(context, state),
                };
              },
            ),
          );
        },
      ),
    );
  }

  void _navigateToHistory(BuildContext context) {
    context.read<TreatDeciderBloc>().add(const LoadHistory());
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<TreatDeciderBloc>(),
          child: const TreatHistoryPage(),
        ),
      ),
    );
  }

  Widget _buildInputForm(BuildContext context, TreatDeciderState state) {
    final input = state is TreatDeciderInput
        ? state
        : TreatDeciderInput(
            teamMembers: const [],
            locations: const [],
            date: DateTime.now(),
          );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDatePicker(context, input.date),
          const SizedBox(height: AppSpacing.xl),
          MemberInputSection(
            members: input.teamMembers,
            onAdd: (name) {
              context.read<TreatDeciderBloc>().add(AddTeamMember(name));
            },
            onRemove: (id) {
              context.read<TreatDeciderBloc>().add(RemoveTeamMember(id));
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          LocationInputSection(
            locations: input.locations,
            onAdd: (name) {
              context.read<TreatDeciderBloc>().add(AddLocation(name));
            },
            onRemove: (id) {
              context.read<TreatDeciderBloc>().add(RemoveLocation(id));
            },
          ),
          const SizedBox(height: AppSpacing.xxl),
          ElevatedButton(
            onPressed: input.teamMembers.isNotEmpty && input.locations.isNotEmpty
                ? () {
                    context.read<TreatDeciderBloc>().add(const DecideWinner());
                  }
                : null,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text('Decide Now'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, DateTime date) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        InkWell(
          onTap: () async {
            final selected = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (selected != null && context.mounted) {
              context.read<TreatDeciderBloc>().add(SetDate(selected));
            }
          },
          borderRadius: AppSpacing.borderRadiusMd,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.outline),
              borderRadius: AppSpacing.borderRadiusMd,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  _formatDate(date),
                  style: theme.textTheme.bodyLarge,
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_drop_down,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelecting(
    BuildContext context,
    List<TeamMember> teamMembers,
    List<Location> locations,
    TeamMember selectedMember,
    Location selectedLocation,
  ) {
    return SelectionAnimation(
      teamMembers: teamMembers,
      locations: locations,
      selectedMember: selectedMember,
      selectedLocation: selectedLocation,
      onComplete: () {
        // Animation completed - bloc will have already emitted TreatDeciderResult
        // which will trigger a rebuild with WinnerAnnouncement
      },
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
