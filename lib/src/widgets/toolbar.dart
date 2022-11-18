// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';

import '../models/documents/attribute.dart';
import '../models/themes/quill_icon_theme.dart';
import '../models/themes/quill_popup_theme.dart';
import 'controller.dart';
import 'embeds.dart';
import 'toolbar/arrow_indicated_button_list.dart';
import 'toolbar/color_button.dart';
import 'toolbar/history_button.dart';
import 'toolbar/indent_button.dart';
import 'toolbar/quill_alignment_button.dart';
import 'toolbar/quill_header_style_button.dart';
import 'toolbar/toggle_check_list_button.dart';
import 'toolbar/toggle_style_button.dart';

export 'toolbar/clear_format_button.dart';
export 'toolbar/color_button.dart';
export 'toolbar/history_button.dart';
export 'toolbar/indent_button.dart';
export 'toolbar/link_style_button.dart';
export 'toolbar/quill_font_size_button.dart';
export 'toolbar/quill_icon_button.dart';
export 'toolbar/toggle_check_list_button.dart';
export 'toolbar/toggle_style_button.dart';

// The default size of the icon of a button.
const double kDefaultIconSize = 18;

// The factor of how much larger the button is in relation to the icon.
const double kIconButtonFactor = 1.77;

class QuillToolbar extends StatelessWidget {
  const QuillToolbar({
    required this.children,
    this.toolbarHeight,
    this.toolbarColor,
    this.locale,
    VoidCallback? afterButtonPressed,
    Key? key,
  }) : super(key: key);

