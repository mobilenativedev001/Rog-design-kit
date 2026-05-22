// DSTextFieldValidation.swift
// Rogers iOS Design System
//
// Composable, protocol-based validation architecture for DSTextField.
//
// Usage — compose multiple validators on a single field:
//
//   DSTextField(
//       "Email",
//       placeholder: "you@example.com",
//       validators: [
//           DSRequiredValidator(),
//           DSEmailValidator()
//       ],
//       text: $email
//   )
//
// Custom validator:
//
//   let noSpaces = DSCustomValidator { text in
//       text.contains(" ")
//           ? .invalid(message: "No spaces allowed.")
//           : .valid
//   }
//
// Override external result (e.g. from a server-side response):
//
//   DSTextField(... externalResult: $serverValidationResult ...)

import Foundation

// MARK: - DSValidationResult

/// The outcome of running one or more validators against field text.
public enum DSValidationResult: Equatable {

    /// No validation has run yet — the field has not been touched.
    case idle

    /// All validators passed.
    case valid

    /// At least one validator failed. `message` is shown as the error helper text.
    case invalid(message: String)

    // MARK: Convenience

    /// `true` only for the `.valid` case.
    public var isValid: Bool {
        if case .valid = self { return true }
        return false
    }

    /// The inline error message, or `nil` when the result is `.idle` or `.valid`.
    public var errorMessage: String? {
        if case .invalid(let msg) = self { return msg }
        return nil
    }

    /// `true` for `.idle` or `.valid`; `false` for `.invalid`.
    public var isPassing: Bool {
        switch self {
        case .idle, .valid: return true
        case .invalid:      return false
        }
    }

    // MARK: Equatable

    public static func == (lhs: DSValidationResult, rhs: DSValidationResult) -> Bool {
        switch (lhs, rhs) {
        case (.idle,  .idle):               return true
        case (.valid, .valid):              return true
        case (.invalid(let a), .invalid(let b)): return a == b
        default:                            return false
        }
    }
}

// MARK: - DSTextFieldValidator

/// Implement this protocol to supply a reusable validation rule.
///
/// Validators are stateless pure functions — they receive text, return a result.
/// Compose them in `DSTextFieldConfiguration.validators` to build a pipeline.
public protocol DSTextFieldValidator {

    /// Validates `text` and returns `.valid` or `.invalid(message:)`.
    /// Return `.idle` only if the field has no meaningful value yet and you
    /// want to defer the error display (rare — prefer `.valid` for empty-ok fields).
    func validate(_ text: String) -> DSValidationResult
}

// MARK: - Built-in validators

// MARK: DSRequiredValidator

/// Fails when the trimmed text is empty.
///
///     DSRequiredValidator()
///     DSRequiredValidator(message: "Phone number is required.")
public struct DSRequiredValidator: DSTextFieldValidator {

    public let message: String

    public init(message: String = "This field is required.") {
        self.message = message
    }

    public func validate(_ text: String) -> DSValidationResult {
        text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? .invalid(message: message)
            : .valid
    }
}

// MARK: DSMinLengthValidator

/// Fails when the text contains fewer than `minLength` characters.
///
///     DSMinLengthValidator(minLength: 8)
///     DSMinLengthValidator(minLength: 6, message: "PIN must be 6 digits.")
public struct DSMinLengthValidator: DSTextFieldValidator {

    public let minLength: Int
    public let message: String

    public init(minLength: Int, message: String? = nil) {
        self.minLength = minLength
        self.message   = message ?? "Must be at least \(minLength) characters."
    }

    public func validate(_ text: String) -> DSValidationResult {
        text.count >= minLength
            ? .valid
            : .invalid(message: message)
    }
}

// MARK: DSMaxLengthValidator

/// Fails when the text exceeds `maxLength` characters.
///
///     DSMaxLengthValidator(maxLength: 160)
public struct DSMaxLengthValidator: DSTextFieldValidator {

    public let maxLength: Int
    public let message: String

    public init(maxLength: Int, message: String? = nil) {
        self.maxLength = maxLength
        self.message   = message ?? "Must be no more than \(maxLength) characters."
    }

    public func validate(_ text: String) -> DSValidationResult {
        text.count <= maxLength
            ? .valid
            : .invalid(message: message)
    }
}

