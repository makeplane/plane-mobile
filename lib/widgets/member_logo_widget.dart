import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plane_startup/widgets/member_logo_alternative_widget.dart';

class MemberLogoWidget extends StatelessWidget {
  const MemberLogoWidget({
    super.key,
    required this.imageUrl,
    required this.colorForErrorWidget,
    required this.memberNameFirstLetterForErrorWidget,
  });
  final String imageUrl;
  final String memberNameFirstLetterForErrorWidget;
// int index;
  final Color colorForErrorWidget;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        errorWidget: (context, url, error) => MemeberLogoAlternativeWidget(
            memberNameFirstLetterForErrorWidget, colorForErrorWidget),
        height: 45,
        width: 45,
        fit: BoxFit.cover,
      ),
    );
  }
}
