String formatDate(DateTime dateTime) {
  return dateTime.toString().split('.').first; // Removes the milliseconds part
}
