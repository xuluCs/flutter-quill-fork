// ignore_for_file: lines_longer_than_80_chars
import 'package:flutter/material.dart';

import '../../models/documents/attribute.dart';
import '../../models/documents/style.dart';
import '../../models/themes/quill_icon_theme.dart';
import '../controller.dart';

class QuillHeaderStyleButton extends StatefulWidget {
  const QuillHeaderStyleButton({
    required this.items,
    required this.rawItemsMap,
    required this.controller,
    required this.onSelected,
    this.iconSize = 40,
    this.fillColor,
    this.hoverElevation = 1,
    this.highlightElevation = 1,
    this.iconTheme,
    this.afterButtonPressed,
    Key? key,
  }) : super(key: key);

  final double iconSize;
  final Color? fillColor;
  final double hoverElevation;
  final double highlightElevation;
  final List<PopupMenuEntry<Attribute>> Function(String) items;
  final Map<String, Attribute> rawItemsMap;
  final ValueChanged<Attribute> onSelected;
  final QuillIconTheme? iconTheme;
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
    setState(() {
      _currentValue = _getKeyName(_getHeaderValue());
    });
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
      constraints: BoxConstraints.tightFor(height: widget.iconSize * 1.81),
      child: RawMaterialButton(
        constraints: const BoxConstraints(),
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.iconTheme?.borderRadius ?? 2)),
        fillColor: widget.fillColor,
        elevation: 0,
        hoverElevation: widget.hoverElevation,
        highlightElevation: widget.hoverElevation,
        onPressed: () {
          _showMenu();
          widget.afterButtonPressed?.call();
        },
        child: _buildContent(context),
      ),
    );
  }

  void _showMenu() {
    final popupMenuTheme = PopupMenuTheme.of(context);
    final button = context.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
            button.size.topCenter(
              Offset(
                button.size.width / 2,
                -(button.size.height * (widget.rawItemsMap.length + 4)),
              ),
            ),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    showMenu<Attribute>(
      context: context,
      elevation: 4,
      items: widget.items(_currentValue),
      position: position,
      shape: popupMenuTheme.shape,
      color: popupMenuTheme.color,
      constraints: BoxConstraints.tightFor(width: button.size.width),
    ).then((newValue) {
      if (!mounted) return;
      if (newValue == null) return;

      final keyName = _getKeyName(newValue);
      final _attribute = newValue == _getHeaderValue() ? Attribute.header : newValue;
      setState(() {
        _currentValue = keyName;
        widget.onSelected(_attribute);
      });
    });
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _currentValue,
            style: TextStyle(
              fontSize: widget.iconSize / 1.15,
            ),
          ),
          const SizedBox(width: 3),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: widget.iconSize / 1.15,
            color: widget.iconTheme?.iconUnselectedColor ?? theme.iconTheme.color,
          )
        ],
      ),
    );
  }
}
