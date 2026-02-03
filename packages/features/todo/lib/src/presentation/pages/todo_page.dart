import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/todo.dart';
import '../../providers/todo_providers.dart';
import '../../providers/todo_state.dart';

class TodoPage extends ConsumerStatefulWidget {
  const TodoPage({super.key, this.onLogout});

  final VoidCallback? onLogout;

  @override
  ConsumerState<TodoPage> createState() => _TodoPageState();
}

/// Individual todo item widget
class _TodoItem extends StatelessWidget {
  const _TodoItem({
    required this.todo,
    required this.onTap,
    required this.onToggle,
  });

  final Todo todo;
  final VoidCallback onTap;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Semantics(
                label:
                    todo.isCompleted ? 'Mark as incomplete' : 'Mark as complete',
                child: InkWell(
                  onTap: onToggle,
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: todo.isCompleted
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline,
                        width: 2,
                      ),
                      color: todo.isCompleted
                          ? theme.colorScheme.primary
                          : Colors.transparent,
                    ),
                    child: todo.isCompleted
                        ? Icon(
                            Icons.check,
                            size: 16,
                            color: theme.colorScheme.onPrimary,
                          )
                        : null,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    todo.title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      decoration:
                          todo.isCompleted ? TextDecoration.lineThrough : null,
                      color: todo.isCompleted
                          ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                          : null,
                    ),
                  ),
                  if (todo.description != null &&
                      todo.description!.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 4),
                    Text(
                      todo.description!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        decoration:
                            todo.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _TodoPageState extends ConsumerState<TodoPage> {
  @override
  void initState() {
    super.initState();
    // Load todos when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(todoProvider.notifier).loadTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TodoState state = ref.watch(todoProvider);

    // Listen for errors and show snackbar
    ref.listen<TodoState>(todoProvider, (TodoState? previous, TodoState next) {
      if (next is TodoError) {
        AppSnackbar.error(context: context, message: next.message);
      }
    });

    return AppScaffold(
      title: 'My Todos',
      actions: widget.onLogout != null
          ? <Widget>[
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: widget.onLogout,
                tooltip: 'Logout',
              ),
            ]
          : null,
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
      body: _buildBody(theme, state),
    );
  }

  Widget _buildBody(ThemeData theme, TodoState state) {
    if (state is TodoLoading) {
      return const Center(
        child: AppLoadingIndicator(size: AppLoadingSize.large),
      );
    }

    if (state is TodoLoaded) {
      if (state.todos.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.task_alt,
                size: 80,
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
              AppSpacing.gapLg,
              Text('No todos yet', style: theme.textTheme.headlineSmall),
              AppSpacing.gapSm,
              Text(
                'Tap + to add your first todo',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          await ref.read(todoProvider.notifier).loadTodos();
        },
        child: ListView(
          padding: AppSpacing.paddingLg,
          children: <Widget>[
            if (state.incompleteTodos.isNotEmpty) ...<Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: AppSpacing.sm),
                child: Text(
                  'Active (${state.incompleteTodos.length})',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              ...state.incompleteTodos.map(
                (Todo todo) => _TodoItem(
                  todo: todo,
                  onTap: () => _showEditTodoDialog(todo),
                  onToggle: () =>
                      ref.read(todoProvider.notifier).toggleTodoCompletion(todo.id),
                ),
              ),
            ],
            if (state.completedTodos.isNotEmpty) ...<Widget>[
              AppSpacing.gapLg,
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: AppSpacing.sm),
                child: Text(
                  'Completed (${state.completedTodos.length})',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              ...state.completedTodos.map(
                (Todo todo) => _TodoItem(
                  todo: todo,
                  onTap: () => _showEditTodoDialog(todo),
                  onToggle: () =>
                      ref.read(todoProvider.notifier).toggleTodoCompletion(todo.id),
                ),
              ),
            ],
            AppSpacing.gapXxl,
          ],
        ),
      );
    }

    return Center(
      child: AppButton.primary(
        onPressed: () => ref.read(todoProvider.notifier).loadTodos(),
        label: 'Load Todos',
      ),
    );
  }

  void _showAddTodoDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    AppBottomSheet.show<void>(
      context: context,
      title: 'Add Todo',
      showCloseButton: true,
      isScrollControlled: true,
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AppTextField(
              controller: titleController,
              label: 'Title',
              hint: 'Enter todo title',
              autofocus: true,
              textInputAction: TextInputAction.next,
            ),
            AppSpacing.gapLg,
            AppTextField.multiline(
              controller: descriptionController,
              label: 'Description',
              hint: 'Enter description (optional)',
              minLines: 2,
              maxLines: 4,
            ),
            AppSpacing.gapXl,
            AppButton.primary(
              onPressed: () {
                if (titleController.text.trim().isNotEmpty) {
                  ref.read(todoProvider.notifier).addTodo(
                        title: titleController.text.trim(),
                        description: descriptionController.text.trim().isEmpty
                            ? null
                            : descriptionController.text.trim(),
                      );
                  Navigator.of(context).pop();
                }
              },
              label: 'Add Todo',
              isExpanded: true,
            ),
          ],
        ),
      ),
    );
  }

  void _showEditTodoDialog(Todo todo) {
    final TextEditingController titleController =
        TextEditingController(text: todo.title);
    final TextEditingController descriptionController = TextEditingController(
      text: todo.description ?? '',
    );

    AppBottomSheet.show<void>(
      context: context,
      title: 'Edit Todo',
      showCloseButton: true,
      isScrollControlled: true,
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AppTextField(
              controller: titleController,
              label: 'Title',
              hint: 'Enter todo title',
              autofocus: true,
              textInputAction: TextInputAction.next,
            ),
            AppSpacing.gapLg,
            AppTextField.multiline(
              controller: descriptionController,
              label: 'Description',
              hint: 'Enter description (optional)',
              minLines: 2,
              maxLines: 4,
            ),
            AppSpacing.gapXl,
            AppButton.primary(
              onPressed: () {
                if (titleController.text.trim().isNotEmpty) {
                  ref.read(todoProvider.notifier).updateTodo(
                        todo.copyWith(
                          title: titleController.text.trim(),
                          description:
                              descriptionController.text.trim().isEmpty
                                  ? null
                                  : descriptionController.text.trim(),
                        ),
                      );
                  Navigator.of(context).pop();
                }
              },
              label: 'Save Changes',
              isExpanded: true,
            ),
            AppSpacing.gapMd,
            AppButton.outlined(
              onPressed: () async {
                Navigator.of(context).pop();
                final bool confirmed = await AppDialog.showConfirm(
                  context: context,
                  title: 'Delete Todo',
                  content: 'Are you sure you want to delete this todo?',
                  confirmLabel: 'Delete',
                  isDestructive: true,
                );
                if (confirmed && mounted) {
                  ref.read(todoProvider.notifier).deleteTodo(todo.id);
                }
              },
              label: 'Delete',
              isExpanded: true,
            ),
          ],
        ),
      ),
    );
  }
}
