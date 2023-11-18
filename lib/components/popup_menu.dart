import 'package:caravanner/theme/colors.dart';
import 'package:flutter/material.dart';

class CPopupMenu<T> extends StatefulWidget {
  const CPopupMenu({super.key, required this.items, required this.onSelected});

  final List<PopupMenuItem<T>> items;
  final void Function(T) onSelected;

  @override
  State<CPopupMenu> createState() => _PopupMenuState();
}

class _PopupMenuState<T> extends State<CPopupMenu<T>> {
  T? selectedMenu;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      color: CColors.interactive,
      // shape: CircleBorder(),
      iconColor: CColors.interactive,
      icon: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 40,
            height: 40,
            color: CColors.interactive,
            child: const Icon(
              Icons.edit,
              color: CColors.white,
            ),
          )),
      onSelected: (T item) {
        widget.onSelected(item);
      },
      itemBuilder: (BuildContext context) => widget.items,
    );
  }
}
