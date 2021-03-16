import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReverbPageWidget extends InheritedWidget{
  final ReverbCalculatorState model;
  ReverbPageWidget({Key key,@required this.model,@required Widget child}) : super(key: key,child: child);

  @override
  bool updateShouldNotify(covariant ReverbPageWidget oldWidget) {
    return oldWidget.model == this.model;
  }

  static ReverbPageWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType(aspect: ReverbPageWidget);
  }
}
class ReverbPage extends StatefulWidget{
  num decayVaildLow = 0;
  num decayVaildHigh = 0;
  num delayVaildLow = 0;
  num delayVaildHigh = 0;
  String name = "";

  ReverbPageState state;

  ReverbPage(this.name,this.decayVaildLow,this.decayVaildHigh,this.delayVaildLow,this.delayVaildHigh);

  @override
  State<StatefulWidget> createState() {
    state = ReverbPageState(this.name,this.decayVaildLow,this.decayVaildHigh,this.delayVaildLow,this.delayVaildHigh);
    return state;
  }
}


class ReverbPageState extends State<ReverbPage>{
  num decayVaildLow = 0;
  num decayVaildHigh = 0;
  num delayVaildLow = 0;
  num delayVaildHigh = 0;
  String name = "";

  ReverbPageState(this.name,this.decayVaildLow,this.decayVaildHigh,this.delayVaildLow,this.delayVaildHigh);

  int curPower=0;

  Widget _paramLine(String key,String value,{bool isTitle=false,bool isNotVaild = false}){
    TextStyle titleStyle = TextStyle(color: Colors.grey,fontWeight: FontWeight.bold);
    TextStyle notVaildateStyle = TextStyle(color: Colors.redAccent);
    TextStyle style;
    if(isNotVaild){
      style = notVaildateStyle;
    }else if(isTitle){
      style = titleStyle;
    }
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(child: Text(key,style: style,textAlign: TextAlign.center,)),
          Expanded(child: Text(value,style: style,textAlign: TextAlign.center,))
        ],
      )
    );
  }

  void _resetPower(int curPowear) {
    setState(() {
      this.curPower = curPowear;
    });
  }

  Widget _buttonLine(){
    return Container(
      height: 60,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(onPressed: (){_resetPower(curPower-1);}, child: Text("<")),
          TextButton(onPressed: (){_resetPower(curPower+1);}, child: Text(">")),
        ],
      ),
    );
  }

  num log2(num x){
    return log(x)/log(2);
  }
  @override
  Widget build(BuildContext context) {
    ReverbCalculatorState parentState = ReverbPageWidget.of(context).model;
    this.curPower = log2(parentState._bpm/60*decayVaildLow).ceil();
    var reverbDecay = (60/parentState._bpm*pow(2,curPower));
    var preDelay = (60/parentState._bpm*pow(2,curPower));
    return Center(
      child:Card(
        margin: const EdgeInsets.all(20),
        elevation: 15.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14.0))),
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: BoxConstraints(
            maxHeight: 400
          ),
          child: Column(
            children: [
              Text("Parameters",style: TextStyle(fontSize: 24)),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: _paramLine("Name", "Value",isTitle: true),
              ),
              _paramLine("Reverb Decay", reverbDecay.toStringAsFixed(2)+"s", isNotVaild: reverbDecay < decayVaildLow || reverbDecay > decayVaildHigh),
              _paramLine("Pre Delay", reverbDecay.toStringAsFixed(2)+"s"),
              _buttonLine()
            ],
          ),
        ),
      )
    );

  }
}

class ReverbCalculatorState extends State<ReverbCalculator> with SingleTickerProviderStateMixin{
  TabController _tabController;
  PageController _pageController;
  int _bpm = 130;
  List<ReverbPage> _reverbPages ;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex:0, length: 3, vsync: this);
  }
  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void _resetBpm(int bpm){
    setState(() {
      this._bpm = bpm;
    });
  }

  @override
  Widget build(BuildContext context) {
    _pageController = PageController(initialPage: 0);
    _reverbPages = [ReverbPage("板式混响",1, 4,10,100),ReverbPage("厅堂混响", 2, 4,30,100),ReverbPage("房间混响", 0.3, 1,10,30)];
    return Scaffold(
      appBar: AppBar(
        title: Text("Reverb Calculator"),
        actions: [
          TextButton(onPressed:(){_resetBpm(this._bpm-1);} , child: Text("-")),
          TextButton(onPressed: () {
            showDialog(context: context, builder: (c) {
              String bpmtext = this._bpm.toString();
              TextEditingController controller = TextEditingController(text: bpmtext);
              controller.selection = TextSelection(baseOffset: 0, extentOffset: bpmtext.length);
              return AlertDialog(
                title: Text("Reset BPM"),
                content: TextField(
                  keyboardType: TextInputType.number,
                  controller: controller,
                ),
                actions: [
                  FlatButton(onPressed: () {
                    _resetBpm(int.parse(controller.text));
                    Navigator.pop(context);
                  }, child: Text("OK")),
                  FlatButton(onPressed: () {
                    Navigator.pop(context);
                  }, child: Text("Cancel"))
                ],
              );
            });
          },child: Text("BPM:${this._bpm}"),),
          TextButton(onPressed: (){_resetBpm(this._bpm+1);}, child: Text("+")),
      ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: _reverbPages.map((e) => Tab(text: e.name.toString())).toList(),
            onTap: (i)=>_pageController.jumpToPage(i),
          ),
          Expanded(
              child: ReverbPageWidget(
                model: this,
                child:PageView.builder(
                  controller: _pageController,
                  itemBuilder: (c,i){
                    return _reverbPages[i];
                  },
                  itemCount: 3,
                  onPageChanged: (i)=>_tabController.animateTo(i),
                )
              )
          ),
        ],
      ),
    );
  }
}
class ReverbCalculator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ReverbCalculatorState();
}