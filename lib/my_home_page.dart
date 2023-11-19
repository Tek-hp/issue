import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issue/foc/cubit/focus_cubit_cubit.dart';
import 'package:issue/model.dart';

import 'bloc/list_bloc.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (context) => FocusIndexCubit(),
        child: BlocBuilder<ListBloc, ListState>(
          builder: (context, state) {
            return Center(
              child: Container(
                height: 400,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: const AppOptionWidget(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AppOptionWidget extends StatefulWidget {
  const AppOptionWidget({super.key});

  @override
  State<AppOptionWidget> createState() => _AppOptionWidgetState();
}

class _AppOptionWidgetState extends State<AppOptionWidget> {
  DataModel data = const DataModel();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ListBloc, ListState>(
      listener: (context, state) {
        if (state is UpdateListState) {
          data = state.data;
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                for (int i = 0; i < data.multiFields!.length; i++)
                  OptionWidget(
                    index: i,
                    isFocused: context.watch<FocusIndexCubit>().isFocused(i),
                    key: ValueKey('$i :: ${data.multiFields![i]}'),
                    initialText: data.multiFields![i],
                    onEditingComplete: (submittedOption) {
                      context.read<FocusIndexCubit>().changeFocus(null);
                      final multi = [...data.multiFields!];

                      multi[i] = submittedOption;

                      BlocProvider.of<ListBloc>(context).add(
                        UpdateListEvent(
                          multiFields: multi,
                        ),
                      );
                      FocusScope.of(context).unfocus();
                    },
                    onDelete: () {
                      log('Deleting an item :: ${data.multiFields![i]}');
                      final multi = [...data.multiFields!]..removeAt(i);

                      log('Deleting an item :: After deleting :: $multi');

                      BlocProvider.of<ListBloc>(context).add(
                        UpdateListEvent(
                          multiFields: multi,
                        ),
                      );
                    },
                    hint: 'Option ${i + 1}',
                  ),
                AddOptionButton(
                  onTap: () {
                    // context
                    //     .read<FocusIndexCubit>()
                    //     .changeFocus(data.multiFields!.length + 1);
                    BlocProvider.of<ListBloc>(context).add(
                      UpdateListEvent(
                        multiFields: [...data.multiFields!, ''],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class OptionWidget extends StatefulWidget {
  const OptionWidget({
    required this.initialText,
    required this.isFocused,
    required this.index,
    this.onDelete,
    this.onEditingComplete,
    this.selectThisOption,
    this.hint,
    this.isSelected = false,
    this.canDelete = true,
    super.key,
  });

  final VoidCallback? onDelete;
  final void Function(String)? onEditingComplete;
  final void Function(String)? selectThisOption;
  final bool isFocused;
  final int index;

  final String? hint;
  final String initialText;
  final bool isSelected;
  final bool canDelete;

  @override
  State<OptionWidget> createState() => _OptionWidgetState();
}

class _OptionWidgetState extends State<OptionWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.initialText);

    context.read<FocusIndexCubit>().changeFocus(widget.index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hasFocus = context.watch<FocusIndexCubit>().isFocused(widget.index);
    return BlocBuilder<FocusIndexCubit, int?>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            widget.selectThisOption?.call(_controller.text);
          },
          onDoubleTap: () {
            if (!hasFocus) {
              context.read<FocusIndexCubit>().changeFocus(widget.index);
            }
          },
          child: SizedBox(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  constraints: const BoxConstraints(
                    minHeight: 37,
                    maxWidth: 148,
                    minWidth: 148,
                  ),
                  decoration: BoxDecoration(
                    color: widget.isSelected
                        ? Colors.green.withOpacity(
                            0.3,
                          )
                        : ThemeData().canvasColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(),
                  ),
                  child: !hasFocus
                      ? Center(child: Text(_controller.text))
                      : TextField(
                          controller: _controller,
                          autofocus: true,
                          decoration: InputDecoration(hintText: widget.hint),
                          onEditingComplete: () {
                            // if (widget.onEditingComplete != null) {
                            //   canEditField = false;
                            // }
                            widget.onEditingComplete?.call(_controller.text);
                          },
                        ),
                ),
                if (widget.canDelete)
                  Positioned(
                    right: -5,
                    top: -5,
                    child: InkWell(
                      onTap: widget.onDelete,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffCFD5E2),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.close,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}

class AddOptionButton extends StatelessWidget {
  const AddOptionButton({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        width: 148,
        padding: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Icon(
                Icons.add_rounded,
                size: 12,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            const Text('Add'),
          ],
        ),
      ),
    );
  }
}
