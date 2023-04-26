// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import '../models/documents/attribute.dart';
import '../models/documents/style.dart';
import '../utils/platform.dart';
import 'style_widgets/checkbox_point.dart';

class QuillStyles extends InheritedWidget {
  const QuillStyles({
    required this.data,
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  final DefaultStyles data;

  @override
  bool updateShouldNotify(QuillStyles oldWidget) {
    return data != oldWidget.data;
  }

  static DefaultStyles? getStyles(BuildContext context, bool nullOk) {
    final widget = context.dependOnInheritedWidgetOfExactType<QuillStyles>();
    if (widget == null && nullOk) {
      return null;
    }
    assert(widget != null);
    return widget!.data;
  }
}

/// Style theme applied to a block of rich text, including single-line
/// paragraphs.
class DefaultTextBlockStyle {
  DefaultTextBlockStyle(
    this.style, {
    this.verticalSpacing = const Tuple2(0, 0),
    this.lineSpacing = const Tuple2(0, 0),
    this.decoration,
  });

  /// Base text style for a text block.
  final TextStyle style;

  /// Vertical spacing around a text block.
  final Tuple2<double, double> verticalSpacing;

  /// Vertical spacing for individual lines within a text block.
  ///
  final Tuple2<double, double> lineSpacing;

  /// Decoration of a text block.
  ///
  /// Decoration, if present, is painted in the content area, excluding
  /// any [spacing].
  final BoxDecoration? decoration;
}

/// Theme data for inline code.
class InlineCodeStyle {
  InlineCodeStyle({
    required this.style,
    this.header1,
    this.header2,
    this.header3,
    this.header4,
    this.header5,
    this.backgroundColor,
    this.radius,
  });

  /// Base text style for an inline code.
  final TextStyle style;

  /// Style override for inline code in header level 1.
  final TextStyle? header1;

  /// Style override for inline code in headings level 2.
  final TextStyle? header2;

  /// Style override for inline code in headings level 3.
  final TextStyle? header3;

  /// Style override for inline code in headings level 4.
  final TextStyle? header4;

  /// Style override for inline code in headings level 5.
  final TextStyle? header5;

  /// Background color for inline code.
  final Color? backgroundColor;

  /// Radius used when paining the background.
  final Radius? radius;

  /// Returns effective style to use for inline code for the specified
  /// [lineStyle].
  TextStyle styleFor(Style lineStyle) {
    if (lineStyle.containsKey(Attribute.h1.key)) {
      return header1 ?? style;
    }
    if (lineStyle.containsKey(Attribute.h2.key)) {
      return header2 ?? style;
    }
    if (lineStyle.containsKey(Attribute.h3.key)) {
      return header3 ?? style;
    }
    if (lineStyle.containsKey(Attribute.h4.key)) {
      return header4 ?? style;
    }
    if (lineStyle.containsKey(Attribute.h5.key)) {
      return header5 ?? style;
    }
    return style;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! InlineCodeStyle) {
      return false;
    }
    return other.style == style &&
        other.header1 == header1 &&
        other.header2 == header2 &&
        other.header3 == header3 &&
        other.header4 == header4 &&
        other.header5 == header5 &&
        other.backgroundColor == backgroundColor &&
        other.radius == radius;
  }

  @override
  int get hashCode => Object.hash(
        style,
        header1,
        header2,
        header3,
        header4,
        header5,
        backgroundColor,
        radius,
      );
}

class DefaultListBlockStyle extends DefaultTextBlockStyle {
  DefaultListBlockStyle(
    TextStyle style,
    Tuple2<double, double> verticalSpacing,
    Tuple2<double, double> lineSpacing,
    BoxDecoration? decoration,
    this.checkboxUIBuilder,
  ) : super(
          style,
          verticalSpacing: verticalSpacing,
          lineSpacing: lineSpacing,
          decoration: decoration,
        );

  final QuillCheckboxBuilder? checkboxUIBuilder;
}

class DefaultStyles {
  DefaultStyles({
    this.h1,
    this.h2,
    this.h3,
    this.h4,
    this.h5,
    this.paragraph,
    this.bold,
    this.italic,
    this.small,
    this.underline,
    this.strikeThrough,
    this.inlineCode,
    this.link,
    this.color,
    this.placeHolder,
    this.lists,
    this.quote,
    this.code,
    this.indent,
    this.align,
    this.leading,
    this.sizeSmall,
    this.sizeLarge,
    this.sizeHuge,
  });

  final DefaultTextBlockStyle? h1;
  final DefaultTextBlockStyle? h2;
  final DefaultTextBlockStyle? h3;
  final DefaultTextBlockStyle? h4;
  final DefaultTextBlockStyle? h5;
  final DefaultTextBlockStyle? paragraph;
  final TextStyle? bold;
  final TextStyle? italic;
  final TextStyle? small;
  final TextStyle? underline;
  final TextStyle? strikeThrough;

  /// Theme of inline code.
  final InlineCodeStyle? inlineCode;
  final TextStyle? sizeSmall; // 'small'
  final TextStyle? sizeLarge; // 'large'
  final TextStyle? sizeHuge; // 'huge'
  final TextStyle? link;
  final Color? color;
  final DefaultTextBlockStyle? placeHolder;
  final DefaultListBlockStyle? lists;
  final DefaultTextBlockStyle? quote;
  final DefaultTextBlockStyle? code;
  final DefaultTextBlockStyle? indent;
  final DefaultTextBlockStyle? align;
  final DefaultTextBlockStyle? leading;

