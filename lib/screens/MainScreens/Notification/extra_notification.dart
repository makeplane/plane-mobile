import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/MainScreens/Notification/notifications_list.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_app_bar.dart';
import 'package:plane/widgets/loading_widget.dart';

class ExtraNotifications extends ConsumerStatefulWidget {
  final String title;
  final String type;
  const ExtraNotifications({
    super.key,
    required this.title,
    required this.type,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ExtraNotificationsState();
}

class _ExtraNotificationsState extends ConsumerState<ExtraNotifications> {
  @override
  Widget build(BuildContext context) {
    var notificationProvider = ref.watch(ProviderList.notificationProvider);

    return Scaffold(
      appBar: CustomAppBar(
        onPressed: () {
          Navigator.pop(context);
        },
        text: widget.title,
        centerTitle: true,
        // leading: false,
        fontType: FontStyle.Small,
      ),
      body: LoadingWidget(
        loading: widget.type == 'archived'
            ? notificationProvider.getArchivedState == StateEnum.loading
            : widget.type == 'snoozed'
                ? notificationProvider.getSnoozedState == StateEnum.loading
                : notificationProvider.getUnreadState == StateEnum.loading,
        widgetClass: NotificationsList(
          data: widget.type == 'archived'
              ? notificationProvider.archived
              : widget.type == 'snoozed'
                  ? notificationProvider.snoozed
                  : notificationProvider.unread,
          type: widget.type,
        ),
      ),
    );
  }
}
