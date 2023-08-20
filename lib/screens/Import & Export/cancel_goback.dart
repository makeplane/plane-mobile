import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plane_startup/provider/theme_provider.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/widgets/custom_app_bar.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import '/utils/enums.dart';

class ImportExportCancel extends ConsumerStatefulWidget {
  const ImportExportCancel({super.key});

  @override
  ConsumerState<ImportExportCancel> createState() => _ImportExportCancelState();
}

class _ImportExportCancelState extends ConsumerState<ImportExportCancel> {
  var selected = 0;
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: CustomAppBar(
        onPressed: () {
          Navigator.pop(context);
        },
        text: 'Import & Export',
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            height: 2,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[300],
          ),
          Container(
            margin:
                const EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
            child: Row(
              children: [
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: selected > 0
                        ? const Color.fromRGBO(9, 169, 83, 1)
                        : selected == 0
                            ? const Color.fromRGBO(63, 118, 255, 1)
                            : null,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Icon(
                    Icons.settings,
                    color: selected == 0 || selected > 0
                        ? Colors.white
                        : const Color.fromRGBO(143, 143, 147, 1),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    height: 2,
                    color: Colors.grey[300],
                  ),
                ),
                Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.grey.shade300),
                      color: selected > 1
                          ? const Color.fromRGBO(9, 169, 83, 1)
                          : selected == 1
                              ? const Color.fromRGBO(63, 118, 255, 1)
                              : null,
                    ),
                    child: Icon(Icons.cloud_upload_outlined,
                        color: selected == 1
                            ? Colors.white
                            : const Color.fromRGBO(143, 143, 147, 1))),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    height: 2,
                    color: Colors.grey[300],
                  ),
                ),
                Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.grey.shade300),
                      color: selected == 2
                          ? const Color.fromRGBO(63, 118, 255, 1)
                          : null,
                    ),
                    child: Icon(Icons.menu,
                        color: selected == 2
                            ? Colors.white
                            : const Color.fromRGBO(143, 143, 147, 1))),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    height: 2,
                    color: Colors.grey[300],
                  ),
                ),
                Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.grey.shade300),
                      color: selected == 3
                          ? const Color.fromRGBO(63, 118, 255, 1)
                          : null,
                    ),
                    child: Icon(Icons.groups,
                        color: selected == 3
                            ? Colors.white
                            : const Color.fromRGBO(143, 143, 147, 1))),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    height: 2,
                    color: Colors.grey[300],
                  ),
                ),
                Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.grey.shade300),
                      color: selected == 4
                          ? const Color.fromRGBO(63, 118, 255, 1)
                          : null,
                    ),
                    child: Icon(Icons.done,
                        color: selected == 4
                            ? Colors.white
                            : const Color.fromRGBO(143, 143, 147, 1))),
              ],
            ),
          ),
          selected == 0
              ? Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(bottom: 16),
                  margin: const EdgeInsets.only(right: 16, top: 16),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 15),
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.grey.shade200),
                        child: SvgPicture.asset(
                          'assets/svg_images/slack.svg',
                          height: 45,
                          width: 45,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 120,
                            child: const CustomText(
                              'Github Configure',
                              textAlign: TextAlign.left,
                              type: FontStyle.Small,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            width: MediaQuery.of(context).size.width - 120,
                            child: const CustomText(
                              'Set up your GitHub import.',
                              textAlign: TextAlign.left,
                              maxLines: 3,
                              type: FontStyle.Small,
                              color: Color.fromRGBO(133, 142, 150, 1),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Container(),
          Expanded(
              child: PageView.builder(
                  onPageChanged: (index) {
                    setState(() {
                      selected = index;
                    });
                  },
                  itemBuilder: (ctx, index) => selected == 0
                      ? Column(
                          children: [
                            const Spacer(),
                            Container(
                                height: 45,
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(
                                    bottom: 20, top: 20, left: 20, right: 20),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(63, 118, 255, 1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Center(
                                    child: CustomText(
                                  'Connect',
                                  color: Colors.white,
                                  type: FontStyle.Medium,
                                ))),
                          ],
                        )
                      : upload(themeProvider)))
        ],
      ),
    );
  }

  upload(ThemeProvider themeProvider) {
    return Column(
      children: [
        Container(
            margin:
                const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 5),
            child: const Row(
              children: [
                CustomText(
                  'Select Repository (import from) ',
                  type: FontStyle.Small,
                ),
                CustomText(
                  ' *',
                  type: FontStyle.Small,
                  color: Colors.red,
                ),
              ],
            )),
        Container(
          margin: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          padding: const EdgeInsets.only(
            left: 10,
          ),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4)),
          child: DropdownButtonFormField(
              dropdownColor: themeProvider.isDarkThemeEnabled
                  ? darkSecondaryBGC
                  : Colors.white,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Admin',
                  child: CustomText(
                    'Admin',
                    type: FontStyle.H5,
                  ),
                ),
                DropdownMenuItem(
                  value: 'Member',
                  child: CustomText(
                    'Member',
                    type: FontStyle.H5,
                  ),
                ),
                DropdownMenuItem(
                  value: 'Viewer',
                  child: CustomText(
                    'Viewer',
                    type: FontStyle.H5,
                  ),
                ),
                DropdownMenuItem(
                  value: 'Guest',
                  child: CustomText(
                    'Guest',
                    type: FontStyle.H5,
                  ),
                ),
              ],
              onChanged: (val) {}),
        ),
        Container(
            margin:
                const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 5),
            child: const Row(
              children: [
                CustomText(
                  'Select Project (import to) ',
                  type: FontStyle.Small,
                ),
                CustomText(
                  ' *',
                  type: FontStyle.Small,
                  color: Colors.red,
                ),
              ],
            )),
        Container(
          margin: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          padding: const EdgeInsets.only(
            left: 10,
          ),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4)),
          child: DropdownButtonFormField(
              dropdownColor: themeProvider.isDarkThemeEnabled
                  ? darkSecondaryBGC
                  : Colors.white,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Admin',
                  child: CustomText(
                    'Admin',
                    type: FontStyle.H5,
                  ),
                ),
                DropdownMenuItem(
                  value: 'Member',
                  child: CustomText(
                    'Member',
                    type: FontStyle.H5,
                  ),
                ),
                DropdownMenuItem(
                  value: 'Viewer',
                  child: CustomText(
                    'Viewer',
                    type: FontStyle.H5,
                  ),
                ),
                DropdownMenuItem(
                  value: 'Guest',
                  child: CustomText(
                    'Guest',
                    type: FontStyle.H5,
                  ),
                ),
              ],
              onChanged: (val) {}),
        ),
        Container(
            margin:
                const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 5),
            child: const Row(
              children: [
                CustomText(
                  'Sync Issues ',
                  type: FontStyle.Small,
                ),
                CustomText(
                  ' *',
                  type: FontStyle.Small,
                  color: Colors.red,
                ),
              ],
            )),
        Row(
          children: [
            Expanded(
                child: Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 10,
              ),
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4)),
              alignment: Alignment.center,
              child: const CustomText(
                'Yes',
                type: FontStyle.Small,
              ),
            )),
            Expanded(
                child: Container(
              margin: const EdgeInsets.only(
                left: 10,
                right: 20,
              ),
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4)),
              alignment: Alignment.center,
              child: const CustomText(
                'No',
                type: FontStyle.Small,
              ),
            )),
          ],
        ),
        const Spacer(),
        Row(
          children: [
            Expanded(
                child: Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 10,
              ),
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                  border:
                      Border.all(color: const Color.fromRGBO(143, 143, 147, 1)),
                  borderRadius: BorderRadius.circular(4)),
              alignment: Alignment.center,
              child: const CustomText(
                'Back',
                type: FontStyle.Medium,
              ),
            )),
            Expanded(
                child: Container(
              margin: const EdgeInsets.only(
                left: 10,
                right: 20,
              ),
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                  color: themeProvider.themeManager.primaryColour,
                  borderRadius: BorderRadius.circular(4)),
              alignment: Alignment.center,
              child: const CustomText(
                'Next',
                type: FontStyle.Medium,
              ),
            )),
          ],
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
