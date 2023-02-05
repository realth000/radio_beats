import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  /// App light theme.
  static final light = FlexThemeData.light(
    scheme: FlexScheme.purpleBrown,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 20,
    tabBarStyle: FlexTabBarStyle.forBackground,
    tooltipsMatchBackground: true,
    subThemesData: const FlexSubThemesData(
      thickBorderWidth: 1.5,
      defaultRadius: 26,
      inputDecoratorIsFilled: false,
      inputDecoratorBorderType: FlexInputBorderType.underline,
      fabUseShape: true,
      popupMenuOpacity: 0.98,
      dialogBackgroundSchemeColor: SchemeColor.inversePrimary,
      bottomNavigationBarShowUnselectedLabels: false,
      navigationBarMutedUnselectedLabel: false,
      navigationBarMutedUnselectedIcon: false,
      navigationBarHeight: 63,
      navigationBarLabelBehavior:
          NavigationDestinationLabelBehavior.onlyShowSelected,
      navigationRailMutedUnselectedLabel: false,
      navigationRailMutedUnselectedIcon: false,
      navigationRailOpacity: 0.99,
    ),
    keyColors: const FlexKeyColors(
      useSecondary: true,
      useTertiary: true,
      keepSecondary: true,
      keepPrimaryContainer: true,
      keepSecondaryContainer: true,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
    // To use the playground font, add GoogleFonts package and uncomment
    // fontFamily: GoogleFonts.notoSans().fontFamily,
  );

  /// App dark theme.
  static final dark = FlexThemeData.dark(
    scheme: FlexScheme.purpleBrown,
    surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
    blendLevel: 19,
    appBarOpacity: 0.98,
    tabBarStyle: FlexTabBarStyle.forBackground,
    tooltipsMatchBackground: true,
    subThemesData: const FlexSubThemesData(
      defaultRadius: 26,
      thickBorderWidth: 1.5,
      inputDecoratorIsFilled: false,
      inputDecoratorBorderType: FlexInputBorderType.underline,
      fabUseShape: true,
      popupMenuOpacity: 0.98,
      dialogBackgroundSchemeColor: SchemeColor.inversePrimary,
      bottomNavigationBarShowUnselectedLabels: false,
      navigationBarMutedUnselectedLabel: false,
      navigationBarMutedUnselectedIcon: false,
      navigationBarHeight: 63,
      navigationBarLabelBehavior:
          NavigationDestinationLabelBehavior.onlyShowSelected,
      navigationRailMutedUnselectedLabel: false,
      navigationRailMutedUnselectedIcon: false,
      navigationRailOpacity: 0.99,
    ),
    keyColors: const FlexKeyColors(
      useSecondary: true,
      useTertiary: true,
      keepSecondary: true,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
    // To use the Playground font, add GoogleFonts package and uncomment
    // fontFamily: GoogleFonts.notoSans().fontFamily,
  );
}
