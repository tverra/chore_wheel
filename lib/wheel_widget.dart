import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';
import 'package:winwheel/winwheel.dart';

import 'list_item.dart';

class ChoreWheelWidget extends StatefulWidget {
  final List<Segment> segments;
  final List<ListItem> listItems;

  ChoreWheelWidget(this.segments, this.listItems);

  _ChoreWheelWidgetState createState() => _ChoreWheelWidgetState();
}

class _ChoreWheelWidgetState extends State<ChoreWheelWidget> {
  static WinwheelController ctrl;
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());

    return Container(
      color: Theme.of(context).primaryColor.withAlpha(180),
      child: Column(
        children: <Widget>[
          Container(
            height: 24,
            color: Theme.of(context).primaryColor,
          ),
          Container(
            child: Center(
                child: Icon(
              Icons.arrow_downward,
              size: 40,
            )),
          ),
          WheelWidget(
            ctrl,
            widget.segments,
            callbackFinished: (int segment) {
              if (widget.segments.length == 0) return;

              setState(() {
                isPlaying = false;
              });

              _showResult(segment);
            },
            callBackBefore: () {
              if (widget.segments.length == 0) return;

              setState(() {
                isPlaying = true;
              });
            },
            setController: ((handler) {
              ctrl = handler;
              return null;
            }),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).primaryColor.withAlpha(0),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: IconButton(
              iconSize: 100,
              color: Theme.of(context).primaryColor,
              icon: Icon(
                isPlaying
                    ? Icons.pause_circle_outline
                    : Icons.play_circle_outline,
              ),
              onPressed: () {
                if (isPlaying) {
                  ctrl.pause();

                  setState(() {
                    isPlaying = false;
                  });
                } else {
                  ctrl.play();

                  setState(() {
                    isPlaying = true;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showResult(int segment) {
    final Segment currentSegment = widget.segments[segment - 1];
    final ListItem currentListItem = widget.listItems[segment - 1];
    final TinyColor color = TinyColor(currentSegment.fillStyle).lighten(20);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text('Gratulerer!'),
          content: new Text(currentListItem.text),
          backgroundColor: color.color,
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                'Lukk',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class WheelWidget extends StatelessWidget {
  final Function callbackFinished;
  final Function callBackBefore;
  final Function setController;
  final List<Segment> segments;
  final WinwheelController controller;

  WheelWidget(this.controller, this.segments,
      {this.callbackFinished, this.callBackBefore, this.setController});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width - 20,
      child: Center(
        child: Winwheel(
          handleCallback: ((handler) {
            setController(handler);
            return null;
          }),
          controller: controller,
          outerRadius: MediaQuery.of(context).size.width / 2.1,
          innerRadius: 15,
          strokeStyle: Colors.white,
          textFontSize: 16.0,
          textFillStyle: Colors.red,
          textFontWeight: FontWeight.bold,
          textAlignment: WinwheelTextAlignment.center,
          textOrientation: WinwheelTextOrientation.horizontal,
          wheelImage: 'assets/planes.png',
          drawMode: WinwheelDrawMode.code,
          drawText: true,
          imageOverlay: false,
          textMargin: 0,
          pointerAngle: 0,
          pointerGuide: PointerGuide(
            display: true,
          ),
          segments: segments,
          pins: Pin(
            // visible: true,
            number: 16,
            margin: 6,
            // outerRadius: 5,
            fillStyle: Colors.yellow,
          ),
          animation: WinwheelAnimation(
            type: WinwheelAnimationType.spinToStop,
            curve: Curves.easeOutExpo,
            spins: 8,
            duration: const Duration(
              seconds: 10,
            ),
            callbackFinished: callbackFinished,
            callbackBefore: callBackBefore,
          ),
        ),
      ),
    );
  }
}
