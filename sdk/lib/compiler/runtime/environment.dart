part of mochaccino.sdk.compiler.runtime;

class Environment {
  static late CompileJob compileJob;
  static final Map<String, mocc.Object> values = {};

  static void defineObject(String name, Object? value) {
    values[name] = mocc.Object(value);
  }

  static getObject(Token token) {
    if (values.containsKey(token.lexeme)) {
      return values[token.lexeme]!;
    }

    throw ReferenceError(
      ReferenceError.undefinedObject(token.lexeme),
      lineNo: token.lineNo,
      offendingLine: compileJob.source.split('\n')[token.lineNo],
      start: token.start,
      description:
          "Try defining the object in a scope from which it can be accessed here.",
      source: Source.interpreter,
    );
  }
}
