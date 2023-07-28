class DateTimeUtils {

  String getCurrentTimeInMilli() {
    int currentTimeInMillis = DateTime.now().millisecondsSinceEpoch;
    String hexString = currentTimeInMillis.toRadixString(16);
    String result = hexString.padLeft(4, '0').substring(hexString.length - 4);
    return result;
  }

}