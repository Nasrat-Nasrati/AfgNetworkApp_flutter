// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fa locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'fa';

  static String m0(error) => "❌ خطا: ${error}";

  static String m1(error) => "❌ خطا: ${error}";

  static String m2(name) => "📦 بسته‌ها - ${name}";

  static String m3(operator) => "خدمات - ${operator}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "Services": MessageLookupByLibrary.simpleMessage("خدمات"),
    "activation": MessageLookupByLibrary.simpleMessage("فعال‌سازی"),
    "afn": MessageLookupByLibrary.simpleMessage("افغانی"),
    "appTitle": MessageLookupByLibrary.simpleMessage("برنامه‌ی شبکه افغان"),
    "bundles": MessageLookupByLibrary.simpleMessage("بسته‌ها"),
    "checkBalance": MessageLookupByLibrary.simpleMessage("بررسی باقی‌مانده"),
    "close": MessageLookupByLibrary.simpleMessage("بستن"),
    "codeLabel": MessageLookupByLibrary.simpleMessage("کد:"),
    "darkMode": MessageLookupByLibrary.simpleMessage("حالت شب"),
    "deactivation": MessageLookupByLibrary.simpleMessage("غیرفعالسازی"),
    "errorFetchingDetails": MessageLookupByLibrary.simpleMessage(
      "خطا در دریافت جزئیات بسته",
    ),
    "errorFetchingPackages": m0,
    "errorFetchingServices": m1,
    "errorInFindingPackageDetails": MessageLookupByLibrary.simpleMessage(
      "خطا در دریافت جزئیات بسته‌ها",
    ),
    "lightMode": MessageLookupByLibrary.simpleMessage("حالت روشن"),
    "noBundlesFound": MessageLookupByLibrary.simpleMessage(
      "هیچ بسته‌ای پیدا نشد.",
    ),
    "noDetailsAvailable": MessageLookupByLibrary.simpleMessage(
      "هیچ جزئیاتی در دسترس نیست",
    ),
    "noDetailsFound": MessageLookupByLibrary.simpleMessage(
      "هیچ جزئیاتی در این بسته یافت نشد",
    ),
    "noDetailsInPackages": MessageLookupByLibrary.simpleMessage(
      "هیچ جزئیاتی در این بسته‌ها یافت نشد",
    ),
    "noOperatorsFound": MessageLookupByLibrary.simpleMessage(
      "هیچ اپراتوری پیدا نشد",
    ),
    "noPackagesFound": MessageLookupByLibrary.simpleMessage(
      "هیچ بسته‌ای یافت نشد",
    ),
    "noServicesFoundForOperator": MessageLookupByLibrary.simpleMessage(
      "هیچ خدمتی برای این اپراتور یافت نشد.",
    ),
    "notFoundAnyPackages": MessageLookupByLibrary.simpleMessage(
      "هیچ بسته‌ای پیدا نشد",
    ),
    "packagesTitle": m2,
    "servicesOf": MessageLookupByLibrary.simpleMessage("خدمات از"),
    "servicesTitle": m3,
  };
}