  factory QuillToolbar.basic({
    required QuillController controller,
    double toolbarIconSize = kDefaultIconSize,
    double toolbarHeight = 36,
    Color? toolbarColor,
    bool showUndo = true,
    bool showRedo = true,
    bool showBoldButton = true,
    bool showItalicButton = true,
    bool showUnderLineButton = true,
    bool showStrikeThrough = true,
    bool showColorButton = true,
    bool showBackgroundColorButton = true,
    bool showAlignmentButtons = true,
    bool showIndentButtons = true,
    bool showHeaderButton = true,
    bool showListButton = true,
    bool multiRowsDisplay = true,

    ///Map of font sizes in string
    Map<String, String>? fontSizeValues,

    ///Map of font families in string
    Map<String, String>? fontFamilyValues,

    /// Toolbar items to display for controls of embed blocks
    List<EmbedButtonBuilder>? embedButtons,

    ///The theme to use for the icons in the toolbar, uses type [QuillIconTheme]
    QuillIconTheme? iconTheme,

    ///The theme to use for popup in the toolbar, uses type [QuillPopupTheme]
    QuillPopupTheme? popupTheme,

    /// Callback to be called after any button on the toolbar is pressed.
    /// Is called after whatever logic the button performs has run.
    VoidCallback? afterButtonPressed,

    /// The locale to use for the editor toolbar, defaults to system locale
    /// More at https://github.com/singerdmx/flutter-quill#translation
    Locale? locale,

    /// Background toolbar color
    Key? key,
  }) {
    //default font size values
    // final fontSizes = fontSizeValues ?? {'Small'.i18n: 'small', 'Large'.i18n: 'large', 'Huge'.i18n: 'huge', 'Clear'.i18n: '0'};

    //default header values
    final headerValues = {
      'Heading   ': Attribute.header,
      'Heading 1': Attribute.h1,
      'Heading 2': Attribute.h2,
      'Heading 3': Attribute.h3,
      'Heading 4': Attribute.h4,
      'Heading 5': Attribute.h5,
      'Heading 6': Attribute.h6,
    };

    //default align values
    final alignValues = {
      Icons.format_align_left: Attribute.leftAlignment,
      Icons.format_align_center: Attribute.centerAlignment,
      Icons.format_align_justify: Attribute.justifyAlignment,
      Icons.format_align_right: Attribute.rightAlignment,
    };

    Widget hoverItems({required Widget child}) {
      final hoveredItems = ValueNotifier<Color?>(null);
      return ValueListenableBuilder<Color?>(
        valueListenable: hoveredItems,
        builder: (context, snapShot, _) => MouseRegion(
          onEnter: (_) => hoveredItems.value = popupTheme?.itemHoverColor,
          onExit: (_) => hoveredItems.value = null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(popupTheme?.itemBorderRadius ?? 0),
                color: snapShot,
              ),
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              child: child,
            ),
          ),
        ),
      );
    }

    return QuillToolbar(
      key: key,
      toolbarHeight: toolbarHeight,
      toolbarColor: toolbarColor,
      locale: locale,
      afterButtonPressed: afterButtonPressed,
      children: [
        Theme(
          data: ThemeData(
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: Row(
            children: [
              if (showUndo)
                HistoryButton(
                  icon: Icons.undo_outlined,
                  iconSize: toolbarIconSize,
                  controller: controller,
                  undo: true,
                  iconTheme: iconTheme,
                  afterButtonPressed: afterButtonPressed,
                ),
              if (showRedo)
                HistoryButton(
                  icon: Icons.redo_outlined,
                  iconSize: toolbarIconSize,
                  controller: controller,
                  undo: false,
                  iconTheme: iconTheme,
                  afterButtonPressed: afterButtonPressed,
                ),
              if (showBoldButton)
                ToggleStyleButton(
                  attribute: Attribute.bold,
                  icon: Icons.format_bold,
                  iconSize: toolbarIconSize,
                  controller: controller,
                  iconTheme: iconTheme,
                  afterButtonPressed: afterButtonPressed,
                ),
              if (showItalicButton)
                ToggleStyleButton(
                  attribute: Attribute.italic,
                  icon: Icons.format_italic,
                  iconSize: toolbarIconSize,
                  controller: controller,
                  iconTheme: iconTheme,
                  afterButtonPressed: afterButtonPressed,
                ),
              if (showUnderLineButton)
                ToggleStyleButton(
                  attribute: Attribute.underline,
                  icon: Icons.format_underline,
                  iconSize: toolbarIconSize,
                  controller: controller,
                  iconTheme: iconTheme,
                  afterButtonPressed: afterButtonPressed,
                ),
              if (showStrikeThrough)
                ToggleStyleButton(
                  attribute: Attribute.strikeThrough,
                  icon: Icons.format_strikethrough,
                  iconSize: toolbarIconSize,
                  controller: controller,
                  iconTheme: iconTheme,
                  afterButtonPressed: afterButtonPressed,
                ),
              if (showIndentButtons)
                IndentButton(
                  icon: Icons.format_indent_increase,
                  iconSize: toolbarIconSize,
                  controller: controller,
                  isIncrease: true,
                  iconTheme: iconTheme,
                  afterButtonPressed: afterButtonPressed,
                ),
              if (showIndentButtons)
                IndentButton(
                  icon: Icons.format_indent_decrease,
                  iconSize: toolbarIconSize,
                  controller: controller,
                  isIncrease: false,
                  iconTheme: iconTheme,
                  afterButtonPressed: afterButtonPressed,
                ),
              if (showHeaderButton)
                QuillHeaderStyleButton(
                  popupTheme: popupTheme,
                  iconSize: toolbarIconSize,
                  controller: controller,
                  items: (current) => [
                    for (MapEntry<String, Attribute> header in headerValues.entries)
                      PopupMenuItem<Attribute>(
                        key: ValueKey(header.key),
                        value: header.value,
                        padding: EdgeInsets.zero,
                        child: hoverItems(
                          child: Text(
                            header.key.toString(),
                            style: TextStyle(
                              fontSize: toolbarIconSize / 1.15,
                              color: header.key == current ? Colors.blue : null,
                            ),
                          ),
                        ),
                      ),
                  ],
                  onSelected: (level) {
                    controller.formatSelection(level);
                  },
                  rawItemsMap: headerValues,
                  afterButtonPressed: afterButtonPressed,
                ),
              if (showAlignmentButtons)
                QuillAlignmentButton(
                  popupTheme: popupTheme,
                  iconSize: toolbarIconSize,
                  controller: controller,
                  items: (current) => [
                    for (MapEntry<IconData, Attribute> align in alignValues.entries)
                      PopupMenuItem<Attribute>(
                        key: ValueKey(align.key),
                        value: align.value,
                        padding: EdgeInsets.zero,
                        child: hoverItems(
                          child: Icon(
                            align.key,
                            size: toolbarIconSize,
                            color: align.key == current ? Colors.blue : null,
                          ),
                        ),
                      ),
                  ],
                  onSelected: (level) {
                    if (level == Attribute.leftAlignment) {
                      controller.formatSelection(Attribute.clone(Attribute.align, null));
                    } else {
                      controller.formatSelection(level);
                    }
                  },
                  rawItemsMap: alignValues,
                  afterButtonPressed: afterButtonPressed,
                ),
              if (showListButton)
                ToggleStyleButton(
                  attribute: Attribute.ol,
                  controller: controller,
                  icon: Icons.format_list_numbered,
                  iconSize: toolbarIconSize,
                  iconTheme: iconTheme,
                  afterButtonPressed: afterButtonPressed,
                ),
              if (showListButton)
                ToggleStyleButton(
                  attribute: Attribute.ul,
                  controller: controller,
                  icon: Icons.format_list_bulleted,
                  iconSize: toolbarIconSize,
                  iconTheme: iconTheme,
                  afterButtonPressed: afterButtonPressed,
                ),
              if (showListButton)
                ToggleCheckListButton(
                  attribute: Attribute.unchecked,
                  controller: controller,
                  icon: Icons.check_box,
                  iconSize: toolbarIconSize,
                  iconTheme: iconTheme,
                  afterButtonPressed: afterButtonPressed,
                ),
              if (showColorButton)
                ColorButton(
                  icon: Icons.color_lens,
                  iconSize: toolbarIconSize,
                  controller: controller,
                  background: false,
                  iconTheme: iconTheme,
                  afterButtonPressed: afterButtonPressed,
                ),
              if (showBackgroundColorButton)
                ColorButton(
                  icon: Icons.format_color_fill,
                  iconSize: toolbarIconSize,
                  controller: controller,
                  background: true,
                  iconTheme: iconTheme,
                  afterButtonPressed: afterButtonPressed,
                ),
            ],
          ),
        ),
      ],
    );
  }

  final List<Widget> children;
  final double? toolbarHeight;

  /// The color of the toolbar.
  ///
  /// Defaults to [ThemeData.canvasColor] of the current [Theme] if no color
  /// is given.
  final Color? toolbarColor;

  /// The locale to use for the editor toolbar, defaults to system locale
  /// More https://github.com/singerdmx/flutter-quill#translation
  final Locale? locale;

  @override
  Widget build(BuildContext context) {
    return I18n(
      initialLocale: locale,
      child: Container(
        height: toolbarHeight,
        color: toolbarColor ?? Theme.of(context).canvasColor,
        child: ArrowIndicatedButtonList(buttons: children),
      ),
    );
  }
}
