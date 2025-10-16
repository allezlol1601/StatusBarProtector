# Règles ProGuard pour le module Xposed

# Conserver les classes du hook Xposed
-keep class com.statusbar.protector.** { *; }

# Conserver les interfaces Xposed
-keep class de.robv.android.xposed.** { *; }

# Ne pas optimiser les hooks Xposed
-dontoptimize
-dontobfuscate

# Conserver les attributs des annotations
-keepattributes *Annotation*
