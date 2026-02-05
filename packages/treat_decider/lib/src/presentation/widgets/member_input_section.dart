import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

import '../../domain/entities/team_member.dart';

class MemberInputSection extends StatefulWidget {
  final List<TeamMember> members;

  final ValueChanged<String> onAdd;
  final ValueChanged<String> onRemove;
  const MemberInputSection({
    super.key,
    required this.members,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<MemberInputSection> createState() => _MemberInputSectionState();
}

class _MemberInputSectionState extends State<MemberInputSection> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Team Members', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                decoration: const InputDecoration(hintText: 'Enter name'),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _addMember(),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            IconButton.filled(
              onPressed: _addMember,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        if (widget.members.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: widget.members.map((member) {
              return Chip(
                label: Text(
                  member.name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                onDeleted: () => widget.onRemove(member.id),
                deleteIcon: const Icon(Icons.close, size: 18),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addMember() {
    final name = _controller.text.trim();
    if (name.isNotEmpty) {
      widget.onAdd(name);
      _controller.clear();
      _focusNode.requestFocus();
    }
  }
}
