import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/screens/MainScreens/Notification/extra_notification.dart';
import 'package:plane_startup/screens/MainScreens/Notification/notifications_list.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/widgets/custom_app_bar.dart';
import 'package:plane_startup/widgets/custom_text.dart';

class NotifiactionScreen extends ConsumerStatefulWidget {
  const NotifiactionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotifiactionScreenState();
}

class _NotifiactionScreenState extends ConsumerState<NotifiactionScreen> {
  PageController controller = PageController();
  int selected = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var notificationProvider = ref.watch(ProviderList.notificationProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Scaffold(
      appBar: CustomAppBar(
        onPressed: () {},
        text: "Notifications",
        centerTitle: false,
        leading: false,
        fontType: FontStyle.mainHeading,
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
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              //circle
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: themeProvider.isDarkThemeEnabled
                    ? darkSecondaryBackgroundSelectedColor
                    : lightSecondaryBackgroundSelectedColor,
              ),

              child: Icon(
                Icons.refresh,
                size: 20,
                color: themeProvider.isDarkThemeEnabled
                    ? darkPrimaryTextColor
                    : lightPrimaryTextColor,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ExtraNotifications(
                    title: 'Unread',
                    type: 'unread',
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              //circle
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: themeProvider.isDarkThemeEnabled
                    ? darkSecondaryBackgroundSelectedColor
                    : lightSecondaryBackgroundSelectedColor,
              ),

              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.notifications_outlined,
                      // color: greyColor,
                      size: 20,
                      color: themeProvider.isDarkThemeEnabled
                          ? darkPrimaryTextColor
                          : lightPrimaryTextColor,
                    ),
                  ),

                  //badge
                  notificationProvider.totalUnread > 0
                      ? Positioned(
                          top: 10,
                          right: 0,
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColor,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ExtraNotifications(
                    title: 'Snoozed',
                    type: 'snoozed',
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              //circle
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: themeProvider.isDarkThemeEnabled
                    ? darkSecondaryBackgroundSelectedColor
                    : lightSecondaryBackgroundSelectedColor,
              ),

              child: Icon(
                Icons.access_time_outlined,
                size: 20,
                color: themeProvider.isDarkThemeEnabled
                    ? darkPrimaryTextColor
                    : lightPrimaryTextColor,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ExtraNotifications(
                    title: 'Archived',
                    type: 'archived',
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              //circle
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: themeProvider.isDarkThemeEnabled
                    ? darkSecondaryBackgroundSelectedColor
                    : lightSecondaryBackgroundSelectedColor,
              ),

              child: Icon(
                Icons.archive_outlined,
                size: 20,
                color: themeProvider.isDarkThemeEnabled
                    ? darkPrimaryTextColor
                    : lightPrimaryTextColor,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            //bottom border
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: lightGreeyColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      controller.jumpToPage(0);
                    },
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: CustomText(
                                'My Issues',
                                color: selected == 0
                                    ? primaryColor
                                    : lightGreyTextColor,
                                type: FontStyle.secondaryText,
                              ),
                            ),
                            notificationProvider.getAssignedCount == 0
                                ? Container()
                                : Container(
                                    margin: const EdgeInsets.only(left: 5),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: CustomText(
                                      notificationProvider.getAssignedCount
                                          .toString(),
                                      color: Colors.white,
                                      type: FontStyle.smallText,
                                    ),
                                  )
                          ],
                        ),
                        selected == 0
                            ? Container(
                                height: 4,
                                color: primaryColor,
                              )
                            : Container(
                                height: 4,
                              )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      controller.jumpToPage(1);
                    },
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: CustomText(
                                'Created',
                                color: selected == 1
                                    ? primaryColor
                                    : lightGreyTextColor,
                                type: FontStyle.secondaryText,
                              ),
                            ),
                            notificationProvider.getCreatedCount == 0
                                ? Container()
                                : Container(
                                    margin: const EdgeInsets.only(left: 5),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: CustomText(
                                      notificationProvider.getCreatedCount
                                          .toString(),
                                      color: Colors.white,
                                      type: FontStyle.smallText,
                                    ),
                                  )
                          ],
                        ),
                        selected == 1
                            ? Container(
                                height: 4,
                                color: primaryColor,
                              )
                            : Container(
                                height: 4,
                              )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      controller.jumpToPage(2);
                    },
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: CustomText(
                                'Subscribed',
                                color: selected == 2
                                    ? primaryColor
                                    : lightGreyTextColor,
                                type: FontStyle.secondaryText,
                              ),
                            ),
                            notificationProvider.getWatchingCount == 0
                                ? Container()
                                : Container(
                                    margin: const EdgeInsets.only(left: 5),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: CustomText(
                                      notificationProvider.getWatchingCount
                                          .toString(),
                                      color: Colors.white,
                                      type: FontStyle.smallText,
                                    ),
                                  )
                          ],
                        ),
                        selected == 2
                            ? Container(
                                height: 4,
                                color: primaryColor,
                              )
                            : Container(
                                height: 4,
                              ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: controller,
              onPageChanged: (value) {
                setState(() {
                  selected = value;
                });
              },
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
