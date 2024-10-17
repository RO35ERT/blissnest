String formatDate(String dateString) {
  DateTime parsedDate = DateTime.parse(dateString);
  return parsedDate
      .toString()
      .split('.')
      .first; // Removes the milliseconds part
}
