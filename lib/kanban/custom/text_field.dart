import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/kanban/Provider/provider_list.dart';

class TField extends ConsumerStatefulWidget {
  const TField({super.key});

  @override
  ConsumerState<TField> createState() => _TFieldState();
}

class _TFieldState extends ConsumerState<TField> {
  var node = FocusNode();
  @override
  Widget build(BuildContext context) {
    var prov = ref.read(ProviderList.boardProvider);
    return TextFormField(
      decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
          disabledBorder: OutlineInputBorder(borderSide: BorderSide.none)),
      autofocus: true,
      enabled: true,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      style: prov.board.textStyle,
      controller: prov.board.newCardTextController,
      focusNode: node,
    );
  }
}
