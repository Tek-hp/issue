import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issue/foc/cubit/focus_cubit_cubit.dart';
import 'package:issue/model.dart';
import 'package:issue/widgets/add_button.dart';
import 'package:issue/widgets/option.dart';

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
