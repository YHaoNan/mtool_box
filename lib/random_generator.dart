import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mtoolbox/rotary_table.dart';

class RandomGenerator extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => RandomGeneratorState();
}
class RandomGeneratorState extends State<RandomGenerator> with SingleTickerProviderStateMixin{
  TabController _tabController;
  PageController _pageController;

  String _randomData = "请先生成\n\nPS:爷可没做什么检测你输入了啥的逻辑，输入点人东西";
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Widget _randomNumberGenerator(){
    TextEditingController _lowTextController = TextEditingController(text: "1");
    TextEditingController _highTextController = TextEditingController(text: "3");
    TextEditingController _numberTextController = TextEditingController(text: "1");
    return Container(
      padding: const EdgeInsets.all(20),
      child:Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _lowTextController,
                    decoration: InputDecoration(
                      labelText: "随机范围下界",
                      labelStyle: TextStyle(color: Colors.blueGrey),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent)
                      )
                    ),
                  )
              ),
              Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _highTextController,
                    decoration: InputDecoration(
                        labelText: "随机范围上界",
                        labelStyle: TextStyle(color: Colors.blueGrey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent)
                        )
                    ),
                  )
              ),
              Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _numberTextController,
                    decoration: InputDecoration(
                        labelText: "生成随机数个数",
                        labelStyle: TextStyle(color: Colors.blueGrey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent)
                        )
                    ),
                  )
              ),
            ],
          ),
          Container(
            width: 200,
            margin: EdgeInsets.only(top: 20,bottom: 20),
            child:MaterialButton(onPressed: (){
              int lowerBound = int.parse(_lowTextController.text);
              int upperBound = int.parse(_highTextController.text);
              int count = int.parse(_numberTextController.text);
              List<int> randoms = [];
              Random random = Random();
              for(int i=0;i<count;i++){
                randoms.add(random.nextInt(upperBound-lowerBound+1)+lowerBound);
              }
              setState(() {
                this._randomData = randoms.join("\n");
                print(_randomData);
              });
            }, child: Text("生成"),color: Colors.blueAccent,textColor: Colors.white,),
          ),
          Expanded(
              child:SingleChildScrollView(
                child: Text(this._randomData,textAlign: TextAlign.center),
              )
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Random Generator")),
      body: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: "随机数"),
              Tab(text: "淦饭神尺")
            ],
            controller: _tabController,
            onTap: (i){_pageController.jumpToPage(i);},
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemBuilder: (c,i){
                if(i==0)
                  return _randomNumberGenerator();
                else
                  return RotaryTable();
              },
              itemCount: 2,
              onPageChanged: (i){_tabController.animateTo(i);},
            ),
          ),
        ],
      ),
    );
  }
}