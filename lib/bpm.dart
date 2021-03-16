import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BPMTapperState extends State<BPMTapper>{
  var curBpm = 0.0; // 记录当前BPM
  var measuring = false; // 是否已经开始测量
  var prevTime = 0; // 上一次点击的时间
  /**
   * 其实理想的设计是为确保计算平均时间间隔的速度，使用一个能够快速弹出最大和最小值的数据结构，
   * 当队列中元素过多时弹出一部分最大值和最小值，因为这时两端都是极端值
   * 但队列长度很难达到影响速度的长度
   */
  var timeIntervals = <int>[]; // 每次点击的时间间隔列表


  int _getTime(){
    return DateTime.now().millisecondsSinceEpoch;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        child: TextButton(
          child: Text(!measuring?"按节拍点击":curBpm.toInt().toString()),
          onPressed: (){
            setState(() {
              if(measuring){
                final thisTimeInterval = _getTime() - this.prevTime;
                timeIntervals.add(thisTimeInterval);
                var sumOfIntervals = 0;
                timeIntervals.forEach((element) {sumOfIntervals+=element;});
                this.curBpm=(60000/(sumOfIntervals/(timeIntervals.length)));
                print("$thisTimeInterval,$sumOfIntervals,${this.curBpm.toInt()},${timeIntervals.length}");
                this.prevTime += thisTimeInterval;
              }else{
                this.prevTime = _getTime();
                this.measuring = true;
              }
            });
          },
          onLongPress: (){
            setState(() {
              this.curBpm = 0;
              this.measuring = false;
              this.timeIntervals.clear();
            });
          },
        ),
      ),
    );
  }
}
class BPMTapper extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => BPMTapperState();
}
class Bpm extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bpm Tester"),
        actions: [
          IconButton(icon: Icon(Icons.question_answer), onPressed: (){
            showDialog(context: context, builder: (c)=>AlertDialog(
              title: Text('How to use'),
              content: Text("与大部分宿主相同，播放音乐后按照节拍点击中间的按钮，直至BPM趋于稳定。BPM与拍号无关。\n\nTips: 长按重置"),
              actions: [
                FlatButton(onPressed: ()=>Navigator.pop(context), child: Text("OK"))
              ],
            ));
          })
        ],
      ),
      body: BPMTapper(),
    );
  }

}