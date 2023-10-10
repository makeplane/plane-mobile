import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/utils/string_manager.dart';
import 'package:plane/widgets/member_logo_alternative_widget.dart';
import 'package:plane/widgets/shimmer_effect_widget.dart';

class MemberLogoWidget extends StatelessWidget {
  const MemberLogoWidget({
    super.key,
    required this.imageUrl,
    required this.colorForErrorWidget,
    required this.memberNameFirstLetterForErrorWidget,
    this.size = 45,
    this.padding = const EdgeInsets.all(5),
    this.boarderRadius = 5,
    this.fontType,
  });
  final String imageUrl;
  final String memberNameFirstLetterForErrorWidget;
  final double? size;
  final Color colorForErrorWidget;
  final EdgeInsets padding;
  final double boarderRadius;
  final FontStyle? fontType;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(boarderRadius),
        child: SizedBox(
          height: size ?? 45,
          width: size ?? 45,
          child: customImageRenderer(imageUrl, size ?? 45, fontType),
        ),
      ),
    );
  }

  Widget customImageRenderer(
      String? imageUrl, double size, FontStyle? fontType) {
    final List<String> imageExtensiones = [".jpg", ".png", ".jpeg", ".webp"];
    const String svgExtension = ".svg";
    if (imageUrl == null) {
      return MemeberLogoAlternativeWidget(
        memberNameFirstLetterForErrorWidget,
        colorForErrorWidget,
        type: fontType,
      );
    } else if (imageUrl == '') {
      return MemeberLogoAlternativeWidget(
        memberNameFirstLetterForErrorWidget,
        colorForErrorWidget,
        type: fontType,
      );
    } else if (imageExtensiones
        .contains(StringManager.getLastNCharecters(imageUrl, 4))) {
      return networkImage(imageUrl, size);
    } else if (imageExtensiones
        .contains(StringManager.getLastNCharecters(imageUrl, 5))) {
      return networkImage(imageUrl, size);
    } else if ((StringManager.getLastNCharecters(imageUrl, 4) ==
        svgExtension)) {
      return svgImage(imageUrl, size);
    } else {
      return MemeberLogoAlternativeWidget(
        memberNameFirstLetterForErrorWidget,
        colorForErrorWidget,
        type: fontType,
      );
    }
  }

  Widget svgImage(String imageUrl, double size) {
    return SvgPicture.network(
      imageUrl,
      placeholderBuilder: (context) => ShimmerEffectWidget(
        height: size,
        width: size,
      ),
      fit: BoxFit.cover,
    );
  }

  Widget networkImage(String imageUrl, double size) {
    return CachedNetworkImage(
      height: size,
      width: size,
      fit: BoxFit.cover,
      imageUrl: imageUrl,
      placeholder: (context, url) => ShimmerEffectWidget(
        height: size,
        width: size,
      ),
    );
  }
}
