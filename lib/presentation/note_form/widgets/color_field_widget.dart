import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_ddd/application/notes/note_form/note_form_bloc.dart';
import 'package:try_ddd/domain/notes/value_objects.dart';

class ColorField extends StatelessWidget {
  const ColorField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteFormBloc, NoteFormState>(
      buildWhen: (previous, current) =>
          previous.note.color != current.note.color,
      builder: (context, state) {
        return SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            physics: const BouncingScrollPhysics(),
            itemCount: NoteColor.predefinedColors.length,
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                width: 12,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              final itemColor = NoteColor.predefinedColors[index];
              return GestureDetector(
                onTap: () {
                  context
                      .read<NoteFormBloc>()
                      .add(NoteFormEvent.colorChanged(itemColor));
                },
                child: Material(
                  color: itemColor,
                  elevation: 4,
                  shape: CircleBorder(
                      side: state.note.color.value.fold(
                    (_) => BorderSide.none,
                    (color) => color == itemColor
                        ? const BorderSide(width: 1.5)
                        : BorderSide.none,
                  )),
                  child: const SizedBox(
                    height: 50,
                    width: 50,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
