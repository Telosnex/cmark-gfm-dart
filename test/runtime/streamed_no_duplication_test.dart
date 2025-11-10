import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

void main() {
  test('streamed no duplication', () {
    final parser = CmarkParser();

    // Feed some text without trailing newline
    parser.feed('Hello');

    // Call finishClone multiple times - should NOT duplicate
    for (var i = 1; i <= 3; i++) {
      final clone = parser.finishClone();
      final html = HtmlRenderer().render(clone);
      print('Call $i: $html');

      // Count occurrences of "Hello"
      final count = 'Hello'.allMatches(html).length;
      print(
          '  "Hello" appears $count time(s) ${count == 1 ? "✓" : "✗ DUPLICATION!"}');
    }

    // Now feed more text
    print('\nAdding " world"...');
    parser.feed(' world');

    final clone = parser.finishClone();
    final html = HtmlRenderer().render(clone);
    print('After adding: $html');
  });
}
