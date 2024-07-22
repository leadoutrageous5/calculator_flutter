// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:calculator/button_values.dart';
import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String number1 = "";
  String operand = "";
  String number2 = "";
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 24),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Calculator",
            style: TextStyle(
                fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              //outpurs
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  child: Container(
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.all(18),
                    child: Text(
                      "$number1$operand$number2".isEmpty
                          ? "0"
                          : "$number1$operand$number2",
                      style: const TextStyle(
                          fontSize: 47, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ),
              //buttons
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 24,
                ),
                child: Wrap(
                  children: Btn.buttonValues
                      .map(
                        (value) => SizedBox(
                            width: value == Btn.n0
                                ? screenSize.width / 2
                                : screenSize.width / 4,
                            height: screenSize.width / 5,
                            child: buildButton(value)),
                      )
                      .toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: const BorderSide(color: Colors.white24)),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
              child: Text(
            value,
            style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }

//////####
  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }
    if (value == Btn.clr) {
      clearAll();
      return;
    }
    if (value == Btn.per) {
      convertToPercentage();
      return;
    }
    if (value == Btn.calculate) {
      calculate();
      return;
    }

    appendValue(value);
  }

  /// Calcute funtion below
  void calculate() {
    if (number1.isEmpty) return;
    if (number2.isEmpty) return;
    if (operand.isEmpty) return;

    //then calcute and then assign it to number1 and display it
    double num1 = double.parse(number1);
    double num2 = double.parse(number2);

    var result = 0.0;

    switch (operand) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        result = num1 / num2;
        break;
      default:
    }

    setState(() {
      number1 = "$result";

      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }
      operand = "";
      number2 = "";
    });
  }

  /// Converts output  to Percentage
  void convertToPercentage() {
    //ex 245 + 2334
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      // calcute before conversion
      //ToDo
      // final res = number1 operand number2
      //number1 = res\
      calculate();
    }
    if (operand.isNotEmpty) {
      //cannot be converted if it;s llike 789+ or 374-
      return;
    }
    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operand = "";
      number2 = "";
    });
  }

  ///### function to clear all
  void clearAll() {
    setState(() {
      number1 = "";
      number2 = "";
      operand = "";
    });
  }

  /////#####
  ///delete from the end
  void delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }
    setState(() {});
  }

  void appendValue(String value) {
    //check if the value clicked is not a number and also a dot ;:
    //what tryparse does is ...it takes the value and checks if
    //its interger or not and returns null if its not integer
    // and returns a number if it's a number.
    if (value != Btn.dot && int.tryParse(value) == null) {
      //
      if (number2.isNotEmpty && operand.isNotEmpty) {
        /// that means we have a " 34234" " +" "434" ... a whole equation
        /// and here we have to do the calculation
        calculate();
      }
      //else we have to give that value to the Operand
      operand = value;
    } else if (number1.isEmpty || operand.isEmpty) {
      //
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
        number1 = "0.";
      }
      number1 += value;
    } else if (number2.isEmpty || operand.isNotEmpty) {
      if (value == Btn.dot && number2.contains(Btn.dot)) return;
      if (value == Btn.dot && (number2.isEmpty || number2 == Btn.dot)) {
        number2 = "0.";
      }
      number2 += value;
    }
    setState(() {});
  }

  /// #######
  Color getBtnColor(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.blueGrey
        : [
            Btn.per,
            Btn.multiply,
            Btn.divide,
            Btn.subtract,
            Btn.add,
            Btn.calculate
          ].contains(value)
            ? Colors.orange
            : Colors.black;
  }
}
