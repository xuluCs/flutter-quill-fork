// ignore_for_file: lines_longer_than_80_chars
import 'package:flutter/material.dart';

import '../../models/documents/attribute.dart';
import '../../models/documents/style.dart';
import '../../models/themes/quill_popup_theme.dart';
import '../controller.dart';

class QuillHeaderStyleButton extends StatefulWidget {
  const QuillHeaderStyleButton({
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
  final List<PopupMenuEntry<Attribute>> Function(String) items;
  final Map<String, Attribute> rawItemsMap;
  final ValueChanged<Attribute> onSelected;
  final QuillPopupTheme? popupTheme;
  final QuillController controller;
  final VoidCallback? afterButtonPressed;

  @override
  _QuillHeaderStyleButtonState createState() => _QuillHeaderStyleButtonState();
}

class _QuillHeaderStyleButtonState extends State<QuillHeaderStyleButton> {
  late String _currentValue;
  Style get _selectionStyle => widget.controller.getSelectionStyle();

  Attribute<dynamic> _getHeaderValue() {
    final attr = widget.controller.toolbarButtonToggler[Attribute.header.key];
    if (attr != null) {
      // checkbox tapping causes controller.selection to go to offset 0
      widget.controller.toolbarButtonToggler.remove(Attribute.header.key);
      return attr;
    }
    return _selectionStyle.attributes[Attribute.header.key] ?? Attribute.header;
  }

  @override
  void initState() {
    super.initState();
    _currentValue = _getKeyName(_getHeaderValue());
    widget.controller.addListener(_didChangeEditingValue);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeEditingValue);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant QuillHeaderStyleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_didChangeEditingValue);
      widget.controller.addListener(_didChangeEditingValue);
    }
  }

  void _didChangeEditingValue() {
    final keyName = _getKeyName(_getHeaderValue());
    setState(() => _currentValue = keyName);
  }

  String _getKeyName(dynamic value) {
    for (final entry in widget.rawItemsMap.entries) {
      if (entry.value == value) {
        return entry.key;
      }
    }
    return _currentValue;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(height: widget.iconSize * 2),
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
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
            button.size.topCenter(
              Offset(
                button.size.width / 2,
                -(button.size.height * (widget.rawItemsMap.length + 2.85)),
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
            Text(
              _currentValue,
              style: TextStyle(
                fontSize: widget.iconSize / 1.15,
                color: widget.popupTheme?.buttonColor,
              ),
            ),
            const SizedBox(width: 3),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: widget.iconSize / 1.15,
              color: widget.popupTheme?.iconButtonColor ?? widget.popupTheme?.buttonColor,
            )
          ],
        ),
      );
}
