// available color scheme names
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

final shadThemeColors = [
  'blue',
  'gray',
  'green',
  'neutral',
  'orange',
  'red',
  'rose',
  'slate',
  'stone',
  'violet',
  'yellow',
  'zinc',
];

final lightColorScheme = ShadColorScheme.fromName('blue');
final darkColorScheme = ShadColorScheme.fromName(
  'slate',
  brightness: Brightness.dark,
);

// Add dark theme data
final darkThemeData = ShadThemeData(
  brightness: Brightness.dark,
  colorScheme: darkColorScheme,
  primaryButtonTheme: ShadButtonTheme(),
  secondaryButtonTheme: ShadButtonTheme(),
  destructiveButtonTheme: ShadButtonTheme(),
  outlineButtonTheme: ShadButtonTheme(),
  ghostButtonTheme: ShadButtonTheme(),
  linkButtonTheme: ShadButtonTheme(),
  primaryBadgeTheme: ShadBadgeTheme(),
  secondaryBadgeTheme: ShadBadgeTheme(),
  destructiveBadgeTheme: ShadBadgeTheme(),
  outlineBadgeTheme: ShadBadgeTheme(),
  radius: BorderRadius.circular(8.0),
  avatarTheme: ShadAvatarTheme(),
  buttonSizesTheme: ShadButtonSizesTheme(),
  tooltipTheme: ShadTooltipTheme(),
  popoverTheme: ShadPopoverTheme(),
  decoration: ShadDecoration(),
  textTheme: ShadTextTheme(),
  disabledOpacity: 0.5,
  selectTheme: ShadSelectTheme(),
  optionTheme: ShadOptionTheme(),
  cardTheme: ShadCardTheme(),
  switchTheme: ShadSwitchTheme(),
  checkboxTheme: ShadCheckboxTheme(),
  inputTheme: ShadInputTheme(),
  radioTheme: ShadRadioTheme(),
  primaryToastTheme: ShadToastTheme(),
  destructiveToastTheme: ShadToastTheme(),
  breakpoints: ShadBreakpoints(),
  primaryAlertTheme: ShadAlertTheme(),
  destructiveAlertTheme: ShadAlertTheme(),
  primaryDialogTheme: ShadDialogTheme(),
  alertDialogTheme: ShadDialogTheme(),
  sliderTheme: ShadSliderTheme(),
  sheetTheme: ShadSheetTheme(),
  progressTheme: ShadProgressTheme(),
  accordionTheme: ShadAccordionTheme(),
  tableTheme: ShadTableTheme(),
  resizableTheme: ShadResizableTheme(),
  hoverStrategies: ShadHoverStrategies(),
  disableSecondaryBorder: false,
  tabsTheme: ShadTabsTheme(),
  // variant: ShadThemeVariant(),
  contextMenuTheme: ShadContextMenuTheme(),
  calendarTheme: ShadCalendarTheme(),
  datePickerTheme: ShadDatePickerTheme(),
  timePickerTheme: ShadTimePickerTheme(),
  inputOTPTheme: ShadInputOTPTheme(),
  menubarTheme: ShadMenubarTheme(),
  separatorTheme: ShadSeparatorTheme(),
);
