class DateTimeManager {
  static List<String> monthList = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static int diffrenceInDays(
      {required String startDate, required String endDate}) {
    final DateTime now = DateTime.now().copyWith(hour: 0, minute: 0);

    final Duration difference = DateTime.parse(startDate).difference(now);
    int valueToReturn = difference.inDays;
    valueToReturn = valueToReturn < 0 ? valueToReturn - 1 : valueToReturn + 1;
    return valueToReturn;
  }

  static int getMonthFromDate({required String date}) {
    return DateTime.parse(date).month;
  }

  static int getDayFromDate({required String date}) {
    return DateTime.parse(date).day;
  }

  static String getMonthFromNumber(int value) {
    return monthList[value];
  }
}
