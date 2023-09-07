import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/widgets/custom_text.dart';

import '../utils/enums.dart';

// ignore: must_be_immutable
class PermissionRoleSheet extends ConsumerStatefulWidget {
  PermissionRoleSheet({required this.data, super.key});
  Map data = {};
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PermissionRoleSheetState();
}

class _PermissionRoleSheetState extends ConsumerState<PermissionRoleSheet> {
  List<Role> roles = [
    Role.admin,
    Role.member,
    Role.guest,
    Role.viewer,
  ];

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 23, left: 23, right: 23),
      child: Wrap(
        children: [
          Row(
            children: [
              const CustomText(
                'Role',
                type: FontStyle.H4,
                fontWeight: FontWeightt.Semibold,
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  size: 27,
                  color: themeProvider.themeManager.placeholderTextColor,
                ),
              ),
            ],
          ),
          ListView.builder(
            itemBuilder: (ctx, index) {
              return Column(
                children: [
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          widget.data['role'] = roles[index];
                        });

                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Radio(
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              fillColor: widget.data['role'] == roles[index]
                                  ? null
                                  : MaterialStateProperty.all<Color>(
                                      themeProvider
                                          .themeManager.borderSubtle01Color),
                              groupValue: widget.data['role'],
                              activeColor:
                                  themeProvider.themeManager.primaryColour,
                              value: roles[index],
                              onChanged: (val) {
                                // profileProvider.changeIndex(0);
                              }),
                          const SizedBox(width: 10),
                          CustomText(
                            roles[index].name.toUpperCase()[0] +
                                roles[index].name.substring(1).toLowerCase(),
                            type: FontStyle.H5,
                            color: themeProvider.themeManager.tertiaryTextColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 1,
                    width: double.infinity,
                    child: Container(
                      color: themeProvider.themeManager.borderDisabledColor,
                    ),
                  ),
                ],
              );
            },
            itemCount: roles.length,
            shrinkWrap: true,
          ),
          const SizedBox(
            height: 50,
            width: double.infinity,
          ),
          GestureDetector(
            onTap: () {
              widget.data['role'] = Role.none;
              Navigator.pop(context);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              alignment: Alignment.center,
              child: CustomText('Remove',
                  type: FontStyle.H5,
                  fontWeight: FontWeightt.Medium,
                  color: themeProvider.themeManager.textErrorColor),
            ),
          )
        ],
      ),
    );
  }
}