// MARK: DSEmailValidator

/// Fails when the text is not a well-formed email address.
///
///     DSEmailValidator()
///     DSEmailValidator(message: "Enter a Rogers account email.")
public struct DSEmailValidator: DSTextFieldValidator {

    public let message: String

    public init(message: String = "Please enter a valid email address.") {
        self.message = message
    }

    public func validate(_ text: String) -> DSValidationResult {
        // RFC 5322 simplified — covers the vast majority of real addresses.
        let pattern = #"^[A-Z0-9a-z._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return .valid  // fail open — never block if regex can't compile
        }
        let range = NSRange(text.startIndex..., in: text)
        return regex.firstMatch(in: text, options: [], range: range) != nil
            ? .valid
            : .invalid(message: message)
    }
}

// MARK: DSPhoneValidator

/// Fails when the digit-only content of the text is not between 10 and 15 digits.
/// Non-digit characters (spaces, dashes, parentheses) are ignored.
///
///     DSPhoneValidator()
///     DSPhoneValidator(message: "Enter a 10-digit Canadian phone number.")
public struct DSPhoneValidator: DSTextFieldValidator {

    public let message: String

    public init(message: String = "Please enter a valid phone number.") {
        self.message = message
    }

    public func validate(_ text: String) -> DSValidationResult {
        let digits = text.filter(\.isNumber)
        return (10...15).contains(digits.count)
            ? .valid
            : .invalid(message: message)
    }
}

// MARK: DSPostalCodeValidator

/// Validates Canadian postal codes (A1A 1A1 format, case-insensitive, space optional).
///
///     DSPostalCodeValidator()
public struct DSPostalCodeValidator: DSTextFieldValidator {

    public let message: String

    public init(message: String = "Enter a valid Canadian postal code.") {
        self.message = message
    }

    public func validate(_ text: String) -> DSValidationResult {
        let stripped = text.replacingOccurrences(of: " ", with: "").uppercased()
        let pattern  = #"^[ABCEGHJ-NPRSTVXY][0-9][ABCEGHJ-NPRSTV-Z][0-9][ABCEGHJ-NPRSTV-Z][0-9]$"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return .valid }
        let range = NSRange(stripped.startIndex..., in: stripped)
        return regex.firstMatch(in: stripped, options: [], range: range) != nil
            ? .valid
            : .invalid(message: message)
    }
}

// MARK: DSRegexValidator

/// Fails when the text does not fully match the supplied `pattern`.
///
///     DSRegexValidator(pattern: #"^\d{4,6}$"#, message: "Enter a 4–6 digit PIN.")
public struct DSRegexValidator: DSTextFieldValidator {

    public let pattern: String
    public let message: String

    public init(pattern: String, message: String) {
        self.pattern = pattern
        self.message = message
    }

    public func validate(_ text: String) -> DSValidationResult {
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return .valid }
        let range = NSRange(text.startIndex..., in: text)
        // Use anchored matching to require the entire string to match.
        let options: NSRegularExpression.MatchingOptions = []
        guard let match = regex.firstMatch(in: text, options: options, range: range) else {
            return .invalid(message: message)
        }
        // Ensure the match covers the entire string.
        return match.range == range ? .valid : .invalid(message: message)
    }
}

// MARK: DSCustomValidator

/// Wraps an arbitrary closure so any one-off rule can be used as a validator
/// without creating a new type.
///
///     DSCustomValidator { text in
///         text.hasPrefix("R") ? .valid : .invalid(message: "Must start with R.")
///     }
public struct DSCustomValidator: DSTextFieldValidator {

    private let rule: (String) -> DSValidationResult

    public init(rule: @escaping (String) -> DSValidationResult) {
        self.rule = rule
    }

    public func validate(_ text: String) -> DSValidationResult {
        rule(text)
    }
}

// MARK: - Validation runner

/// Runs `validators` in declaration order against `text`.
///
/// - Returns: `.invalid` with the first failure message; `.valid` if all pass;
///            `.idle` if the validators array is empty.
public func dsRunValidators(
    _ text: String,
    validators: [any DSTextFieldValidator]
) -> DSValidationResult {
    guard !validators.isEmpty else { return .idle }
    for validator in validators {
        let result = validator.validate(text)
        if case .invalid = result { return result }
    }
    return .valid
}
