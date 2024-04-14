import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import '../widgets/numtoword.dart';

class CountDetailsScreen extends StatelessWidget {
  final Map<String, dynamic>
      item; // Pass any data you want to display on this screen

  const CountDetailsScreen(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final originalDateTime = DateTime.parse(item['date']);

    final formattedDate =
        DateFormat('EEE dd/MM/yyyy HH:mm:ss').format(originalDateTime);
    return SelectionArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: "${item['title']}"
              .text
              .maxLines(1)
              .maxFontSize(15)
              .xl2
              .uppercase
              .bold
              .make(),
        ),
        body: Hero(
          tag: Key(item["id"].toString()),
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                "${item['title']} $formattedDate "
                    .text
                    .maxLines(1)
                    .maxFontSize(15)
                    .xl2
                    .uppercase
                    .bold
                    .make(),
                Table(
                  children: [
                    TableRow(
                      children: [
                        "1000".text.make(),
                        "X".text.make(),
                        item['input1'] == ""
                            ? "0".text.make()
                            : "${item['input1']}".text.make(),
                        " = ".text.make(),
                        "${item['output1']}".text.make(),
                      ],
                    ),
                    TableRow(
                      children: [
                        "500".text.make(),
                        "X".text.make(),
                        "${item['input2']}".text.make(),
                        " = ".text.make(),
                        "${item['output2']}".text.make(),
                      ],
                    ),
                    TableRow(
                      children: [
                        "200".text.make(),
                        "X".text.make(),
                        "${item['input3']}".text.make(),
                        " = ".text.make(),
                        "${item['output3']}".text.make(),
                      ],
                    ),
                    TableRow(
                      children: [
                        "100".text.make(),
                        "X".text.make(),
                        "${item['input4']}".text.make(),
                        " = ".text.make(),
                        "${item['output4']}".text.make(),
                      ],
                    ),
                    TableRow(
                      children: [
                        "50".text.make(),
                        "X".text.make(),
                        "${item['input5']}".text.make(),
                        " = ".text.make(),
                        "${item['output5']}".text.make(),
                      ],
                    ),
                    TableRow(
                      children: [
                        "20".text.make(),
                        "X".text.make(),
                        "${item['input6']}".text.make(),
                        " = ".text.make(),
                        "${item['output6']}".text.make(),
                      ],
                    ),
                    TableRow(
                      children: [
                        "10".text.make(),
                        "X".text.make(),
                        "${item['input7']}".text.make(),
                        " = ".text.make(),
                        "${item['output7']}".text.make(),
                      ],
                    ),
                    TableRow(
                      children: [
                        "5".text.make().hide(isVisible: item['input8'] != ""),
                        "X".text.make().hide(isVisible: item['input8'] != ""),
                        "${item['input8']}"
                            .text
                            .make()
                            .hide(isVisible: item['input8'] != ""),
                        " = ".text.make().hide(isVisible: item['input8'] != ""),
                        "${item['output8']}"
                            .text
                            .make()
                            .hide(isVisible: item['input8'] != ""),
                      ],
                    ),
                    TableRow(
                      children: [
                        "2".text.make().hide(isVisible: item['input9'] != ""),
                        "X".text.make().hide(isVisible: item['input9'] != ""),
                        "${item['input9']}"
                            .text
                            .make()
                            .hide(isVisible: item['input9'] != ""),
                        " = ".text.make().hide(isVisible: item['input9'] != ""),
                        "${item['output9']}"
                            .text
                            .make()
                            .hide(isVisible: item['input9'] != ""),
                      ],
                    ),
                    TableRow(
                      children: [
                        "--------------".text.make(),
                        "--------------".text.make(),
                        "--------------".text.make(),
                        "--------------".text.make(),
                        "--------------".text.make(),
                      ],
                    ),
                  ],
                ),
                NumberFormat.currency(
                        decimalDigits: 0,
                        customPattern: 'Total: \u09f3 ##,##,###/=')
                    .format(item['total_output'])
                    .text
                    .xl2
                    .bold
                    .make(),
                "${NumberToWordsEnglish.convert(item['total_output'])} only "
                    .text
                    .maxFontSize(15)
                    .xl2
                    .bold
                    .uppercase
                    .black
                    .headline5(context)
                    .make()
                    .p(10)
              ],
            ).p12(),
          ),
        ).box.width(context.screenWidth * .50).makeCentered(),
      ),
    );
  }
}
