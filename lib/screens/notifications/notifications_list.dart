import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:plane/bottom-sheets/snooze_time_sheet.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/project/issues/issue_detail.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_rich_text.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/empty.dart';
import 'package:plane/widgets/error_state.dart';
import 'package:plane/widgets/loading_widget.dart';

class NotificationsList extends ConsumerStatefulWidget {
  const NotificationsList({super.key, required this.data, required this.type});
  final List<dynamic> data;
  final String type;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationsListState();
}

class _NotificationsListState extends ConsumerState<NotificationsList> {
  String checkTimeDifferenc(String dateTime) {
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(DateTime.parse(dateTime));
    String? format;

    if (difference.inDays > 0) {
      format = '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      format = '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      format = '${difference.inMinutes} minutes ago';
    } else {
      format = '${difference.inSeconds} seconds ago';
    }

    return format;
  }

  @override
  Widget build(BuildContext context) {
    // log('Notification List Build ${widget.data.toString()}');
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final notificationProvider = ref.watch(ProviderList.notificationProvider);
    return LoadingWidget(
      loading: widget.type == 'created'
          ? notificationProvider.getCreatedState == DataState.loading
          : widget.type == 'assigned'
              ? notificationProvider.getAssignedState == DataState.loading
              : widget.type == 'watching'
                  ? notificationProvider.getWatchingState == DataState.loading
                  : false,
      widgetClass:
          // notificationProvider.getCreatedState == StateEnum.error ||
          // notificationProvider.getAssignedState == StateEnum.error ||
          // notificationProvider.getArchivedState == StateEnum.error ?
          // errorState(context: context, showButton: false) :
          widget.type == 'assigned' &&
                  notificationProvider.getAssignedState == DataState.error
              ? errorState(
                  context: context,
                )
              : widget.type == 'created' &&
                      notificationProvider.getCreatedState == DataState.error
                  ? errorState(
                      context: context,
                    )
                  : widget.type == 'watching' &&
                          notificationProvider.getWatchingState ==
                              DataState.error
                      ? errorState(
                          context: context,
                        )
                      : widget.data.isEmpty
                          ? EmptyPlaceholder.emptyNotification(ref)
                          : ListView.builder(
                              itemCount: widget.data.length,
                              itemBuilder: (context, index) {
                                bool isUnread = false;
                                for (final element
                                    in notificationProvider.unread) {
                                  if (element['id'] ==
                                      widget.data[index]['id']) {
                                    isUnread = true;
                                  }
                                }
                                return GestureDetector(
                                  onTap: () {
                                    notificationProvider.markAsRead(
                                        widget.data[index]['id'].toString());

                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const IssueDetail(),
                                      ),
                                    );
                                  },
                                  child: Slidable(
                                    endActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: ((context) {
                                            //open bottom sheet
                                            showModalBottomSheet(
                                                isScrollControlled: true,
                                                enableDrag: true,
                                                constraints:
                                                    const BoxConstraints(
                                                        maxHeight: 500),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                  topLeft: Radius.circular(30),
                                                  topRight: Radius.circular(30),
                                                )),
                                                context: context,
                                                builder: (ctx) {
                                                  return const SnoozeTimeSheet();
                                                }).then((_) {
                                              notificationProvider.updateSnooze(
                                                  widget.data[index]['id']
                                                      .toString());
                                            });
                                          }),
                                          icon: Icons.snooze_outlined,
                                          foregroundColor: themeProvider
                                              .themeManager
                                              .placeholderTextColor,
                                          backgroundColor: themeProvider
                                              .themeManager
                                              .secondaryBackgroundDefaultColor,
                                        ),
                                        SlidableAction(
                                          onPressed: ((context) {
                                            notificationProvider
                                                .archiveNotification(
                                              widget.data[index]['id']
                                                  .toString(),
                                              widget.type == 'archived'
                                                  ? HttpMethod.delete
                                                  : HttpMethod.post,
                                            );
                                          }),
                                          icon: widget.type == 'archived'
                                              ? Icons.unarchive_outlined
                                              : Icons.archive_outlined,
                                          foregroundColor: themeProvider
                                              .themeManager
                                              .placeholderTextColor,
                                          backgroundColor:
                                              Colors.red.withOpacity(0.1),
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      color: isUnread
                                          ? themeProvider
                                              .themeManager.primaryColour
                                              .withOpacity(0.1)
                                          : Colors.transparent,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 15),
                                            child:
                                                // widget.data[index]['data']['issue_activity']['field'] ==
                                                //         null
                                                //     ?
                                                SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 16,
                                                    backgroundColor:
                                                        themeProvider
                                                            .themeManager
                                                            .borderSubtle01Color,
                                                    child: CircleAvatar(
                                                      backgroundColor: themeProvider
                                                          .themeManager
                                                          .tertiaryBackgroundDefaultColor,
                                                      radius: 15,
                                                      child: Center(
                                                        child: widget.data[index]
                                                                            [
                                                                            'data']
                                                                        [
                                                                        'issue_activity']
                                                                    [
                                                                    'new_value'] ==
                                                                'archive'
                                                            ? Icon(
                                                                Icons
                                                                    .archive_outlined,
                                                                color: themeProvider
                                                                    .themeManager
                                                                    .secondaryTextColor,
                                                                size: 18,
                                                              )
                                                            : CustomText(
                                                                widget
                                                                    .data[index]
                                                                        [
                                                                        'triggered_by_details']
                                                                        [
                                                                        'first_name']
                                                                        [0]
                                                                    .toString()
                                                                    .toUpperCase(),
                                                                // color: Colors.black,
                                                                type: FontStyle
                                                                    .Small,

                                                                fontWeight:
                                                                    FontWeightt
                                                                        .Bold,
                                                              ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  SizedBox(
                                                    width: width * 0.75,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width: width * 0.75,
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: widget.data[index]['data']['issue_activity']
                                                                            [
                                                                            'new_value'] ==
                                                                        'archive'
                                                                    ? CustomText(
                                                                        widget
                                                                            .data[index]['title']
                                                                            .toString(),
                                                                        fontSize:
                                                                            16,
                                                                        color: themeProvider
                                                                            .themeManager
                                                                            .primaryTextColor,
                                                                      )
                                                                    : CustomRichText(
                                                                        // '${widget.data[index]['triggered_by_details']['first_name']} ${widget.data[index]['triggered_by_details']['last_name']}',

                                                                        type: FontStyle
                                                                            .Small,

                                                                        widgets: [
                                                                          TextSpan(
                                                                            text:
                                                                                '${widget.data[index]['triggered_by_details']['display_name']}',
                                                                            style:
                                                                                TextStyle(
                                                                              color: themeProvider.themeManager.primaryTextColor,
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                          TextSpan(
                                                                            text: widget.data[index]['data']['issue_activity']['field'] == 'description'
                                                                                ? ' ${widget.data[index]['title'].replaceAll('${widget.data[index]['triggered_by_details']['email']}', '').replaceAll('${widget.data[index]['data']['issue_activity']['new_value']}', '').toString().replaceAll('to', '')}'
                                                                                : ' ${widget.data[index]['title'].replaceAll('${widget.data[index]['triggered_by_details']['email']}', '').replaceAll('${widget.data[index]['data']['issue_activity']['new_value']}', '')}',
                                                                            style:
                                                                                TextStyle(
                                                                              color: themeProvider.themeManager.primaryTextColor,
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                          ),
                                                                          TextSpan(
                                                                            text: widget.data[index]['data']['issue_activity']['field'] == 'description'
                                                                                ? ''
                                                                                : widget.data[index]['data']['issue_activity']['field'] == 'None'
                                                                                    ? 'and assigned it to you'
                                                                                    : widget.data[index]['data']['issue_activity']['field'] == 'attachment'
                                                                                        ? 'to the issue'
                                                                                        : widget.data[index]['data']['issue_activity']['new_value'].toString(),
                                                                            style:
                                                                                TextStyle(
                                                                              color: themeProvider.themeManager.primaryTextColor,
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        maxLines:
                                                                            2,
                                                                      ),
                                                              ),
                                                              // Expanded(
                                                              //   child: CustomText(
                                                              //     '${widget.data[index]['title'].replaceAll('${widget.data[index]['triggered_by_details']['email']}', '')}.',
                                                              //     // fontSize: 14,
                                                              //     type: FontStyle.Small,
                                                              //     textAlign: TextAlign.left,
                                                              //     maxLines: 4,
                                                              //   ),
                                                              // ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 6),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                                  width * 0.40,
                                                              child: CustomText(
                                                                '${widget.data[index]['data']['issue']['identifier']} - ${widget.data[index]['data']['issue']['sequence_id']}  ${widget.data[index]['data']['issue']['name']}',
                                                                type: FontStyle
                                                                    .Small,
                                                                color: themeProvider
                                                                    .themeManager
                                                                    .placeholderTextColor,
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              // width: width * 0.35,
                                                              child: Row(
                                                                children: [
                                                                  widget.data[index]
                                                                              [
                                                                              'snoozed_till'] ==
                                                                          null
                                                                      ? Container()
                                                                      : Icon(
                                                                          Icons
                                                                              .snooze_outlined,
                                                                          size:
                                                                              15,
                                                                          color: themeProvider
                                                                              .themeManager
                                                                              .placeholderTextColor),
                                                                  widget.data[index]
                                                                              [
                                                                              'snoozed_till'] ==
                                                                          null
                                                                      ? Container()
                                                                      : const SizedBox(
                                                                          width:
                                                                              5),
                                                                  CustomText(
                                                                    widget.data[index]['snoozed_till'] ==
                                                                            null
                                                                        ? checkTimeDifferenc(widget.data[index]
                                                                            [
                                                                            'created_at'])
                                                                        :

                                                                        //snoozed till 14 Aug, 10:41 AM
                                                                        DateFormat('dd MMM, hh:mm a').format(DateTime.parse(widget.data[index]
                                                                            [
                                                                            'snoozed_till'])),
                                                                    color: themeProvider
                                                                        .themeManager
                                                                        .placeholderTextColor,
                                                                    type: FontStyle
                                                                        .Small,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 1,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                              height: 1,
                                              width: width,
                                              color: themeProvider.themeManager
                                                  .borderSubtle01Color)
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
    );
  }
}
