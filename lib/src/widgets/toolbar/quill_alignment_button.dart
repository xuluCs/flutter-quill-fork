// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';

import '../../models/documents/attribute.dart';
import '../../models/documents/style.dart';
import '../../models/themes/quill_popup_theme.dart';
import '../controller.dart';

class QuillAlignmentButton extends StatefulWidget {
  const QuillAlignmentButton({
    required this.items,
    required this.rawItemsMap,
    required this.controller,
    required this.onSelected,
    this.popupTheme,
    this.iconSize = 40,
    this.fillColor,
    this.afterButtonPressed,
    Key? key,
  }) : super(key: key);

  final double iconSize;
  final Color? fillColor;
  final List<PopupMenuEntry<Attribute>> Function(IconData) items;
  final Map<IconData, Attribute> rawItemsMap;
  final ValueChanged<Attribute> onSelected;
  final QuillPopupTheme? popupTheme;
  final QuillController controller;
  final VoidCallback? afterButtonPressed;

  @override
  _QuillAlignmentButtonState createState() => _QuillAlignmentButtonState();
}

class _QuillAlignmentButtonState extends State<QuillAlignmentButton> {
  late IconData _currentValue;
  Style get _selectionStyle => widget.controller.getSelectionStyle();

  Attribute<dynamic> _getAlignmentValue() {
    final attr = widget.controller.toolbarButtonToggler[Attribute.align.key];
    if (attr != null) {
      // checkbox tapping causes controller.selection to go to offset 0
      widget.controller.toolbarButtonToggler.remove(Attribute.align.key);
      return attr;
    }
    return _selectionStyle.attributes[Attribute.align.key] ?? Attribute.align;
  }

  @override
  void initState() {
    super.initState();
    _currentValue = _getKeyName(_getAlignmentValue());
    widget.controller.addListener(_didChangeEditingValue);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeEditingValue);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant QuillAlignmentButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_didChangeEditingValue);
      widget.controller.addListener(_didChangeEditingValue);
    }
  }

  void _didChangeEditingValue() {
    final keyName = _getKeyName(_getAlignmentValue());
    setState(() => _currentValue = keyName);
  }

  IconData _getKeyName(dynamic value) {
    for (final entry in widget.rawItemsMap.entries) {
      if (entry.value == value) {
        return entry.key;
      }
    }
    return Icons.format_align_left;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(height: widget.iconSize * 1.81),
      child: RawMaterialButton(
        constraints: const BoxConstraints(),
        visualDensity: VisualDensity.compact,
        fillColor: widget.fillColor,
        elevation: 0,
        hoverColor: widget.popupTheme?.hoverColor,
        focusColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: () {
          _showMenu();
          widget.afterButtonPressed?.call();
        },
        child: _buildContent(context),
      ),
    );
  }

  void _showMenu() {
    final button = context.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
            button.size.topCenter(
              Offset(
                button.size.width / 2,
                -(button.size.height * (widget.rawItemsMap.length + 2.5)),
              ),
            ),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    showMenu<Attribute>(
      context: context,
      position: position,
      items: widget.items(_currentValue),
      elevation: widget.popupTheme?.elevation,
      color: widget.popupTheme?.backgroundColor,
      constraints: BoxConstraints.tightFor(width: button.size.width),
    ).then((newValue) {
      if (!mounted) return;
      if (newValue == null) return;

      final keyName = _getKeyName(newValue);
      setState(() {
        _currentValue = keyName;
        widget.onSelected(newValue);
      });
    });
  }

  Widget _buildContent(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _currentValue,
              size: widget.iconSize / 1.15,
              color: widget.popupTheme?.buttonColor,
            ),
            const SizedBox(width: 3),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: widget.iconSize / 1.15,
              color: widget.popupTheme?.iconButtonColor ?? widget.popupTheme?.buttonColor,
            ),
          ],
        ),
      );
}
