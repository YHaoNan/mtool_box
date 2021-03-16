import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mtoolbox/bpm.dart';
import 'package:mtoolbox/keyscale.dart';
import 'package:mtoolbox/random_generator.dart';
import 'package:mtoolbox/reverb_calculator.dart';

void main() {
  runApp(MyApp());
}


class MainGrid extends StatelessWidget{
  final list = [{'icon': Icons.list,'title': '调式'},{'icon': Icons.favorite,'title': 'bpm'},{'icon': Icons.room,'title':'混响计算'}
  ,{'icon':Icons.confirmation_number,"title":"随机数"}];
  final routes = {'调式': KeyScale(), 'bpm': Bpm(),'混响计算':ReverbCalculator(),'随机数': RandomGenerator()};

  _onGridItemTap(BuildContext context, String title){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (c)=>routes[title])
    );
  }

  Widget _createItem(IconData icon, String title,BuildContext context){
    return InkWell(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          Text(title),
        ],
      ),
      onTap: ()=>_onGridItemTap(context,title),
    );

  }


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.count(
          crossAxisCount: 4,
          padding: EdgeInsets.symmetric(vertical: 0),
          children: list.map((e) => _createItem(e['icon'], e['title'], context))
              .toList()
      ),
    );
  }
}

class MyApp extends StatelessWidget {
 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MToolBox',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('MToolBox'),
        ),
        body: Column(
          children: [
            MainGrid()
          ],
        ),
      )
    );
  }
}
