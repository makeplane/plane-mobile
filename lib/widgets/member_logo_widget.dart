import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plane/utils/string_manager.dart';
import 'package:plane/widgets/member_logo_alternative_widget.dart';

class MemberLogoWidget extends StatelessWidget {
  const MemberLogoWidget({
    super.key,
    required this.imageUrl,
    required this.colorForErrorWidget,
    required this.memberNameFirstLetterForErrorWidget,
    this.size = 45,
    this.padding = const EdgeInsets.all(5),
  });
  final String imageUrl;
  final String memberNameFirstLetterForErrorWidget;
  final double? size;
  final Color colorForErrorWidget;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: SizedBox(
          height: size ?? 45,
          width: size ?? 45,
          child: customImageRenderer(
            imageUrl,
          ),
        ),
      ),
    );
  }

  Widget customImageRenderer(String? imageUrl) {
    final List<String> imageExtensiones = [".jpg", ".png", ".jpeg", ".webp"];
    const String svgExtension = ".svg";

    if (imageUrl == null) {
      return MemeberLogoAlternativeWidget(
          memberNameFirstLetterForErrorWidget, colorForErrorWidget);
    } else if (imageUrl == '') {
      return MemeberLogoAlternativeWidget(
          memberNameFirstLetterForErrorWidget, colorForErrorWidget);
    } else if (imageExtensiones
        .contains(StringManager.getLastNCharecters(imageUrl, 4))) {
      return networkImage(imageUrl);
    } else if (imageExtensiones
        .contains(StringManager.getLastNCharecters(imageUrl, 5))) {
      return networkImage(imageUrl);
    } else if ((StringManager.getLastNCharecters(imageUrl, 4) ==
        svgExtension)) {
      return svgImage(imageUrl);
    } else {
      return MemeberLogoAlternativeWidget(
          memberNameFirstLetterForErrorWidget, colorForErrorWidget);
    }
  }

  Widget svgImage(String imageUrl) {
    return SvgPicture.network(
      imageUrl,
      fit: BoxFit.cover,
    );
  }

  Widget networkImage(String imageUrl) {
    return CachedNetworkImage(
      height: 45,
      width: 45,
      fit: BoxFit.cover,
      imageUrl: imageUrl,
      placeholder: (context, url) => const CircularProgressIndicator(),
    );
  }
}
