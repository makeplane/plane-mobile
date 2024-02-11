import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/notifications/notifications_list.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_app_bar.dart';
import 'package:plane/widgets/loading_widget.dart';

class ExtraNotifications extends ConsumerStatefulWidget {
  const ExtraNotifications({
    super.key,
    required this.title,
    required this.type,
  });

  final String title;
  final String type;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ExtraNotificationsState();
}

class _ExtraNotificationsState extends ConsumerState<ExtraNotifications> {
  @override
  Widget build(BuildContext context) {
    final notificationProvider = ref.watch(ProviderList.notificationProvider);

    return Scaffold(
      appBar: CustomAppBar(
        onPressed: () {
          Navigator.pop(context);
        },
        text: widget.title,
        centerTitle: true,
      ),
      body: LoadingWidget(
        loading: widget.type == 'archived'
            ? notificationProvider.getArchivedState == DataState.loading
            : widget.type == 'snoozed'
                ? notificationProvider.getSnoozedState == DataState.loading
                : notificationProvider.getUnreadState == DataState.loading,
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
