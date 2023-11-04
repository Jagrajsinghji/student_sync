extension AppString on String {
  bool isEmail() => RegExp(
        r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)*(\.[a-z]{2,4})$',
        caseSensitive: false,
        multiLine: false,
      ).hasMatch(this);

  bool isCanadianPhoneNumber() => RegExp(
        r'^(\(\+[0-9]{2}\))?([0-9]{3}-?)?([0-9]{3})\-?([0-9]{4})(\/[0-9]{4})?$',
      ).hasMatch(this);

  bool isCanadianPostalCode() => RegExp(
          r'^[ABCEGHJ-NPRSTVXY]\d[ABCEGHJ-NPRSTV-Z][ -]?\d[ABCEGHJ-NPRSTV-Z]\d$',
          caseSensitive: false)
      .hasMatch(this);
}
