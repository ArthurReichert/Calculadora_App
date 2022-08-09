import 'package:flutter/material.dart';
import 'button.dart';

class ButtonRow extends StatelessWidget {
  
  final List<Button> buttons;

  ButtonRow(
    this.buttons
  );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch, //estica os elementos
        children: buttons.fold(<Widget>[], (list, b) {
          //Caso a lista vazia adiciona um botão, caso não vazia sizedbox depois botão
          list.isEmpty ? list.add(b) : list.addAll([SizedBox(width: 1),b]);
          return list;
        }),
      ),
    );
  }
}