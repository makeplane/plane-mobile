import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomProgressBar extends StatelessWidget {
  CustomProgressBar({
    super.key,
    required this.width,
    required this.itemValue,
  });

  CustomProgressBar.withColorOverride({
    super.key,
    required this.width,
    required this.itemValue,
    required this.itemColors,
  });

  CustomProgressBar.withDummyValues({
    super.key,
    required this.width,
    this.itemValue = const [2, 1, 0, 3, 1],
  });

  final double width;

  List<int> itemValue = [];

  List<Color> itemColors = [
    Colors.orange.shade300,
    Colors.purple.shade200,
    Colors.black,
    Colors.pink.shade200,
    Colors.green.shade300
  ];

  Color _getColor(int colorIndex) {
    const Color ifColorNotAvaiable = Colors.red;
    return itemColors.length <= colorIndex
        ? ifColorNotAvaiable
        : itemColors[colorIndex];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 5,
      child: Row(
        children: [
          ...List.generate(
            itemValue.length,
            (index) {
              return itemValue[index] > 0
                  ? Expanded(
                      flex: itemValue[index],
                      child: Container(
                        margin: const EdgeInsets.only(left: 3),
                        decoration: BoxDecoration(
                            color: _getColor(index),
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    )
                  : Container();
            },
          )
        ],
      ),
    );
  }
}
