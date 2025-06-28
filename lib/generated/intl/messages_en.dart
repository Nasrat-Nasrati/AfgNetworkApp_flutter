// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(error) => "❌ Error: ${error}";

  static String m1(error) => "❌ Error: ${error}";

  static String m2(name) => "📦 Packages - ${name}";

  static String m3(operator) => "Services - ${operator}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "Services": MessageLookupByLibrary.simpleMessage("Services"),
    "activation": MessageLookupByLibrary.simpleMessage("Activation"),
    "afn": MessageLookupByLibrary.simpleMessage("AFN"),
    "appTitle": MessageLookupByLibrary.simpleMessage("Afghan Network App"),
    "bundles": MessageLookupByLibrary.simpleMessage("Bundles"),
    "checkBalance": MessageLookupByLibrary.simpleMessage("Check Balance"),
    "close": MessageLookupByLibrary.simpleMessage("Close"),
    "codeLabel": MessageLookupByLibrary.simpleMessage("Code:"),
    "darkMode": MessageLookupByLibrary.simpleMessage("Dark Mode"),
    "deactivation": MessageLookupByLibrary.simpleMessage("Deactivation"),
    "errorFetchingDetails": MessageLookupByLibrary.simpleMessage(
      "Error in finding package details",
    ),
    "errorFetchingPackages": m0,
    "errorFetchingServices": m1,
    "errorInFindingPackageDetails": MessageLookupByLibrary.simpleMessage(
      "Error in finding package details",
    ),
    "lightMode": MessageLookupByLibrary.simpleMessage("Light Mode"),
    "noBundlesFound": MessageLookupByLibrary.simpleMessage("No bundles found."),
    "noDetailsAvailable": MessageLookupByLibrary.simpleMessage(
      "No details available",
    ),
    "noDetailsFound": MessageLookupByLibrary.simpleMessage(
      "No Details found in this Package",
    ),
    "noDetailsInPackages": MessageLookupByLibrary.simpleMessage(
      "No details found in this package",
    ),
    "noOperatorsFound": MessageLookupByLibrary.simpleMessage(
      "No operators found",
    ),
    "noPackagesFound": MessageLookupByLibrary.simpleMessage(
      "Not Found any Packages",
    ),
    "noServicesFoundForOperator": MessageLookupByLibrary.simpleMessage(
      "No services found for this operator.",
    ),
    "notFoundAnyPackages": MessageLookupByLibrary.simpleMessage(
      "Not found any packages",
    ),
    "packagesTitle": m2,
    "servicesOf": MessageLookupByLibrary.simpleMessage("Services of"),
    "servicesTitle": m3,
  };
}
