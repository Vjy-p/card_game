enum AppBreakpoint {
  smallPhone,
  phone,
  largePhone,
  tablet,
  desktop;

  static AppBreakpoint fromWidth(double width) {
    if (width < 360) {
      return AppBreakpoint.smallPhone;
    }

    if (width < 600) {
      return AppBreakpoint.phone;
    }

    if (width < 840) {
      return AppBreakpoint.largePhone;
    }

    if (width < 1200) {
      return AppBreakpoint.tablet;
    }

    return AppBreakpoint.desktop;
  }
}
