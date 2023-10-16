import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/widgets/custom_text.dart';

import '../utils/enums.dart';

class CompanySize extends ConsumerStatefulWidget {
  const CompanySize({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CompanySizeState();
}

class _CompanySizeState extends ConsumerState<CompanySize> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 23, left: 23, right: 23),
      child: Column(
        children: [
          Row(
            children: [
              CustomText(
                'Company Size',
                type: FontStyle.H4,
                fontWeight: FontWeightt.Semibold,
                color: themeProvider.themeManager.primaryTextColor,
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
          SizedBox(
            height: 50,
            width: double.infinity,
            child: InkWell(
              onTap: () {
                workspaceProvider.changeCompanySize(size: 'Just myself');
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Radio(
                      visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      fillColor: workspaceProvider.companySize == 'Just myself'
                          ? null
                          : MaterialStateProperty.all<Color>(
                              themeProvider.themeManager.borderSubtle01Color),
                      groupValue: workspaceProvider.companySize,
                      activeColor: themeProvider.themeManager.primaryColour,
                      value: 'Just myself',
                      onChanged: (val) {
                        workspaceProvider.changeCompanySize(
                            size: 'Just myself');
                        Navigator.pop(context);
                      }),
                  const SizedBox(width: 10),
                  CustomText(
                    'Just myself',
                    type: FontStyle.Medium,
                    fontWeight: FontWeightt.Regular,
                    color: themeProvider.themeManager.primaryTextColor,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: themeProvider.themeManager.borderDisabledColor,
          ),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: InkWell(
              onTap: () {
                workspaceProvider.changeCompanySize(size: '2-10');
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Radio(
                      visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      fillColor: workspaceProvider.companySize == '2-10'
                          ? null
                          : MaterialStateProperty.all<Color>(
                              themeProvider.themeManager.borderSubtle01Color),
                      groupValue: workspaceProvider.companySize,
                      activeColor: themeProvider.themeManager.primaryColour,
                      value: '2-10',
                      onChanged: (val) {
                        workspaceProvider.changeCompanySize(size: '2-10');
                        Navigator.pop(context);
                      }),
                  const SizedBox(width: 10),
                  CustomText(
                    '2-10',
                    type: FontStyle.Medium,
                    fontWeight: FontWeightt.Regular,
                    color: themeProvider.themeManager.primaryTextColor,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: themeProvider.themeManager.borderDisabledColor,
          ),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: InkWell(
              onTap: () {
                workspaceProvider.changeCompanySize(size: '11-50');
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Radio(
                      visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      fillColor: workspaceProvider.companySize == '11-50'
                          ? null
                          : MaterialStateProperty.all<Color>(
                              themeProvider.themeManager.borderSubtle01Color),
                      groupValue: workspaceProvider.companySize,
                      activeColor: themeProvider.themeManager.primaryColour,
                      value: '11-50',
                      onChanged: (val) {
                        workspaceProvider.changeCompanySize(size: '11-50');
                        Navigator.pop(context);
                      }),
                  const SizedBox(width: 10),
                  CustomText(
                    '11-50',
                    type: FontStyle.Medium,
                    fontWeight: FontWeightt.Regular,
                    color: themeProvider.themeManager.primaryTextColor,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: themeProvider.themeManager.borderDisabledColor,
          ),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: InkWell(
              onTap: () {
                workspaceProvider.changeCompanySize(size: '51-200');
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Radio(
                      visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      fillColor: workspaceProvider.companySize == '51-200'
                          ? null
                          : MaterialStateProperty.all<Color>(
                              themeProvider.themeManager.borderSubtle01Color),
                      groupValue: workspaceProvider.companySize,
                      activeColor: themeProvider.themeManager.primaryColour,
                      value: '51-200',
                      onChanged: (val) {
                        workspaceProvider.changeCompanySize(size: '51-200');
                        Navigator.pop(context);
                      }),
                  const SizedBox(width: 10),
                  CustomText(
                    '51-200',
                    type: FontStyle.Medium,
                    fontWeight: FontWeightt.Regular,
                    color: themeProvider.themeManager.primaryTextColor,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: themeProvider.themeManager.borderDisabledColor,
          ),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: InkWell(
              onTap: () {
                workspaceProvider.changeCompanySize(size: '201-500');
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Radio(
                      visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      fillColor: workspaceProvider.companySize == '201-500'
                          ? null
                          : MaterialStateProperty.all<Color>(
                              themeProvider.themeManager.borderSubtle01Color),
                      groupValue: workspaceProvider.companySize,
                      activeColor: themeProvider.themeManager.primaryColour,
                      value: '201-500',
                      onChanged: (val) {
                        workspaceProvider.changeCompanySize(size: '201-500');
                        Navigator.pop(context);
                      }),
                  const SizedBox(width: 10),
                  CustomText(
                    '201-500',
                    type: FontStyle.Medium,
                    fontWeight: FontWeightt.Regular,
                    color: themeProvider.themeManager.primaryTextColor,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: themeProvider.themeManager.borderDisabledColor,
          ),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: InkWell(
              onTap: () {
                workspaceProvider.changeCompanySize(size: '500+');
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Radio(
                      visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      fillColor: workspaceProvider.companySize == '500+'
                          ? null
                          : MaterialStateProperty.all<Color>(
                              themeProvider.themeManager.borderSubtle01Color),
                      groupValue: workspaceProvider.companySize,
                      activeColor: themeProvider.themeManager.primaryColour,
                      value: '500+',
                      onChanged: (val) {
                        workspaceProvider.changeCompanySize(size: '500+');
                        Navigator.pop(context);
                      }),
                  const SizedBox(width: 10),
                  CustomText(
                    '500+',
                    type: FontStyle.Medium,
                    fontWeight: FontWeightt.Regular,
                    color: themeProvider.themeManager.primaryTextColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
