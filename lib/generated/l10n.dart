// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Afghan Network App`
  String get appTitle {
    return Intl.message(
      'Afghan Network App',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `No operators found`
  String get noOperatorsFound {
    return Intl.message(
      'No operators found',
      name: 'noOperatorsFound',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get darkMode {
    return Intl.message('Dark Mode', name: 'darkMode', desc: '', args: []);
  }

  /// `Light Mode`
  String get lightMode {
    return Intl.message('Light Mode', name: 'lightMode', desc: '', args: []);
  }

  /// `Services`
  String get Services {
    return Intl.message('Services', name: 'Services', desc: '', args: []);
  }

  /// `No details found in this package`
  String get noDetailsInPackages {
    return Intl.message(
      'No details found in this package',
      name: 'noDetailsInPackages',
      desc: '',
      args: [],
    );
  }

  /// `Not found any packages`
  String get notFoundAnyPackages {
    return Intl.message(
      'Not found any packages',
      name: 'notFoundAnyPackages',
      desc: '',
      args: [],
    );
  }

  /// `Error in finding package details`
  String get errorInFindingPackageDetails {
    return Intl.message(
      'Error in finding package details',
      name: 'errorInFindingPackageDetails',
      desc: '',
      args: [],
    );
  }

  /// `Not Found any Packages`
  String get noPackagesFound {
    return Intl.message(
      'Not Found any Packages',
      name: 'noPackagesFound',
      desc: '',
      args: [],
    );
  }

  /// `No services found for this operator.`
  String get noServicesFoundForOperator {
    return Intl.message(
      'No services found for this operator.',
      name: 'noServicesFoundForOperator',
      desc: '',
      args: [],
    );
  }

  /// `Services - {operator}`
  String servicesTitle(Object operator) {
    return Intl.message(
      'Services - $operator',
      name: 'servicesTitle',
      desc: '',
      args: [operator],
    );
  }

  /// `❌ Error: {error}`
  String errorFetchingServices(Object error) {
    return Intl.message(
      '❌ Error: $error',
      name: 'errorFetchingServices',
      desc: '',
      args: [error],
    );
  }

  /// `📦 Packages - {name}`
  String packagesTitle(Object name) {
    return Intl.message(
      '📦 Packages - $name',
      name: 'packagesTitle',
      desc: '',
      args: [name],
    );
  }

  /// `❌ Error: {error}`
  String errorFetchingPackages(Object error) {
    return Intl.message(
      '❌ Error: $error',
      name: 'errorFetchingPackages',
      desc: '',
      args: [error],
    );
  }

  /// `Code:`
  String get codeLabel {
    return Intl.message('Code:', name: 'codeLabel', desc: '', args: []);
  }

  /// `No details available`
  String get noDetailsAvailable {
    return Intl.message(
      'No details available',
      name: 'noDetailsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `Services of`
  String get servicesOf {
    return Intl.message('Services of', name: 'servicesOf', desc: '', args: []);
  }

  /// `No Details found in this Package`
  String get noDetailsFound {
    return Intl.message(
      'No Details found in this Package',
      name: 'noDetailsFound',
      desc: '',
      args: [],
    );
  }

  /// `Error in finding package details`
  String get errorFetchingDetails {
    return Intl.message(
      'Error in finding package details',
      name: 'errorFetchingDetails',
      desc: '',
      args: [],
    );
  }

  /// `Bundles`
  String get bundles {
    return Intl.message('Bundles', name: 'bundles', desc: '', args: []);
  }

  /// `No bundles found.`
  String get noBundlesFound {
    return Intl.message(
      'No bundles found.',
      name: 'noBundlesFound',
      desc: '',
      args: [],
    );
  }

  /// `Activation`
  String get activation {
    return Intl.message('Activation', name: 'activation', desc: '', args: []);
  }

  /// `Deactivation`
  String get deactivation {
    return Intl.message(
      'Deactivation',
      name: 'deactivation',
      desc: '',
      args: [],
    );
  }

  /// `Check Balance`
  String get checkBalance {
    return Intl.message(
      'Check Balance',
      name: 'checkBalance',
      desc: '',
      args: [],
    );
  }

  /// `AFN`
  String get afn {
    return Intl.message('AFN', name: 'afn', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fa'),
      Locale.fromSubtags(languageCode: 'ps'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
