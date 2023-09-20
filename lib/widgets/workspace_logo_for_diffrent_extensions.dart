import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plane/provider/theme_provider.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/utils/string_manager.dart';
import 'package:plane/widgets/custom_text.dart';

class WorkspaceLogoForDiffrentExtensions extends StatefulWidget {
  const WorkspaceLogoForDiffrentExtensions(
      {required this.imageUrl,
      required this.themeProvider,
      required this.workspaceName,
      super.key});
  final String? imageUrl;
  final String workspaceName;
  final ThemeProvider themeProvider;
  @override
  State<WorkspaceLogoForDiffrentExtensions> createState() =>
      _WorkspaceLogoForDiffrentExtensionsState();
}

class _WorkspaceLogoForDiffrentExtensionsState
    extends State<WorkspaceLogoForDiffrentExtensions> {
  @override
  Widget build(BuildContext context) {
    return customImageRenderer(
      widget.imageUrl,
      widget.workspaceName,
      widget.themeProvider,
    );
  }

  Widget customImageRenderer(
      String? imageUrl, String workspaceName, ThemeProvider themeProvider) {
    List<String> imageExtensiones = [".jpg", ".png", ".jpeg", ".webp"];
    String svgExtension = ".svg";

    if (imageUrl == null) {
      return imageAlternative(themeProvider, workspaceName);
    } else if (imageUrl == '') {
      return imageAlternative(themeProvider, workspaceName);
    } else if (imageExtensiones
        .contains(StringManager.getLastNCharecters(imageUrl, 4))) {
      return networkImage(imageUrl, themeProvider, workspaceName);
    } else if (imageExtensiones
        .contains(StringManager.getLastNCharecters(imageUrl, 5))) {
      return networkImage(imageUrl, themeProvider, workspaceName);
    } else if ((StringManager.getLastNCharecters(imageUrl, 4) ==
        svgExtension)) {
      return svgImage(imageUrl);
    } else {
      return imageAlternative(themeProvider, workspaceName);
    }
  }

  SvgPicture svgImage(String imageUrl) {
    return SvgPicture.network(
      imageUrl,
      width: 35,
      height: 35,
    );
  }

  CachedNetworkImage networkImage(
      String imageUrl, ThemeProvider themeProvider, String workspaceName) {
    return CachedNetworkImage(
      height: 35,
      width: 35,
      fit: BoxFit.cover,
      imageUrl: imageUrl,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: themeProvider.themeManager.primaryColour,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 0,
        ),
        child: Center(
          child: CustomText(
            workspaceName[0].toUpperCase(),
            type: FontStyle.Medium,
            fontWeight: FontWeightt.Bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Container imageAlternative(
      ThemeProvider themeProvider, String workspaceName) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: themeProvider.themeManager.primaryColour,
      ),
      child: Center(
        child: CustomText(
          workspaceName[0].toUpperCase(),
          type: FontStyle.Medium,
          fontWeight: FontWeightt.Bold,
          color: Colors.white,
          overrride: true,
        ),
      ),
    );
  }
}
