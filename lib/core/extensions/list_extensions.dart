extension ListExtension on List? {
  bool isNullOrEmpty() {
    return this == null || this!.isEmpty;
  }

  bool isNotNullOrEmpty() {
    return !isNullOrEmpty();
  }

  String toQueryParam(String param) {
    if (this!.isEmpty) return '';
    return param +
        toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '');
  }
}
