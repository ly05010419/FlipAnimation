import 'package:flutter/material.dart';
import 'dart:math' as math;

class FlipView extends StatefulWidget {
  AnimationController controller;
  Animation animation;
  Animation delayedAnimation;

  @override
  _FlipViewState createState() => _FlipViewState();

  animationForward() {
    controller.reset();
    controller.forward();
  }
}

class _FlipViewState extends State<FlipView>
    with SingleTickerProviderStateMixin {
  int nummer = 10;
  int backgroundNummer;

  @override
  void initState() {
    super.initState();

    backgroundNummer = nummer - 1;

    widget.controller = new AnimationController(
        duration: Duration(milliseconds: 500), vsync: this);
    widget.animation = Tween(begin: 0.0, end: math.pi / 2).animate(
        CurvedAnimation(
            parent: widget.controller,
            curve: Interval(0.0, 0.5, curve: Curves.easeIn)));

    widget.delayedAnimation = Tween(begin: -math.pi / 2, end: 0.0).animate(
        CurvedAnimation(
            parent: widget.controller,
            curve: Interval(0.5, 1.0, curve: Curves.easeIn)))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.controller.reset();
          nummer--;
          backgroundNummer = nummer - 1;
          if (backgroundNummer < 0) backgroundNummer = 10;
          if (nummer < 0) {
            nummer = 10;
            backgroundNummer = nummer - 1;
          }else{
            widget.controller.reset();
            widget.controller.forward();
          }
          setState(() {});
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        height: 310,
        child: AnimatedBuilder(
          animation: widget.animation,
          builder: (context, child) {
            return Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      child: new Align(
                        alignment: Alignment.topCenter,
                        heightFactor: 0.5,
                        widthFactor: 1.0,
                        child: createCard(backgroundNummer),
                      ),
                    ),
                    Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.002)
                        ..rotateX(widget.animation.value),
                      alignment: Alignment.bottomCenter,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        child: new Align(
                          alignment: Alignment.topCenter,
                          heightFactor: 0.5,
                          widthFactor: 1.0,
                          child: createCard(nummer),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      child: new Align(
                        alignment: Alignment.bottomCenter,
                        heightFactor: 0.5,
                        widthFactor: 1.0,
                        child: createCard(nummer),
                      ),
                    ),
                    Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.002)
                        ..rotateX(widget.delayedAnimation.value),
                      alignment: Alignment.topCenter,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        child: new Align(
                          alignment: Alignment.bottomCenter,
                          heightFactor: 0.5,
                          widthFactor: 1.0,
                          child: createCard(backgroundNummer),
                        ),
                      ),
                    )
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget createCard(int nummer) {
    return Container(
      height: 250,
      width: 210,
      color: Colors.blue,
      child: Center(
        child: Text(
          "${nummer}",
          maxLines: 1,
          style: nummer >= 10
              ? TextStyle(fontSize: 160, fontWeight: FontWeight.bold)
              : TextStyle(fontSize: 200, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
