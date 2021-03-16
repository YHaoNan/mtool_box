import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mtoolbox/note_player.dart';


List<int> currentNotes = [];
class KeyScaleBody extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => KeyScaleBodyState();
}

class KeyScaleBodyState extends State<KeyScaleBody>{
  final noteList = [
    ['C','C'],
    ['#C','bD'],
    ['D','D'],
    ['#D','bE'],
    ['E','E'],
    ['F','F'],
    ['#F','bG'],
    ['G','G'],
    ['#G','bA'],
    ['A','A'],
    ['#A','bB'],
    ['B','B']
  ];

  final modes = [
    {
      'name': '自然大调',
      'skip': [2,2,1,2,2,2,1]
    },
    {
      'name': '自然小调',
      'skip': [2,1,2,2,1,2,2]
    },
    {
      'name': '旋律小调',
      'skip': [2,1,2,2,2,2,1]
    },
    {
      'name': '旋律小调(下行)',
      'skip': [-2,-2,-1,-2,-2,-1,-2]
    },
    {
      'name': '和声小调',
      'skip': [2,1,2,2,1,3,1]
    },
    {
      'name': '五声音阶',
      'skip': [2,2,3,2,3]
    },
    {
      'name': '小调Blues',
      'skip': [3,2,1,1,3,2]
    },
    {
      'name': '日本',
      'skip': [1,4,2,3,2]
    }
  ];

  // 是否显示#号
  var raisingMode = true;
  var noteValue = 0;
  var modeValue = 0;

  Widget _noteSelector(){
    return DropdownButton(
      value: this.noteValue,
      items: noteList.asMap().keys.map((i) => DropdownMenuItem(child: Text(raisingMode?noteList[i][0]:noteList[i][1]),value: i)).toList(),
      onChanged: (v){
        setState(() {
          this.noteValue = v;
        });
      },
      hint: Text("请选择主音"),
    );
  }
  Widget _modeSelector(){
    return DropdownButton(
      value: this.modeValue,
      items: modes.asMap().keys.map((i) => DropdownMenuItem(child: Text(modes[i]['name']),value: i)).toList(),
      onChanged: (v){
        setState(() {
          this.modeValue = v;
        });
      },
      hint: Text("请选择调式"),
    );
  }

  Widget _selectionBar(){
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: _noteSelector(),
            flex: 1,
          ),
          Expanded(
            child: _modeSelector(),
            flex: 1,
          ),
          Text('#号'),
          Switch(value: this.raisingMode, onChanged: (v)=>
              setState(()=>{
                this.raisingMode = v
              })
          )
        ],
      ),
    );
  }

  Widget _noteBlock(int i,String name){
    return Expanded(child:
      Container(
        height: 60,
        alignment: Alignment.center,
        color: i%2==0 ? Colors.white:Colors.grey,
        child: Text(name),
      )
    );
  }

  List<Widget> _computeNotes(){
    int notePos = this.noteValue;
    int pos = 0;
    List<Widget> notes = [];
    currentNotes = [];
    for(int i in modes[modeValue]['skip']){
      currentNotes.add(notePos);
      notes.add(
        _noteBlock(pos++, raisingMode?noteList[notePos][0] : noteList[notePos][1])
      );
      if(i>=0)
        notePos = (notePos + i) % 12;
      else{
        final tmp = notePos + i;
        if(tmp>=0)notePos = tmp;
        else {
          notePos = 12 + tmp;
        }
      }
    }
    notes.add(
        _noteBlock(pos++, raisingMode?noteList[notePos][0] : noteList[notePos][1])
    );
    return notes;
  }

  Widget _noteBar(){
    return Container(
      padding: EdgeInsets.only(left: 34,right: 34),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _computeNotes(),
      ),
    );
  }

  String _stepText(){
    final stepList = modes[modeValue]['skip'] as List<int>;
    var string = "";
    for (var value in stepList) {
      value = value.abs();
      if(value == 2)
        string+="全";
      else if(value == 1)
        string+="半";
      else
        string+="三";
    }
    return string;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _selectionBar(),
        Expanded(flex:1,child: Center(
          child: _noteBar(),
        )),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: Text(_stepText()),
        )
      ],
    );
  }
}


class KeyScale extends StatelessWidget{
  void _play(){
    NotePlayer().play(currentNotes);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("调式"),
          actions: [
            InkWell(
              child: Container(
                padding: const EdgeInsets.only(right: 10),
                alignment: Alignment.center,
                child: Text("播放"),
              ),
              onTap: _play,
            )
          ],
        ),
        body: KeyScaleBody()
    );
  }
}
