import 'package:cmark_gfm_dart/cmark_gfm_dart.dart';
import 'package:test/test.dart';

void main() {
  late CmarkParser parser;
  late HtmlRenderer renderer;

  setUp(() {
    parser = CmarkParser();
    renderer = HtmlRenderer();
  });

  String render(String input) {
    parser.feed(input);
    final doc = parser.finish();
    return renderer.render(doc).trim();
  }

  test('strong text before em dash remains bold', () {
    const markdown =
        'Micro Center has a product page for the **ASUS ProArt PA32QCV**, and their nearest store is **Tustin (1100 E Edinger Ave)**—';

    final html = render(markdown);

    // The location should remain bold even when followed by an em dash
    expect(html, contains('<strong>Tustin (1100 E Edinger Ave)</strong>'));
  });
}
