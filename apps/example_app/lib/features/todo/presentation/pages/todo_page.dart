import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgets/widgets.dart';

import '../../domain/entities/todo.dart';
import '../bloc/todo_bloc.dart';

/// Todo list page displaying and managing todos.
class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

/// Individual todo item widget
class _TodoItem extends StatelessWidget {
  final Todo todo;

  final VoidCallback onTap;
  final VoidCallback onToggle;
  const _TodoItem({
    required this.todo,
    required this.onTap,
    required this.onToggle,
  });

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
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Semantics(
                label: todo.isCompleted
                    ? 'Mark as incomplete'
                    : 'Mark as complete',
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
                children: [
                  Text(
                    todo.title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      decoration: todo.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      color: todo.isCompleted
                          ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                          : null,
                    ),
                  ),
                  if (todo.description != null &&
                      todo.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      todo.description!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
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

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return AppScaffold(
      title: 'My Todos',
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            context.read<AuthBloc>().add(const LogoutRequested());
          },
          tooltip: 'Logout',
        ),
      ],
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state is TodoError) {
            AppSnackbar.error(context: context, message: state.message);
          }
        },
        builder: (context, state) {
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
                  children: [
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
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<TodoBloc>().add(const LoadTodos());
              },
              child: ListView(
                padding: AppSpacing.paddingLg,
                children: [
                  if (state.incompleteTodos.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 4,
                        bottom: AppSpacing.sm,
                      ),
                      child: Text(
                        'Active (${state.incompleteTodos.length})',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ...state.incompleteTodos.map(
                      (Todo todo) => _TodoItem(
                        todo: todo,
                        onTap: () => _showEditTodoDialog(todo),
                        onToggle: () => context.read<TodoBloc>().add(
                          ToggleTodoCompletion(todo.id),
                        ),
                      ),
                    ),
                  ],
                  if (state.completedTodos.isNotEmpty) ...[
                    AppSpacing.gapLg,
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 4,
                        bottom: AppSpacing.sm,
                      ),
                      child: Text(
                        'Completed (${state.completedTodos.length})',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ...state.completedTodos.map(
                      (Todo todo) => _TodoItem(
                        todo: todo,
                        onTap: () => _showEditTodoDialog(todo),
                        onToggle: () => context.read<TodoBloc>().add(
                          ToggleTodoCompletion(todo.id),
                        ),
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
              onPressed: () => context.read<TodoBloc>().add(const LoadTodos()),
              label: 'Load Todos',
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Load todos when page initializes
    context.read<TodoBloc>().add(const LoadTodos());
  }

  void _showAddTodoDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    AppBottomSheet.show(
      context: context,
      title: 'Add Todo',
      showCloseButton: true,
      isScrollControlled: true,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                  context.read<TodoBloc>().add(
                    AddTodo(
                      title: titleController.text.trim(),
                      description: descriptionController.text.trim().isEmpty
                          ? null
                          : descriptionController.text.trim(),
                    ),
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
    final TextEditingController titleController = TextEditingController(
      text: todo.title,
    );
    final TextEditingController descriptionController = TextEditingController(
      text: todo.description ?? '',
    );

    AppBottomSheet.show(
      context: context,
      title: 'Edit Todo',
      showCloseButton: true,
      isScrollControlled: true,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                  context.read<TodoBloc>().add(
                    UpdateTodo(
                      todo.copyWith(
                        title: titleController.text.trim(),
                        description: descriptionController.text.trim().isEmpty
                            ? null
                            : descriptionController.text.trim(),
                      ),
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
                  context.read<TodoBloc>().add(DeleteTodo(todo.id));
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
