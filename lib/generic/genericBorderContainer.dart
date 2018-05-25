import 'package:flutter/material.dart';

class GenericBorderContainer {
  static Widget buildGenericBorderedElement(Widget child) {
    return new Container(
        decoration: new BoxDecoration(
          border: new Border(
              bottom: new BorderSide(
                  color: Color.fromRGBO(150, 150, 150, 1.0),
                  width: 2.0)),
        ),
        child: child
    );
  }

  static Widget buildGenericBlurredLine() {
    return new Container(
        height: 1.0,
        decoration: new BoxDecoration(
          boxShadow: [
            new BoxShadow(
              color: Colors.black87,
              blurRadius: 5.0,
            ),
          ],
        )
    );
  }
}