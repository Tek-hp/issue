import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issue/foc/cubit/focus_cubit_cubit.dart';

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
