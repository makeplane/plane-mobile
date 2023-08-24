class StringManager {
  static String capitalizeFirstLetter(String value) {
    return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
  }
}
