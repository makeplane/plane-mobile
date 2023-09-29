import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plane/bottom_sheets/notification_filter_sheet.dart';
import 'package:plane/bottom_sheets/notification_more_options_sheet.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/MainScreens/Notification/notifications_list.dart';
import 'package:plane/widgets/custom_app_bar.dart';
import 'package:plane/widgets/custom_text.dart';
import '/utils/enums.dart';

class NotifiactionScreen extends ConsumerStatefulWidget {
  const NotifiactionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotifiactionScreenState();
}

class _NotifiactionScreenState extends ConsumerState<NotifiactionScreen>
    with TickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = ref.watch(ProviderList.notificationProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);

    return Scaffold(
      appBar: CustomAppBar(
        onPressed: () {},
        text: "Notifications",
        centerTitle: false,
        leading: false,
        fontType: FontStyle.H4,
        elevation: false,
        actions: [
          GestureDetector(
            onTap: () {
              notificationProvider.getNotifications(type: 'assigned');
              notificationProvider.getNotifications(type: 'created');
              notificationProvider.getNotifications(type: 'watching');
              notificationProvider.getUnreadCount();
              notificationProvider.getNotifications(
                  type: 'unread', getUnread: true);
            },
            child: CircleAvatar(
              radius: 20,
              backgroundColor:
                  themeProvider.themeManager.primaryBackgroundSelectedColour,
              child: Icon(
                Icons.refresh,
                size: 20,
                color: themeProvider.themeManager.secondaryTextColor,
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                enableDrag: true,
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )),
                context: context,
                builder: (context) => const NotificationFilterSheet(),
              );
            },
            child: CircleAvatar(
              radius: 20,
              backgroundColor:
                  themeProvider.themeManager.primaryBackgroundSelectedColour,
              child: Center(
                child: Icon(
                  Icons.filter_list_outlined,
                  size: 20,
                  color: themeProvider.themeManager.secondaryTextColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              log(controller.index.toString());
              showModalBottomSheet(
                isScrollControlled: true,
                enableDrag: true,
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.2),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )),
                context: context,
                builder: (context) =>
                    NotificationMoreOptionsSheet(controller.index),
              );
            },
            child: CircleAvatar(
              radius: 20,
              backgroundColor:
                  themeProvider.themeManager.primaryBackgroundSelectedColour,
              child: Center(
                child: Icon(
                  Icons.more_vert_outlined,
                  size: 20,
                  color: themeProvider.themeManager.secondaryTextColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          TabBar(
              controller: controller,
              indicatorColor: themeProvider.themeManager.primaryColour,
              indicatorWeight: 6,
              indicatorPadding: const EdgeInsets.only(top: 46),
              indicator: BoxDecoration(
                  color: themeProvider.themeManager.primaryColour,
                  borderRadius: BorderRadius.circular(6)),
              unselectedLabelStyle: GoogleFonts.inter(
                  letterSpacing: -(fontSIZE[FontStyle.Medium]! * 0.02),
                  height: lineHeight[FontStyle.Medium],
                  fontSize: fontSIZE[FontStyle.Medium],
                  color: themeProvider.themeManager.placeholderTextColor),
              labelStyle: GoogleFonts.inter(
                  letterSpacing: -(fontSIZE[FontStyle.Medium]! * 0.02),
                  height: lineHeight[FontStyle.Medium],
                  fontSize: fontSIZE[FontStyle.Medium],
                  fontWeight: FontWeight.w500,
                  color: themeProvider.themeManager.primaryColour),
              unselectedLabelColor:
                  themeProvider.themeManager.placeholderTextColor,
              labelColor: themeProvider.themeManager.primaryColour,
              tabs: const [
                Tab(
                  text: 'My Issues',
                ),
                Tab(
                  text: 'Created',
                ),
                Tab(
                  text: 'Subscribed',
                ),
              ]),
          Container(
            color: themeProvider.themeManager.borderSubtle01Color,
            height: 1,
          ),
          Expanded(
            child: TabBarView(
              controller: controller,
              children: [
                NotificationsList(
                  type: 'assigned',
                  data: ref.read(ProviderList.notificationProvider).assigned,
                ),
                NotificationsList(
                  type: 'created',
                  data: ref.read(ProviderList.notificationProvider).created,
                ),
                NotificationsList(
                  type: 'watching',
                  data: ref.read(ProviderList.notificationProvider).watching,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
