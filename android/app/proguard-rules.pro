# Keep kotlinx.parcelize
-keep class kotlinx.parcelize.** { *; }

# Keep SLF4J Logger classes
-keep class org.slf4j.** { *; }

# Keep Giphy SDK Analytics models
-keep class com.giphy.sdk.analytics.models.** { *; }

-dontwarn kotlinx.parcelize.Parcelize
-dontwarn org.slf4j.impl.StaticLoggerBinder
-dontwarn com.stripe.**