  static DefaultStyles getInstance(BuildContext context) {
    final themeData = Theme.of(context);
    final defaultTextStyle = DefaultTextStyle.of(context);
    final baseStyle = defaultTextStyle.style.copyWith(
      fontSize: 16,
      height: 1.3,
      decoration: TextDecoration.none,
    );
    const baseSpacing = Tuple2<double, double>(6, 0);
    String fontFamily;
    if (isAppleOS(themeData.platform)) {
      fontFamily = 'Menlo';
    } else {
      fontFamily = 'Roboto Mono';
    }

    final inlineCodeStyle = TextStyle(
      fontSize: 14,
      color: themeData.colorScheme.primary.withOpacity(0.8),
      fontFamily: fontFamily,
    );

    return DefaultStyles(
      h1: DefaultTextBlockStyle(
        defaultTextStyle.style.copyWith(
          fontSize: 96,
          color: defaultTextStyle.style.color,
          fontWeight: FontWeight.w300,
          decoration: TextDecoration.none,
        ),
      ),
      h2: DefaultTextBlockStyle(
        defaultTextStyle.style.copyWith(
          fontSize: 60,
          color: defaultTextStyle.style.color,
          fontWeight: FontWeight.w300,
          decoration: TextDecoration.none,
        ),
      ),
      h3: DefaultTextBlockStyle(
        defaultTextStyle.style.copyWith(
          fontSize: 48,
          color: defaultTextStyle.style.color,
          fontWeight: FontWeight.normal,
          decoration: TextDecoration.none,
        ),
      ),
      h4: DefaultTextBlockStyle(
        defaultTextStyle.style.copyWith(
          fontSize: 34,
          color: defaultTextStyle.style.color,
          fontWeight: FontWeight.normal,
          decoration: TextDecoration.none,
        ),
      ),
      h5: DefaultTextBlockStyle(
        defaultTextStyle.style.copyWith(
          fontSize: 24,
          color: defaultTextStyle.style.color,
          fontWeight: FontWeight.normal,
          decoration: TextDecoration.none,
        ),
      ),
      paragraph: DefaultTextBlockStyle(baseStyle),
      bold: const TextStyle(fontWeight: FontWeight.bold),
      italic: const TextStyle(fontStyle: FontStyle.italic),
      small: const TextStyle(fontSize: 12),
      underline: const TextStyle(decoration: TextDecoration.underline),
      strikeThrough: const TextStyle(decoration: TextDecoration.lineThrough),
      inlineCode: InlineCodeStyle(
        backgroundColor: Colors.grey.shade100,
        radius: const Radius.circular(3),
        style: inlineCodeStyle,
        header1: inlineCodeStyle.copyWith(fontSize: 96),
        header2: inlineCodeStyle.copyWith(fontSize: 60),
        header3: inlineCodeStyle.copyWith(fontSize: 48),
        header4: inlineCodeStyle.copyWith(fontSize: 34),
        header5: inlineCodeStyle.copyWith(fontSize: 24),
      ),
      link: TextStyle(
        color: themeData.colorScheme.secondary,
        decoration: TextDecoration.underline,
      ),
      placeHolder: DefaultTextBlockStyle(
        defaultTextStyle.style.copyWith(
          fontSize: 20,
          height: 1.5,
          color: Colors.grey.withOpacity(0.6),
        ),
      ),
      lists: DefaultListBlockStyle(baseStyle, baseSpacing, const Tuple2(0, 6), null, null),
      quote: DefaultTextBlockStyle(TextStyle(color: baseStyle.color!.withOpacity(0.6)),
          verticalSpacing: baseSpacing,
          lineSpacing: const Tuple2(6, 2),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(width: 4, color: Colors.grey.shade300),
            ),
          )),
      code: DefaultTextBlockStyle(
          TextStyle(
            color: Colors.blue.shade900.withOpacity(0.9),
            fontFamily: fontFamily,
            fontSize: 13,
            height: 1.15,
          ),
          verticalSpacing: baseSpacing,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(2),
          )),
      indent: DefaultTextBlockStyle(
        baseStyle,
        verticalSpacing: baseSpacing,
        lineSpacing: const Tuple2(0, 6),
      ),
      align: DefaultTextBlockStyle(baseStyle),
      leading: DefaultTextBlockStyle(baseStyle),
      sizeSmall: const TextStyle(fontSize: 10),
      sizeLarge: const TextStyle(fontSize: 18),
      sizeHuge: const TextStyle(fontSize: 22),
    );
  }

  DefaultStyles merge(DefaultStyles other) {
    return DefaultStyles(
        h1: other.h1 ?? h1,
        h2: other.h2 ?? h2,
        h3: other.h3 ?? h3,
        h4: other.h4 ?? h4,
        h5: other.h5 ?? h5,
        paragraph: other.paragraph ?? paragraph,
        bold: other.bold ?? bold,
        italic: other.italic ?? italic,
        small: other.small ?? small,
        underline: other.underline ?? underline,
        strikeThrough: other.strikeThrough ?? strikeThrough,
        inlineCode: other.inlineCode ?? inlineCode,
        link: other.link ?? link,
        color: other.color ?? color,
        placeHolder: other.placeHolder ?? placeHolder,
        lists: other.lists ?? lists,
        quote: other.quote ?? quote,
        code: other.code ?? code,
        indent: other.indent ?? indent,
        align: other.align ?? align,
        leading: other.leading ?? leading,
        sizeSmall: other.sizeSmall ?? sizeSmall,
        sizeLarge: other.sizeLarge ?? sizeLarge,
        sizeHuge: other.sizeHuge ?? sizeHuge);
  }
}
