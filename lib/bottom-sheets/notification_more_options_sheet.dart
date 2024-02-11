import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_divider.dart';
import 'package:plane/widgets/custom_text.dart';

class NotificationMoreOptionsSheet extends ConsumerStatefulWidget {
  const NotificationMoreOptionsSheet(this.selected, {super.key});
  final int selected;
  @override
  ConsumerState<NotificationMoreOptionsSheet> createState() =>
      _NotificationMoreOptionsSheetState();
}

class _NotificationMoreOptionsSheetState
    extends ConsumerState<NotificationMoreOptionsSheet> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final notificationProvider = ref.watch(ProviderList.notificationProvider);
    final options = [
      {
        'icon': Icons.messenger_outline,
        'text': 'Mark all as read',
        'onTap': () async {
          Navigator.pop(context);
          await notificationProvider.markAllAsRead(
            widget.selected == 0
                ? "assigned"
                : widget.selected == 1
                    ? "created"
                    : "watching",
          );
          widget.selected == 0
              ? await notificationProvider.getNotifications(type: 'assigned')
              : widget.selected == 1
                  ? await notificationProvider.getNotifications(type: 'created')
                  : await notificationProvider.getNotifications(
                      type: 'watching');
          await notificationProvider.getUnreadCount();
          await notificationProvider.getNotifications(
              type: 'unread', getUnread: true);
          await notificationProvider.getNotifications(
              type: '', getUnread: true);
        }
      },
    ];
    return Container(
      padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
      child: Column(
        children: [
          Row(
            children: [
              const CustomText('',
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
                padding: const EdgeInsets.symmetric(vertical: 5),
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
