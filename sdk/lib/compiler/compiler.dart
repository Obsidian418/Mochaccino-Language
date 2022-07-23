library mochaccino.sdk.compiler;

import 'dart:io';
import 'package:barista/interface/interface.dart';

import './runtime/runtime.dart';

part './tokeniser.dart';
part './parser.dart';
part './interpreter.dart';
part './error_handler.dart';

class Compiler {
  final String source;

  Compiler(this.source);

  void compile([bool debugMode = false]) {
    Interface.writeLog("COMPILING", Source.compiler);
    final Stopwatch stopwatch = Stopwatch()..start();
    MochaccinoRuntime.sourceLines = source.split('\n');

    final InterfaceProcess tokenisingProc = InterfaceProcess("Tokenising...")
      ..start();
    Tokeniser tokeniser = Tokeniser(source);
    List<Token> tokens = tokeniser.tokenise();
    tokenisingProc.complete();
    if (debugMode) {
      tokens.forEach((Token token) {
        Interface.writeLog('    ${token.toString()}', Source.compiler);
      });
    }

    final InterfaceProcess parsingProc = InterfaceProcess("Parsing...")
      ..start();
    Parser parser = Parser(tokens, source.split('\n'));
    List<Statement> statements = parser.parse();
    parsingProc.complete();
    if (debugMode)
      statements.forEach(
          (Statement s) => Interface.writeLog(s.toTree(0), Source.compiler));

    final InterfaceProcess interpretingProc =
        InterfaceProcess("Interpreting...")..start();
    Interpreter interpreter = Interpreter(statements, source.split('\n'));
    interpreter.interpret();

    if (ErrorHandler.issues.isNotEmpty) {
      interpretingProc.complete(false);
      ErrorHandler.reportAll();
      Interface.writeInfo(
        "Completed in ${stopwatch.elapsedMilliseconds}ms with ${ErrorHandler.issues.length} issues",
        Source.compiler,
      );
      stopwatch.stop();
      exit(1);
    } else {
      interpretingProc.complete();
    }
    Interface.writeInfo(
      "Completed in ${stopwatch.elapsedMilliseconds}ms with ${ErrorHandler.issues.length} issues",
      Source.compiler,
    );
    stopwatch.stop();
  }
}

void main(List<String> args) {
  bool debugMode = true;
  if (args.isNotEmpty && args[0] == 'nodebug') debugMode = false;
  String source = File("/workspaces/Mochaccino-Language/sdk/test/simple.mocc")
      .readAsStringSync();
  Compiler cortado = Compiler(source);
  cortado.compile(debugMode);
}

extension StringUtils on String {
  String indent(int indent, [String indentStr = '-']) =>
      "|" + (indentStr * indent) + this;
  String newline(String text) => this + "\n" + text;
  bool get isNewline => (this == '\n');
  bool get isEOF => (this == 'EOF');
  bool get isDigit => (<String>[
        '0',
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9'
      ].contains(this));
  bool get isAlphaNum => (<String>[
        'a',
        'b',
        'c',
        'd',
        'e',
        'f',
        'g',
        'h',
        'i',
        'j',
        'k',
        'l',
        'm',
        'n',
        'o',
        'p',
        'q',
        'r',
        's',
        't',
        'u',
        'v',
        'w',
        'x',
        'y',
        'z',
        'A',
        'B',
        'C',
        'D',
        'E',
        'F',
        'G',
        'H',
        'I',
        'J',
        'K',
        'L',
        'M',
        'N',
        'O',
        'P',
        'Q',
        'R',
        'S',
        'T',
        'U',
        'V',
        'W',
        'X',
        'Y',
        'Z',
        '0',
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
        '_'
      ].contains(this));

  bool get isAlpha => (<String>[
        'a',
        'b',
        'c',
        'd',
        'e',
        'f',
        'g',
        'h',
        'i',
        'j',
        'k',
        'l',
        'm',
        'n',
        'o',
        'p',
        'q',
        'r',
        's',
        't',
        'u',
        'v',
        'w',
        'x',
        'y',
        'z',
        'A',
        'B',
        'C',
        'D',
        'E',
        'F',
        'G',
        'H',
        'I',
        'J',
        'K',
        'L',
        'M',
        'N',
        'O',
        'P',
        'Q',
        'R',
        'S',
        'T',
        'U',
        'V',
        'W',
        'X',
        'Y',
        'Z',
        '_'
      ].contains(this));

  String charAt(int pos) => this[pos];
}
