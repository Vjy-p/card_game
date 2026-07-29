import 'package:card_game/core/responsive/app_breakpoint.dart';

T responsiveValue<T>({
  required double width,
  required T smallPhone,
  required T phone,
  T? largePhone,
  T? tablet,
  T? desktop,
}) {
  return switch (AppBreakpoint.fromWidth(width)) {
    AppBreakpoint.smallPhone => smallPhone,
    AppBreakpoint.phone => phone,
    AppBreakpoint.largePhone => largePhone ?? phone,
    AppBreakpoint.tablet => tablet ?? largePhone ?? phone,
    AppBreakpoint.desktop => desktop ?? tablet ?? largePhone ?? phone,
  };
}
