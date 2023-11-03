import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final double max;
  const ExpandableText({Key? key, required this.text, required this.max})
      : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  TextPainter? textPainter;
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return widget.text.length>100? isOpen
        ? SizedBox(
        child: Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(children: [
                TextSpan(
                    text: widget.text,style: TextStyle(color: Colors.black)),
                WidgetSpan(
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            isOpen = !isOpen;
                          });
                        },
                        child: Text(
                          "Less more",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent),
                        )),)
              ]),
            )))
        : Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        textAlign: TextAlign.start,
        maxLines: 2,
        text: TextSpan(children: [
          TextSpan(
              text: widget.text.substring(
                  0,
                  int.parse(
                      "${(widget.text.length * widget.max).toInt()}")) +
                  "...",style: TextStyle(color: Colors.black)),
          WidgetSpan(
              child: InkWell(
                  mouseCursor: SystemMouseCursors.click,
                  onTap: () {
                    setState(() {
                      isOpen = !isOpen;
                    });
                  },
                  child: Text(
                    " see more",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade400),
                  )),)
        ]),
      ),
    ):Text(widget.text);
  }
}