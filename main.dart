import 'dart:convert';
import 'dart:io';

class DFA {
  final Set<String> states = {'H1', 'M1', 'L1', 'K1', 'J1', 'F1', 'EGNI', 'EGN', 'EG', 'E1', 'D1', 'A1', 'SBC', 'SC', 'S1'};
  final Set<String> alphabet = {'s', 't', 'o', 'c', 'k', 'i', 'p', r'\W', r'\s'};
  final String initialState = 'H1';
  final Set<String> finalStates = {'SBC', 'SC', 'S1'};

  late final Map<String, Map<String, String>> transitions;

  final RegExp _nonWord = RegExp(r'^\W$', unicode: true);
  final RegExp _whitespace = RegExp(r'^\s$', unicode: true);

  DFA() {
    transitions = {
      'H1': {'s': 'L1', r'\W': 'M1'},
      'M1': {'s': 'L1'},
      'L1': {'t': 'K1'},
      'K1': {'o': 'J1'},
      'J1': {'c': 'F1'},
      'F1': {'k': 'EGNI'},
      'EGNI': {'t': 'D1', r'\s': 'EGN'},
      'EGN': {'t': 'D1', r'\s': 'EG'},
      'EG': {'t': 'D1', r'\s': 'E1'},
      'E1': {'t': 'D1'},
      'D1': {'i': 'A1'},
      'A1': {'p': 'SBC'},
      'SBC': {'s': 'SC', r'\W': 'S1'},
      'SC': {r'\W': 'S1'},
      'S1': {},
    };
  }

  String _symbolClass(String symbol) {
    if (_whitespace.hasMatch(symbol)) return r'\s';
    if (_nonWord.hasMatch(symbol)) return r'\W';
    return symbol;
  }

  bool belongs(String input) {
    String current = initialState;

    // Якоря ^ и $ не читаются как символы: проверяется вся строка.
    for (final rune in input.runes) {
      final String symbol = String.fromCharCode(rune);
      final String label = _symbolClass(symbol);
      final String displayedSymbol = jsonEncode(symbol);

      if (!alphabet.contains(label)) {
        print('Ошибка: символ $displayedSymbol не входит в алфавит');
        return false;
      }

      String? next = transitions[current]![label];

      // Пробельные символы входят и в \W. На границах строки используется
      // переход по \W, а между stock и tip — переход по \s.
      if (label == r'\s') {
        next ??= transitions[current]![r'\W'];
      }

      if (next == null) {
        print('Нет перехода из $current по символу $displayedSymbol');
        return false;
      }

      print('δ($current, $displayedSymbol) = $next');
      current = next;
    }

    return finalStates.contains(current);
  }
}

void main() {
  DFA dfa = DFA();

  print('==============================================');
  print(r'ДКА для паттерна: (\W|^)stock\s{0,3}tip(s){0,1}(\W|$)');
  print('Проверяется вся строка с учётом регистра.');
  print('Между stock и tip: от 0 до 3 пробельных символов.');
  print(r'До stock и после tip/tips: не более одного символа \W.');
  print('==============================================');

  while (true) {
    stdout.write('Введите строку для проверки или нажмите Enter для выхода: ');
    String? input = stdin.readLineSync();
    if (input == null || input == '') {
      print('Выход');
      break;
    }
    bool result = dfa.belongs(input);
    print(result ? 'Строка "$input" ПРИНАДЛЕЖИТ языку' : 'Строка "$input" НЕ ПРИНАДЛЕЖИТ языку');
  }
}
