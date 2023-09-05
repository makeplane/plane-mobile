import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/widgets/custom_text.dart';

import '../utils/enums.dart';

class SelectEmails extends ConsumerStatefulWidget {
  const SelectEmails({required this.email, super.key});
  final Map email;
  @override
  ConsumerState<SelectEmails> createState() => _SelectEmailsState();
}

class _SelectEmailsState extends ConsumerState<SelectEmails> {
  var emails = [];
  @override
  void initState() {
    var workspaceProvider = ref.read(ProviderList.workspaceProvider);
    workspaceProvider.invitingMembersRole.text = 'Viewer';
    for (var element in workspaceProvider.workspaceMembers) {
      emails.add(
          {"email": element['member']['email'], "id": element["member"]["id"]});
    }
    super.initState();
  }

  var selectedEmail = -1;

  @override
  Widget build(BuildContext context) {
    var themeProv = ref.watch(ProviderList.themeProvider);
    var profProv = ref.watch(ProviderList.profileProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        )),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 25, bottom: 20),
                child: Row(
                  children: [
                    const CustomText(
                      'Select Member',
                      type: FontStyle.H6,
                      fontWeight: FontWeightt.Semibold,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.close,
                        color: themeProv.isDarkThemeEnabled
                            ? darkSecondaryTextColor
                            : strokeColor,
                      ),
                    )
                  ],
                ),
              ),
              emails.length == 1
                  ? Container()
                  : ListView.builder(
                      itemCount: emails.length,
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (context, index) {
                        return emails[index]["email"] ==
                                profProv.userProfile.email
                            ? Container()
                            : Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        widget.email["email"] =
                                            emails[index]["email"];
                                        widget.email["id"] =
                                            emails[index]["id"];

                                        selectedEmail = index;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: Row(
                                      children: [
                                        Radio(
                                          activeColor: primaryColor,
                                          value: index,
                                          groupValue: selectedEmail,
                                          onChanged: (value) {
                                            setState(() {
                                              widget.email["email"] =
                                                  emails[index]["email"];
                                              widget.email["id"] =
                                                  emails[index]["id"];

                                              selectedEmail = index;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 15, 15, 15),
                                          child: CustomText(
                                            emails[index]["email"],
                                            type: FontStyle.Small,
                                            color: themeProv.isDarkThemeEnabled
                                                ? darkSecondaryTextColor
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 2,
                                    width: double.infinity,
                                    color: themeProv.isDarkThemeEnabled
                                        ? darkThemeBorder
                                        : strokeColor,
                                  ),
                                ],
                              );
                      }),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
