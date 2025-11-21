# Flutter & plugin entry points
-keep class io.flutter.app.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.view.** { *; }

# Keep generated accessors and prevent stripping of annotations
-keep class androidx.annotation.Keep
-keep @androidx.annotation.Keep class * { *; }

# SafeDevice plugin
-keep class com.baseflow.safe_device.** { *; }
-dontwarn com.baseflow.safe_device.**

# Preserve Serializable implementations
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    !static !transient <fields>;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}
