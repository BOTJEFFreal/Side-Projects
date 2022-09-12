import 'package:calculator/button.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var userQuestion = '';
  var userAnswer = '0';
  final List<String> buttons = ['C','DEL','%','/',
                                '9','8','7','x',
                                '6','5','4','-',
                                '3','2','1','+',
                                '0','.','ANS','=',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:<Widget> [
                const SizedBox(height: 50),
                Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.centerLeft,
                  child: Text(userQuestion, style: TextStyle(fontSize: 30),)),
                Container(
                    padding: EdgeInsets.all(20),
                    alignment: Alignment.centerRight,
                    child: Text(userAnswer, style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold, color: Colors.white ),)),

              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.purpleAccent[200]),
                child: GridView.builder(
                    itemCount:buttons.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                    itemBuilder: (BuildContext context, int index){
                      if(index == 0){
                        return MyButton(
                          buttonText: buttons[index],
                          color: Colors.greenAccent,
                          textcolor: isOperator(buttons[index]) ? Colors.deepPurple: Colors.white ,
                          buttonTapped: (){
                            setState((){
                              userQuestion =" ";
                              userAnswer = "0";
                            });
                          },);

                      }else if(index == 1){
                        return MyButton(
                          buttonText: buttons[index],
                          color: Colors.black26,
                          textcolor: isOperator(buttons[index]) ? Colors.deepPurple: Colors.white ,
                          buttonTapped: (){
                            setState((){
                              userQuestion = userQuestion.substring(0,userQuestion.length-1);
                            });
                          },);

                      }
                      else if(index == buttons.length-2){
                        return MyButton(
                          buttonText: buttons[index],
                          color: Colors.black26,
                          textcolor: isOperator(buttons[index]) ? Colors.deepPurple: Colors.white ,
                          buttonTapped: (){
                            setState((){
                              userQuestion += userAnswer;
                            });
                          },);
                      }
                      else if(index == buttons.length-1){
                        return MyButton(
                          buttonText: buttons[index],
                          color: Colors.white70,
                          textcolor: Colors.white ,
                          buttonTapped: (){
                            setState((){

                              //Calculating the final value
                              final finalQuestion = userQuestion.replaceAll('x', '*');
                              Parser p = Parser();
                              Expression exp = p.parse(finalQuestion);
                              ContextModel cm = ContextModel();
                              double eval = exp.evaluate(EvaluationType.REAL, cm);

                              userAnswer = eval.toString();
                              userQuestion = '';
                            });
                          },);
                      }
                      else{
                        return MyButton(
                          buttonText: buttons[index],
                          color: isOperator(buttons[index]) ? Colors.white : Colors.deepPurple,
                          textcolor: isOperator(buttons[index]) ? Colors.deepPurple: Colors.white ,
                          buttonTapped: (){
                            setState((){
                              userQuestion += buttons[index];
                            });
                          },);
                      }
                    })
            ),
          ),
        ],
      ),
    );
  }


  bool isOperator(String x)
  {
    if(x == '%'|| x == '/'|| x == 'x'|| x == '-'|| x == '+'|| x== '='){
      return true;
    }
    else {
      return false;
    }
  }
}
