import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RotaryTable extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RotaryTableState();
}

class RotaryTableState extends State<RotaryTable>
    with SingleTickerProviderStateMixin {
  AnimationController _animController;
  Animation _curved;

  double offset;
  bool first = true;

  void _randomOffset() {
    setState(() {
      offset = Random().nextDouble();
    });
  }

  @override
  void initState() {
    _randomOffset();
    _animController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 2),
        reverseDuration: Duration(seconds: 0));
    _curved =
        new CurvedAnimation(parent: _animController, curve: Curves.bounceOut);
    super.initState();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Widget _rotateBar() {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 10.0 + this.offset).animate(_curved),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: 5,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
            ),
            flex: 1,
          ),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
          ),
          Expanded(
            child: Container(
              width: 5,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
            ),
            flex: 1,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          height: 200,
          child: InkWell(
            child: AspectRatio(
              aspectRatio: 1,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(360))),
                color: Colors.white,
                child:
                    Container(padding: EdgeInsets.all(20), child: _rotateBar()),
              ),
            ),
            onTap: () {
              _randomOffset();
              if (!first) _animController.reverse();
              _animController.forward();
              first = false;
              print("offset: $offset");
            },
          )),
    );
  }
}
