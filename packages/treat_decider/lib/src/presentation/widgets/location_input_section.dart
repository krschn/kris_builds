import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

import '../../domain/entities/location.dart';

class LocationInputSection extends StatefulWidget {
  final List<Location> locations;

  final ValueChanged<String> onAdd;
  final ValueChanged<String> onRemove;
  const LocationInputSection({
    super.key,
    required this.locations,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<LocationInputSection> createState() => _LocationInputSectionState();
}

class _LocationInputSectionState extends State<LocationInputSection> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Locations', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                decoration: const InputDecoration(hintText: 'Enter location'),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _addLocation(),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            IconButton.filled(
              onPressed: _addLocation,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        if (widget.locations.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: widget.locations.map((location) {
              return Chip(
                label: Text(
                  location.name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                onDeleted: () => widget.onRemove(location.id),
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

  void _addLocation() {
    final name = _controller.text.trim();
    if (name.isNotEmpty) {
      widget.onAdd(name);
      _controller.clear();
      _focusNode.requestFocus();
    }
  }
}
