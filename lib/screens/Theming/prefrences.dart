import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrefrencesScreen extends ConsumerStatefulWidget {
  const PrefrencesScreen({super.key});

  @override
  ConsumerState<PrefrencesScreen> createState() => _PrefrencesScreenState();
}

class _PrefrencesScreenState extends ConsumerState<PrefrencesScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Container(
                  child: SvgPicture.asset(
                    "assets/svg_images/dark_high_contrast.svg",
                  ),
                )),
                Expanded(
                    child: Container(
                  child: SvgPicture.asset(
                    "assets/svg_images/dark_high_contrast.svg",
                  ),
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
