import 'dart:io';

class DFA {
  final Set<String> states = {
    'S0',
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
  };

  final Set<String> alphabet = {
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
    '.',
  };

  final String initialState = 'S0';

  final Set<String> finalStates = {'J'};

  late final Map<String, Map<String, String>> transitions;

  DFA() {
    transitions = {
      'S0': {'1': 'A'},
      'A': {'9': 'B'},
      'B': {'2': 'C'},
      'C': {'.': 'D'},
      'D': {'1': 'E'},
      'E': {'6': 'F'},
      'F': {'8': 'G'},
      'G': {'.': 'H'},
      'H': {'1': 'I'},
      'I': {'.': 'J'},
      'J': {
        '0': 'J',
        '1': 'J',
        '2': 'J',
        '3': 'J',
        '4': 'J',
        '5': 'J',
        '6': 'J',
        '7': 'J',
        '8': 'J',
        '9': 'J',
      },
    };
  }

  bool belongs(String input) {
    String current = initialState;

    for (int i = 0; i < input.length; i++) {
      String symbol = input[i];

      if (!alphabet.contains(symbol)) {
        print('Ошибка: символ "$symbol" не входит в алфавит');
        return false;
      }

      if (!transitions[current]!.containsKey(symbol)) {
        print('Нет перехода из $current по символу "$symbol"');
        return false;
      }

      String next = transitions[current]![symbol]!;
      print('δ($current, $symbol) = $next');
      current = next;
    }

    return finalStates.contains(current);
  }
}

void main() {
  DFA dfa = DFA();

  print('==============================================');
  print('ДКА для паттерна: 192\\.168\\.1\\.');
  print('Язык: {"192.168.1." + w | w ∈ {0..9}*}');
  print('==============================================');

  while (true) {
    stdout.write('Введите строку для проверки или нажмите Enter для выхода: ');
    String? input = stdin.readLineSync();
    if (input == null || input == '') {
      print('Выход');
      break;
    }
    bool result = dfa.belongs(input);
    print(
      result
          ? 'Строка "$input" ПРИНАДЛЕЖИТ языку'
          : 'Строка "$input" НЕ ПРИНАДЛЕЖИТ языку',
    );
  }
}
