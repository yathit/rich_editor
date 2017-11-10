import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Extensions {

  static bool isEmpty(TextSpan textSpan) {
    assert(textSpan.debugAssertIsValid());
    bool isEmpty = true;
    textSpan.visitTextSpan((TextSpan span) {
      if (span.text.isNotEmpty) {
        isEmpty = false;
        return false;
      } else
        return true;
    });
    return isEmpty;
  }

  static bool isNotEmpty(TextSpan textSpan) => !isEmpty(textSpan);

  /// Return the length of the text contained in this [TextSpan] tree.
  static int length(TextSpan textSpan) {
    assert(textSpan.debugAssertIsValid());
    int length = 0;
    textSpan.visitTextSpan((TextSpan span) {
      length += span.text.length;
      return true;
    });
    return length;
  }

  /// Return the offset of this child in plain text or -1 if the children list
  /// is null or this [TextSpan] is not contained in this children list.
  static int getOffsetInParent(TextSpan parent, TextSpan span) {
    assert(parent.debugAssertIsValid());
    if (parent.children == null || !parent.children.contains(span)) return -1;

    int length = 0;
    parent.visitTextSpan((TextSpan sibling) {
      if (span != sibling) {
        length += sibling.text.length;
        return true;
      } else
        return false;
    });
    return length;
  }

  /// Creates a copy of this [TextSpan] but with the given fields replaced with the new values.
  static TextSpan copyWith(
      {@required TextSpan base,
      TextStyle style,
      String text,
      List<TextSpan> children,
      GestureRecognizer recognizer}) {
    return new TextSpan(
        style: style ?? base.style,
        text: text ?? base.text,
        children: children ?? base.children,
        recognizer: recognizer ?? base.recognizer);
  }

  /// Returns a new text style that matches this text style but with some values
  /// replaced by the non-null parameters of the given text style. This merge
  /// take into consideration the [TextDecoration] values and combines them. If
  /// the given text style is null, simply returns this text style.
  static TextStyle deepMerge(TextStyle base, TextStyle other) {
    if (other == null) return base;
    assert(other.inherit);

    TextDecoration decoration;
    if (base.decoration == null)
      decoration = other.decoration;
    else if (other.decoration == null)
      decoration = base.decoration;
    else {
      if (other.decoration == TextDecoration.none) {
        decoration = TextDecoration.none;
      } else if (getDecorationList(base.decoration).length >
          getDecorationList(other.decoration).length) {
        decoration = other.decoration;
      } else {
        decoration = new TextDecoration.combine(
            <TextDecoration>[base.decoration, other.decoration]);
      }
    }

    return new TextStyle(
      color: other.color ?? base.color,
      fontFamily: other.fontFamily ?? base.fontFamily,
      fontSize: other.fontSize ?? base.fontSize,
      fontWeight: other.fontWeight ?? base.fontWeight,
      fontStyle: other.fontStyle ?? base.fontStyle,
      letterSpacing: other.letterSpacing ?? base.letterSpacing,
      wordSpacing: other.wordSpacing ?? base.wordSpacing,
      textBaseline: other.textBaseline ?? base.textBaseline,
      height: other.height ?? base.height,
      decoration: decoration,
      decorationColor: other.decorationColor ?? base.decorationColor,
      decorationStyle: other.decorationStyle ?? base.decorationStyle,
    );
  }

  /// Return a List with all the decoration contained by the [TextDecoration].
  static List<TextDecoration> getDecorationList(TextDecoration decoration) {
    final List<TextDecoration> decorationList = <TextDecoration>[];

    if (decoration == null) {} else if (decoration == TextDecoration.none) {
      decorationList.add(TextDecoration.none);
    } else {
      if (decoration.contains(TextDecoration.underline))
        decorationList.add(TextDecoration.underline);
      if (decoration.contains(TextDecoration.overline))
        decorationList.add(TextDecoration.overline);
      if (decoration.contains(TextDecoration.lineThrough))
        decorationList.add(TextDecoration.lineThrough);
    }

    return decorationList;
  }

  /// Return a new TextStyle with the differences between the base style and the
  /// provided style.
  static TextStyle getDifferenceStyle(TextStyle base, TextStyle style) {
    return new TextStyle(
        color: base.color != style.color ? style.color : null,
        fontFamily:
            base.fontFamily != style.fontFamily ? style.fontFamily : null,
        fontSize: base.fontSize != style.fontSize ? style.fontSize : null,
        fontWeight:
            base.fontWeight != style.fontWeight ? style.fontWeight : null,
        fontStyle: base.fontStyle != style.fontStyle ? style.fontStyle : null,
        letterSpacing: base.letterSpacing != style.letterSpacing
            ? style.letterSpacing
            : null,
        wordSpacing:
            base.wordSpacing != style.wordSpacing ? style.wordSpacing : null,
        textBaseline:
            base.textBaseline != style.textBaseline ? style.textBaseline : null,
        height: base.height != style.height ? style.height : null,
        decoration:
            base.decoration != style.decoration ? style.decoration : null,
        decorationColor: base.decorationColor != style.decorationColor
            ? style.decorationColor
            : null,
        decorationStyle: base.decorationStyle != style.decorationStyle
            ? style.decorationStyle
            : null);
  }

  static TextStyle emptyStyle = const TextStyle();
}
