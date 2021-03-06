part of mochaccino.sdk.compiler;

class ErrorHandler {
  static final List<Issue> issues = [];
}

abstract class Issue implements Exception {
  final String title;
  final String filePath;
  final int lineNo;
  final String offendingLine;
  final int start;
  final String description;
  final Source source;
  Issue(
    this.title, {
    required this.lineNo,
    required this.offendingLine,
    required this.start,
    required this.description,
    required this.source,
    this.filePath = 'main.mocc',
  });

  String get consoleString {
    return """
$this: $title
  $description
  [$filePath:$lineNo]:
    $lineNo| $offendingLine
""";
  }
}

class PackageError extends Issue {
  PackageError(
    super.title, {
    required super.lineNo,
    required super.offendingLine,
    required super.start,
    required super.description,
    required super.source,
    super.filePath = 'main.mocc',
  });
}

class SyntaxError extends Issue {
  SyntaxError(
    super.title, {
    required super.lineNo,
    required super.offendingLine,
    required super.start,
    required super.description,
    required super.source,
    super.filePath = 'main.mocc',
  });

  static String unterminatedPair(String pair) => "Unterminated '$pair' pair";
  static String unexpectedChar(String char) => "Unexpected character '$char'";
  static String unexpectedToken(Token token) =>
      "Unexpected token '${token.lexeme}'";
}

class TypeError extends Issue {
  TypeError(
    super.title, {
    required super.lineNo,
    required super.offendingLine,
    required super.start,
    required super.description,
    required super.source,
    super.filePath = 'main.mocc',
  });

  static String operationTypeError(
          String op, Type expectedType, Type givenType) =>
      "Operation '$op' requires operand(s) to be [$expectedType] but [$givenType] given instead.";
}

class ReferenceError extends Issue {
  ReferenceError(
    super.title, {
    required super.lineNo,
    required super.offendingLine,
    required super.start,
    required super.description,
    required super.source,
    super.filePath = 'main.mocc',
  });
  static String undefinedObject(String name) => "Object '$name' not defined";
}

class StackError extends Issue {
  StackError(
    super.title, {
    required super.lineNo,
    required super.offendingLine,
    required super.start,
    required super.description,
    required super.source,
    super.filePath = 'main.mocc',
  });
}
