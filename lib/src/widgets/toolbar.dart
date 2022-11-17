// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';

import '../models/documents/attribute.dart';
import '../models/themes/quill_custom_button.dart';
import '../models/themes/quill_dialog_theme.dart';
import '../models/themes/quill_icon_theme.dart';
import 'controller.dart';
import 'embeds.dart';
import 'toolbar/arrow_indicated_button_list.dart';
import 'toolbar/color_button.dart';
import 'toolbar/history_button.dart';
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
export 'toolbar/select_alignment_button.dart';
export 'toolbar/toggle_check_list_button.dart';
export 'toolbar/toggle_style_button.dart';

// The default size of the icon of a button.
const double kDefaultIconSize = 18;

// The factor of how much larger the button is in relation to the icon.
const double kIconButtonFactor = 1.77;

class QuillToolbar extends StatelessWidget implements PreferredSizeWidget {
  const QuillToolbar({
    required this.children,
    this.toolbarHeight = 36,
    this.toolbarIconAlignment = WrapAlignment.center,
    this.toolbarSectionSpacing = 4,
    this.multiRowsDisplay = true,
    this.color,
    this.customButtons = const [],
    this.locale,
    VoidCallback? afterButtonPressed,
    Key? key,
  }) : super(key: key);

  factory QuillToolbar.basic({
    required QuillController controller,
    double toolbarIconSize = kDefaultIconSize,
    double toolbarSectionSpacing = 4,
    WrapAlignment toolbarIconAlignment = WrapAlignment.center,
    bool showDividers = true,
    bool showFontFamily = true,
    bool showFontSize = true,
    bool showBoldButton = true,
    bool showItalicButton = true,
    bool showSmallButton = false,
    bool showUnderLineButton = true,
    bool showStrikeThrough = true,
    bool showInlineCode = true,
    bool showColorButton = true,
    bool showBackgroundColorButton = true,
    bool showClearFormat = true,
    bool showAlignmentButtons = false,
    bool showLeftAlignment = true,
    bool showCenterAlignment = true,
    bool showRightAlignment = true,
    bool showJustifyAlignment = true,
    bool showHeaderStyle = true,
    bool showListNumbers = true,
    bool showListBullets = true,
    bool showListCheck = true,
    bool showCodeBlock = true,
    bool showQuote = true,
    bool showIndent = true,
    bool showLink = true,
    bool showUndo = true,
    bool showRedo = true,
    bool multiRowsDisplay = true,
    bool showDirection = false,
    bool showSearchButton = true,
    List<QuillCustomButton> customButtons = const [],

    ///Map of font sizes in string
    Map<String, String>? fontSizeValues,

    ///Map of font families in string
    Map<String, String>? fontFamilyValues,

    /// Toolbar items to display for controls of embed blocks
    List<EmbedButtonBuilder>? embedButtons,

    ///The theme to use for the icons in the toolbar, uses type [QuillIconTheme]
    QuillIconTheme? iconTheme,

    ///The theme to use for the theming of the [LinkDialog()],
    ///shown when embedding an image, for example
    QuillDialogTheme? dialogTheme,

    /// Callback to be called after any button on the toolbar is pressed.
    /// Is called after whatever logic the button performs has run.
    VoidCallback? afterButtonPressed,

    /// The locale to use for the editor toolbar, defaults to system locale
    /// More at https://github.com/singerdmx/flutter-quill#translation
    Locale? locale,
    Key? key,
  }) {
    // final isButtonGroupShown = [
    //   showFontFamily ||
    //       showFontSize ||
    //       showBoldButton ||
    //       showItalicButton ||
    //       showSmallButton ||
    //       showUnderLineButton ||
    //       showStrikeThrough ||
    //       showInlineCode ||
    //       showColorButton ||
    //       showBackgroundColorButton ||
    //       showClearFormat ||
    //       embedButtons?.isNotEmpty == true,
    //   showAlignmentButtons || showDirection,
    //   showLeftAlignment,
    //   showCenterAlignment,
    //   showRightAlignment,
    //   showJustifyAlignment,
    //   showHeaderStyle,
    //   showListNumbers || showListBullets || showListCheck || showCodeBlock,
    //   showQuote || showIndent,
    //   showLink || showSearchButton
    // ];

    //default font size values
    // final fontSizes = fontSizeValues ?? {'Small'.i18n: 'small', 'Large'.i18n: 'large', 'Huge'.i18n: 'huge', 'Clear'.i18n: '0'};

    //default header values
    final headerValues = {
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

    return QuillToolbar(
      key: key,
      toolbarHeight: toolbarIconSize * 2,
      toolbarSectionSpacing: toolbarSectionSpacing,
      toolbarIconAlignment: toolbarIconAlignment,
      multiRowsDisplay: multiRowsDisplay,
      customButtons: customButtons,
      locale: locale,
      afterButtonPressed: afterButtonPressed,
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
        if (showHeaderStyle)
          QuillHeaderStyleButton(
            iconTheme: iconTheme,
            iconSize: toolbarIconSize,
            controller: controller,
            items: (current) => [
              for (MapEntry<String, Attribute> header in headerValues.entries)
                PopupMenuItem<Attribute>(
                  key: ValueKey(header.key),
                  padding: EdgeInsets.zero,
                  value: header.value,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      header.key.toString(),
                      style: TextStyle(
                        fontSize: toolbarIconSize / 1.15,
                        color: header.key == current ? Colors.blue.shade300 : null,
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
            iconTheme: iconTheme,
            iconSize: toolbarIconSize,
            controller: controller,
            items: (current) => [
              for (MapEntry<IconData, Attribute> align in alignValues.entries)
                PopupMenuItem<Attribute>(
                  key: ValueKey(align.key),
                  value: align.value,
                  padding: EdgeInsets.zero,
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(4),
                    padding: const EdgeInsets.all(8),
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
        // if (showAlignmentButtons)
        //   SelectAlignmentButton(
        //     controller: controller,
        //     iconSize: toolbarIconSize,
        //     iconTheme: iconTheme,
        //     showLeftAlignment: showLeftAlignment,
        //     showCenterAlignment: showCenterAlignment,
        //     showRightAlignment: showRightAlignment,
        //     showJustifyAlignment: showJustifyAlignment,
        //     afterButtonPressed: afterButtonPressed,
        //   ),
        if (showListNumbers)
          ToggleStyleButton(
            attribute: Attribute.ol,
            controller: controller,
            icon: Icons.format_list_numbered,
            iconSize: toolbarIconSize,
            iconTheme: iconTheme,
            afterButtonPressed: afterButtonPressed,
          ),
        if (showListBullets)
          ToggleStyleButton(
            attribute: Attribute.ul,
            controller: controller,
            icon: Icons.format_list_bulleted,
            iconSize: toolbarIconSize,
            iconTheme: iconTheme,
            afterButtonPressed: afterButtonPressed,
          ),
        if (showListCheck)
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

        // if (showStrikeThrough)
        //   ToggleStyleButton(
        //     attribute: Attribute.strikeThrough,
        //     icon: Icons.format_strikethrough,
        //     iconSize: toolbarIconSize,
        //     controller: controller,
        //     iconTheme: iconTheme,
        //     afterButtonPressed: afterButtonPressed,
        //   ),
        // if (showInlineCode)
        //   ToggleStyleButton(
        //     attribute: Attribute.inlineCode,
        //     icon: Icons.code,
        //     iconSize: toolbarIconSize,
        //     controller: controller,
        //     iconTheme: iconTheme,
        //     afterButtonPressed: afterButtonPressed,
        //   ),

        // if (showSmallButton)
        //   ToggleStyleButton(
        //     attribute: Attribute.small,
        //     icon: Icons.format_size,
        //     iconSize: toolbarIconSize,
        //     controller: controller,
        //     iconTheme: iconTheme,
        //     afterButtonPressed: afterButtonPressed,
        //   ),

        // if (showFontSize)
        //   QuillFontSizeButton(
        //     iconTheme: iconTheme,
        //     iconSize: toolbarIconSize,
        //     attribute: Attribute.size,
        //     controller: controller,
        //     items: (current) => [
        //       for (MapEntry<String, String> fontSize in fontSizes.entries)
        //         PopupMenuItem<String>(
        //           key: ValueKey(fontSize.key),
        //           value: fontSize.value,
        //           child: Container(
        //             padding: const EdgeInsets.all(8),
        //             color: fontSize.key == current ? Colors.blue.shade300 : null,
        //             child: Text(
        //               fontSize.key.toString(),
        //             ),
        //           ),
        //         ),
        //     ],
        //     onSelected: (newSize) {
        //       controller.formatSelection(Attribute.fromKeyValue('size', newSize == '0' ? null : getFontSize(newSize)));
        //     },
        //     rawItemsMap: fontSizes,
        //     afterButtonPressed: afterButtonPressed,
        //   ),
        //   if (showIndent)
        //   IndentButton(
        //     icon: Icons.format_indent_increase,
        //     iconSize: toolbarIconSize,
        //     controller: controller,
        //     isIncrease: true,
        //     iconTheme: iconTheme,
        //     afterButtonPressed: afterButtonPressed,
        //   ),
        // if (showIndent)
        //   IndentButton(
        //     icon: Icons.format_indent_decrease,
        //     iconSize: toolbarIconSize,
        //     controller: controller,
        //     isIncrease: false,
        //     iconTheme: iconTheme,
        //     afterButtonPressed: afterButtonPressed,
        //   ),
        // if (showLink)
        //   LinkStyleButton(
        //     controller: controller,
        //     iconSize: toolbarIconSize,
        //     iconTheme: iconTheme,
        //     dialogTheme: dialogTheme,
        //     afterButtonPressed: afterButtonPressed,
        //   ),
        // if (showClearFormat)
        //   ClearFormatButton(
        //     icon: Icons.format_clear,
        //     iconSize: toolbarIconSize,
        //     controller: controller,
        //     iconTheme: iconTheme,
        //     afterButtonPressed: afterButtonPressed,
        //   ),
        // if (embedButtons != null)
        //   for (final builder in embedButtons) builder(controller, toolbarIconSize, iconTheme, dialogTheme),
        // if (showDividers &&
        //     isButtonGroupShown[0] &&
        //     (isButtonGroupShown[1] || isButtonGroupShown[2] || isButtonGroupShown[3] || isButtonGroupShown[4] || isButtonGroupShown[5]))
        //   VerticalDivider(
        //     indent: 12,
        //     endIndent: 12,
        //     color: Colors.grey.shade400,
        //   ),
        // if (showDirection)
        //   ToggleStyleButton(
        //     attribute: Attribute.rtl,
        //     controller: controller,
        //     icon: Icons.format_textdirection_r_to_l,
        //     iconSize: toolbarIconSize,
        //     iconTheme: iconTheme,
        //     afterButtonPressed: afterButtonPressed,
        //   ),
        // if (showDividers && isButtonGroupShown[1] && (isButtonGroupShown[2] || isButtonGroupShown[3] || isButtonGroupShown[4] || isButtonGroupShown[5]))
        //   VerticalDivider(
        //     indent: 12,
        //     endIndent: 12,
        //     color: Colors.grey.shade400,
        //   ),
        // if (showDividers && showHeaderStyle && isButtonGroupShown[2] && (isButtonGroupShown[3] || isButtonGroupShown[4] || isButtonGroupShown[5]))
        //   VerticalDivider(
        //     indent: 12,
        //     endIndent: 12,
        //     color: Colors.grey.shade400,
        //   ),
        // if (showCodeBlock)
        //   ToggleStyleButton(
        //     attribute: Attribute.codeBlock,
        //     controller: controller,
        //     icon: Icons.code,
        //     iconSize: toolbarIconSize,
        //     iconTheme: iconTheme,
        //     afterButtonPressed: afterButtonPressed,
        //   ),
        // if (showDividers && isButtonGroupShown[3] && (isButtonGroupShown[4] || isButtonGroupShown[5]))
        //   VerticalDivider(
        //     indent: 12,
        //     endIndent: 12,
        //     color: Colors.grey.shade400,
        //   ),
        // if (showQuote)
        //   ToggleStyleButton(
        //     attribute: Attribute.blockQuote,
        //     controller: controller,
        //     icon: Icons.format_quote,
        //     iconSize: toolbarIconSize,
        //     iconTheme: iconTheme,
        //     afterButtonPressed: afterButtonPressed,
        //   ),
        // if (showDividers && isButtonGroupShown[4] && isButtonGroupShown[5])
        //   VerticalDivider(
        //     indent: 12,
        //     endIndent: 12,
        //     color: Colors.grey.shade400,
        //   ),
        // if (customButtons.isNotEmpty)
        //   if (showDividers)
        //     VerticalDivider(
        //       indent: 12,
        //       endIndent: 12,
        //       color: Colors.grey.shade400,
        //     ),
        // for (var customButton in customButtons)
        //   QuillIconButton(
        //     highlightElevation: 0,
        //     hoverElevation: 0,
        //     size: toolbarIconSize * kIconButtonFactor,
        //     icon: Icon(customButton.icon, size: toolbarIconSize),
        //     borderRadius: iconTheme?.borderRadius ?? 2,
        //     onPressed: customButton.onTap,
        //     afterPressed: afterButtonPressed,
        //   ),
      ],
    );
  }

  final List<Widget> children;
  final double toolbarHeight;
  final double toolbarSectionSpacing;
  final WrapAlignment toolbarIconAlignment;
  final bool multiRowsDisplay;

  /// The color of the toolbar.
  ///
  /// Defaults to [ThemeData.canvasColor] of the current [Theme] if no color
  /// is given.
  final Color? color;

  /// The locale to use for the editor toolbar, defaults to system locale
  /// More https://github.com/singerdmx/flutter-quill#translation
  final Locale? locale;

  /// List of custom buttons
  final List<QuillCustomButton> customButtons;

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);

  @override
  Widget build(BuildContext context) {
    return I18n(
      initialLocale: locale,
      child: multiRowsDisplay
          ? Wrap(
              alignment: toolbarIconAlignment,
              runSpacing: 4,
              spacing: toolbarSectionSpacing,
              children: children,
            )
          : Container(
              constraints: BoxConstraints.tightFor(height: preferredSize.height),
              color: color ?? Theme.of(context).canvasColor,
              child: ArrowIndicatedButtonList(buttons: children),
            ),
    );
  }
}
