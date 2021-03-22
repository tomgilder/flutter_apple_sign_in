package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import dev.gilder.tom.apple_sign_in.AppleSignInPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    AppleSignInPlugin.registerWith(registry.registrarFor("dev.gilder.tom.apple_sign_in.AppleSignInPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
