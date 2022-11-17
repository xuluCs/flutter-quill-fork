// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';

class QuillPopupTheme {
  const QuillPopupTheme({
    this.iconButtonColor,
    this.buttonColor,
    this.backgroundColor,
    this.itemHoverColor,
    this.itemBorderRadius,
    this.hoverColor,
    this.elevation = 4,
  });

  /// Color for icon button, if [iconButtonColor] is null [buttonColor] will be used
  final Color? iconButtonColor;

  /// Color for button content
  final Color? buttonColor;

  /// Background color of popup
  final Color? backgroundColor;

  /// color of item(s) popup hovered
  final Color? itemHoverColor;

  /// border of hovered item default is 0
  final double? itemBorderRadius;

  /// color of popup button hovered
  final Color? hoverColor;

  /// popup shadow elevation
  final double elevation;
}
