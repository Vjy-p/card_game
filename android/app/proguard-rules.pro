# Card Game - R8 / ProGuard rules
#
# Most Flutter plugins already provide their own consumer R8 rules.
# Avoid broad "-keep class ** { *; }" rules because they reduce shrinking
# and obfuscation effectiveness.

# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Google Sign-In / Google Play Services
-keep class com.google.android.gms.auth.api.signin.** { *; }
-keep class com.google.android.gms.common.** { *; }

# Firebase
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes Exceptions
-keep class com.google.firebase.** { *; }

# Google Mobile Ads / AdMob
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.android.gms.internal.ads.** { *; }

# Razorpay
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Kotlin metadata / annotations used by libraries
-keepattributes RuntimeVisibleAnnotations,RuntimeInvisibleAnnotations
-keepattributes RuntimeVisibleParameterAnnotations,RuntimeInvisibleParameterAnnotations
-keep class kotlin.Metadata { *; }

# If your custom NativeAdFactory is instantiated by class name,
# keep the exact class. Example:
# -keep class com.your.package.YourNativeAdFactory { *; }

# Avoid broad -dontwarn rules. Add them only for specific R8 warnings
# after confirming the dependency is optional.
