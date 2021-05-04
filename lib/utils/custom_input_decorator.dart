import 'package:flutter/material.dart';

class CustomInputDecorator {
  static InputDecoration getStandardInputDecoration(BuildContext context, [bool invert = false]) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(width: 2, color: !invert ? Theme.of(context).primaryColor : Theme.of(context).scaffoldBackgroundColor),
    );
    final style = TextStyle(
      color: Theme.of(context).primaryColor,
    );
    return InputDecoration(
      border: border,
      focusedBorder: border.copyWith(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 3)),
      disabledBorder: border.copyWith(borderSide: BorderSide(color: Colors.grey, width: 3)),
      enabledBorder: border,
      errorBorder: border.copyWith(borderSide: BorderSide(color: Colors.red, width: 3)),
      focusedErrorBorder: border.copyWith(borderSide: BorderSide(color: Colors.red, width: 3)),
      fillColor: !invert ? Theme.of(context).primaryColor.withOpacity(0.1) : Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
      filled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      counterStyle: style,
      suffixStyle: style,
      errorStyle: style.copyWith(fontWeight: FontWeight.bold),
      helperStyle: style,
      hintStyle: style,
      labelStyle: style.copyWith(fontWeight: FontWeight.bold),
      prefixStyle: style,
    );
  }
}
