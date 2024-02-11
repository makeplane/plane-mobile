import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/notifications/extra_notification.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_divider.dart';
import 'package:plane/widgets/custom_text.dart';

class NotificationFilterSheet extends ConsumerStatefulWidget {
  const NotificationFilterSheet({super.key});

  @override
  ConsumerState<NotificationFilterSheet> createState() =>
      _NotificationFilterSheetState();
}

class _NotificationFilterSheetState
    extends ConsumerState<NotificationFilterSheet> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final options = [
      {
        'icon': Icons.menu,
        'text': 'Show Unread',
        'onTap': () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ExtraNotifications(
                title: 'Unread',
                type: 'unread',
              ),
            ),
          );
        }
      },
      {
        'icon': Icons.access_time_outlined,
        'text': 'Show Snoozed',
        'onTap': () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ExtraNotifications(
                title: 'Snoozed',
                type: 'snoozed',
              ),
            ),
          );
        }
      },
      {
        'icon': Icons.archive_outlined,
        'text': 'Show Archived',
        'onTap': () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ExtraNotifications(
                title: 'Archived',
                type: 'archived',
              ),
            ),
          );
        }
      }
    ];
    return Container(
      padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
      child: Column(
        children: [
          Row(
            children: [
              const CustomText('Filter Notifications',
                  type: FontStyle.H4, fontWeight: FontWeightt.Semibold),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  size: 27,
                  color: themeProvider.themeManager.placeholderTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          ListView.separated(
            separatorBuilder: (context, index) => const CustomDivider(
              margin: EdgeInsets.only(top: 5, bottom: 5),
            ),
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (context, index) => InkWell(
              onTap: options[index]['onTap'] as void Function(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Icon(
                      options[index]['icon'] as IconData,
                      color: themeProvider.themeManager.placeholderTextColor,
                    ),
                    const SizedBox(width: 10),
                    CustomText(
                      options[index]['text'] as String,
                      type: FontStyle.H6,
                      color: themeProvider.themeManager.tertiaryTextColor,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
