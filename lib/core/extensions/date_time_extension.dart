extension DateTimeEx on DateTime {
  String toStringEx() {
    return this.toString().split(".")[0];
  }
}