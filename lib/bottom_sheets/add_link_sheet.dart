import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/modules_provider.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/widgets/custom_text.dart';

import '../mixins/widget_state_mixin.dart';

class AddLinkSheet extends ConsumerStatefulWidget {
  const AddLinkSheet({super.key});

  @override
  ConsumerState<AddLinkSheet> createState() => _AddLinkSheetState();
}

class _AddLinkSheetState extends ConsumerState<AddLinkSheet> with WidgetState {
  TextEditingController title = TextEditingController();
  TextEditingController url = TextEditingController();

  @override
  getLoading(WidgetRef ref) {
    return setWidgetState(
        [ref.read(ProviderList.modulesProvider).moduleLinkState],
        loadingType: LoadingType.wrap);
  }

  @override
  Widget render(BuildContext context) {
    var themeProvider = ref.read(ProviderList.themeProvider);
    ModuleProvider moduleProvider = ref.watch(ProviderList.modulesProvider);
    return Container(
    
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: themeProvider.themeManager.secondaryBackgroundDefaultColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText('Add Link',
                      type: FontStyle.H4,
                      fontWeight: FontWeightt.Semibold,
                      color: themeProvider.themeManager.primaryTextColor),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.close,
                        color: themeProvider.themeManager.placeholderTextColor,
                      ))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              CustomText(
                'Title',
                type: FontStyle.Medium,
                fontWeight: FontWeightt.Regular,
                color: themeProvider.themeManager.primaryTextColor,
                // color: themeProvider.secondaryTextColor,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: title,
                decoration: themeProvider.themeManager.textFieldDecoration,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomText(
                'URL',
                type: FontStyle.Medium,
                fontWeight: FontWeightt.Regular,
                color: themeProvider.themeManager.primaryTextColor,
                // color: themeProvider.secondaryTextColor,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: url,
                decoration: themeProvider.themeManager.textFieldDecoration,
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Button(
            text: 'Add Link',
            ontap: () {
              moduleProvider.handleLinks(data: {
                'title': title.text,
                'url': url.text,
              }, method: HttpMethod.post, context: context);
            },
          )
        ],
      ),
    );
  }
}
