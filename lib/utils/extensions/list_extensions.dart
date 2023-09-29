extension ListExtension on List? {
  bool isNullOrEmpty() {
    final List? data = this;
    if (data == null) {
      return true;
    } else if (data.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool isNotNullOrEmpty() {
    final List? data = this;
    return !data.isNullOrEmpty();
  }
}
