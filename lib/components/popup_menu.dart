import 'package:caravanner/theme/colors.dart';
import 'package:flutter/material.dart';

class CPopupMenu<T> extends StatefulWidget {
  CPopupMenu({super.key, required this.items, required this.onSelected});

  final List<PopupMenuItem<T>> items;
  final Function(dynamic) onSelected;

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
      iconColor: CColors.interactive,
      position: PopupMenuPosition.under,
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
        ),
      ),
      onSelected: (T item) {
        widget.onSelected(item);
      },
      itemBuilder: (BuildContext context) => widget.items,
    );
  }
}
