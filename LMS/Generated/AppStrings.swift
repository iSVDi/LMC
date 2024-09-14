// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum AppStrings {
  /// Localizable.strings
  ///   LMS
  /// 
  ///   Created by Daniil on 14.09.2024.
  internal static let descriptionTitle = AppStrings.tr("Localizable", "DescriptionTitle", fallback: "Описание")
  /// Ошибка
  internal static let errorTitle = AppStrings.tr("Localizable", "ErrorTitle", fallback: "Ошибка")
  /// KinoPoisk
  internal static let kinopoiskTitle = AppStrings.tr("Localizable", "KinopoiskTitle", fallback: "KinoPoisk")
  /// Логин
  internal static let loginTitle = AppStrings.tr("Localizable", "LoginTitle", fallback: "Логин")
  /// Хорошо
  internal static let okTitle = AppStrings.tr("Localizable", "OkTitle", fallback: "Хорошо")
  /// Пароль
  internal static let passwordTitle = AppStrings.tr("Localizable", "PasswordTitle", fallback: "Пароль")
  /// Ключевое слово
  internal static let searchPlaceholder = AppStrings.tr("Localizable", "SearchPlaceholder", fallback: "Ключевое слово")
  /// Кадры
  internal static let shotsTitle = AppStrings.tr("Localizable", "ShotsTitle", fallback: "Кадры")
  /// Войти
  internal static let signInTitle = AppStrings.tr("Localizable", "SignInTitle", fallback: "Войти")
  /// Неправильный логин или пароль
  internal static let wronAuthMessage = AppStrings.tr("Localizable", "WronAuthMessage", fallback: "Неправильный логин или пароль")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension AppStrings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
