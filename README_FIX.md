# ERFAN OXIGEN - Flutter

این نسخه برای Flutter جدید آماده شده و ساختار قدیمی `app_plugin_loader.gradle` در آن استفاده نمی‌شود.

## اجرا در ویندوز

1. این ZIP را کامل Extract کنید.
2. PowerShell/CMD را در پوشه پروژه باز کنید.
3. مطمئن شوید:
   `flutter --version`
   کار می‌کند.
4. فایل `SETUP_ANDROID.bat` را اجرا کنید.

اسکریپت:
- Android project استاندارد Flutter را می‌سازد.
- Gradle Plugin DSL جدید را اعمال می‌کند.
- AndroidX را فعال می‌کند.
- پکیج‌ها را دریافت می‌کند.
- سپس برنامه را اجرا می‌کند.

## اجرای دستی

```powershell
flutter create --platforms=android .
flutter clean
flutter pub get
flutter run
```

تنظیمات Gradle اصلاح‌شده داخل `_android_fixed` قرار دارد و ظاهر و فایل‌های Dart برنامه تغییر نکرده‌اند.
