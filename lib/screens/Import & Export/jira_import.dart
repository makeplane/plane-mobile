import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plane/widgets/custom_app_bar.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/widgets/custom_text.dart';
import '/utils/enums.dart';

class JiraImport extends ConsumerStatefulWidget {
  const JiraImport({super.key});

  @override
  ConsumerState<JiraImport> createState() => _JiraImportState();
}

class _JiraImportState extends ConsumerState<JiraImport> {
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //svg image

            Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              height: 2,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 10),
            Row(
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
                    colorFilter:
                        const ColorFilter.mode(Colors.blue, BlendMode.srcIn),
                    height: 45,
                    width: 45,
                  ),
                ),
                const SizedBox(width: 10),
                //text
                const CustomText(
                  'Jira',
                  type: FontStyle.H4,
                  fontWeight: FontWeightt.Semibold,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.only(
                  top: 16, bottom: 16, left: 16, right: 16),
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
                    child: Icon(
                      Icons.done,
                      color: selected == 4
                          ? Colors.white
                          : const Color.fromRGBO(143, 143, 147, 1),
                    ),
                  ),
                ],
              ),
            ),
            selected == 0
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            // Text(
                            //   'View Title',
                            //   style: TextStyle(
                            //     fontSize: 15,
                            //     fontWeight: FontWeight.w400,
                            //     color: themeProvider.secondaryTextColor,
                            //   ),
                            // ),
                            CustomText(
                              'Jira personal access token (Attlasian settings)',
                              type: FontStyle.Small,
                              // color: themeProvider.secondaryTextColor,
                            ),
                            // const Text(
                            //   ' *',
                            //   style: TextStyle(
                            //     fontSize: 15,
                            //     fontWeight: FontWeight.w400,
                            //     color: Colors.red,
                            //   ),
                            // ),
                            CustomText(
                              ' *',
                              type: FontStyle.Small,
                              color: Colors.red,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Container(
                          // padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(4)),
                          child: DropdownButtonFormField(
                              dropdownColor: themeProvider
                                  .themeManager.secondaryBackgroundDefaultColor,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'Admin',
                                  child: CustomText(
                                    'Admin',
                                    type: FontStyle.Medium,
                                    fontWeight: FontWeightt.Semibold,
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Member',
                                  child: CustomText(
                                    'Member',
                                    type: FontStyle.Medium,
                                    fontWeight: FontWeightt.Semibold,
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Viewer',
                                  child: CustomText(
                                    'Viewer',
                                    type: FontStyle.Medium,
                                    fontWeight: FontWeightt.Semibold,
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Guest',
                                  child: CustomText(
                                    'Guest',
                                    type: FontStyle.Medium,
                                    fontWeight: FontWeightt.Semibold,
                                  ),
                                ),
                              ],
                              onChanged: (val) {}),
                        ),
                        const SizedBox(height: 20),
                        const Row(
                          children: [
                            // Text(
                            //   'View Title',
                            //   style: TextStyle(
                            //     fontSize: 15,
                            //     fontWeight: FontWeight.w400,
                            //     color: themeProvider.secondaryTextColor,
                            //   ),
                            // ),
                            CustomText(
                              'Jira Project Key',
                              type: FontStyle.Small,
                              // color: themeProvider.secondaryTextColor,
                            ),
                            // const Text(
                            //   ' *',
                            //   style: TextStyle(
                            //     fontSize: 15,
                            //     fontWeight: FontWeight.w400,
                            //     color: Colors.red,
                            //   ),
                            // ),
                            CustomText(
                              ' *',
                              type: FontStyle.Small,
                              color: Colors.red,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          decoration: themeProvider
                              .themeManager.textFieldDecoration
                              .copyWith(
                            fillColor: themeProvider
                                .themeManager.primaryBackgroundDefaultColor,
                            filled: true,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Row(
                          children: [
                            // Text(
                            //   'View Title',
                            //   style: TextStyle(
                            //     fontSize: 15,
                            //     fontWeight: FontWeight.w400,
                            //     color: themeProvider.secondaryTextColor,
                            //   ),
                            // ),
                            CustomText(
                              'Jira Email Address',
                              type: FontStyle.Small,
                              // color: themeProvider.secondaryTextColor,
                            ),
                            // const Text(
                            //   ' *',
                            //   style: TextStyle(
                            //     fontSize: 15,
                            //     fontWeight: FontWeight.w400,
                            //     color: Colors.red,
                            //   ),
                            // ),
                            CustomText(
                              ' *',
                              type: FontStyle.Small,
                              color: Colors.red,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          decoration: themeProvider
                              .themeManager.textFieldDecoration
                              .copyWith(
                            fillColor: themeProvider
                                .themeManager.primaryBackgroundDefaultColor,
                            filled: true,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Row(
                          children: [
                            // Text(
                            //   'View Title',
                            //   style: TextStyle(
                            //     fontSize: 15,
                            //     fontWeight: FontWeight.w400,
                            //     color: themeProvider.secondaryTextColor,
                            //   ),
                            // ),
                            CustomText(
                              'Jira installation or Cloud host name',
                              type: FontStyle.Small,
                              // color: themeProvider.secondaryTextColor,
                            ),
                            // const Text(
                            //   ' *',
                            //   style: TextStyle(
                            //     fontSize: 15,
                            //     fontWeight: FontWeight.w400,
                            //     color: Colors.red,
                            //   ),
                            // ),
                            CustomText(
                              ' *',
                              type: FontStyle.Small,
                              color: Colors.red,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(4)),
                          child: DropdownButtonFormField(
                              dropdownColor: themeProvider
                                  .themeManager.secondaryBackgroundDefaultColor,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'Admin',
                                  child: CustomText(
                                    'Admin',
                                    type: FontStyle.Medium,
                                    fontWeight: FontWeightt.Semibold,
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Member',
                                  child: CustomText(
                                    'Member',
                                    type: FontStyle.Medium,
                                    fontWeight: FontWeightt.Semibold,
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Viewer',
                                  child: CustomText(
                                    'Viewer',
                                    type: FontStyle.Medium,
                                    fontWeight: FontWeightt.Semibold,
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Guest',
                                  child: CustomText(
                                    'Guest',
                                    type: FontStyle.Medium,
                                    fontWeight: FontWeightt.Semibold,
                                  ),
                                ),
                              ],
                              onChanged: (val) {}),
                        ),
                        const SizedBox(height: 50),
                        const Button(text: 'Next'),
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
