package com.berkaycatak.adaptive_platform_ui;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;

/** AdaptivePlatformUiPlugin */
public class AdaptivePlatformUiPlugin implements FlutterPlugin {
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    // Android uses Material Design widgets directly in Dart
    // No platform views needed for Android
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
  }
}
