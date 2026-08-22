import 'package:cmark_gfm/cmark_gfm.dart';
import 'package:test/test.dart';

void main() {
  test('ADR rule prose after a heading parses as a paragraph', () {
    const markdown = '''## 3) New findings

### N-B1 (blocking, ADR §3 rule 3): the prose mint formula omits the own-stamp floor

ADR §3 rule 3: `modified_at = max(now, that step's newest server-acknowledged or server-applied stamp + 1 ms)`. The model: `Mint(d) == Max2(loc[d].stamp, seen[d]) + 1` — the **current local stamp** participates. These disagree, and the model is right. `StepRowSyncPure.ReceiptCAS`'s soundness comment is explicit: *"Any local mutation bumps the stamp, so stamp equality is a complete dirtiness check."* Under the prose formula, a device with a backwards-stepping clock (`now` below current stamp) and an unacked edit chain (`seen` stale, `seen + 1 ≤ current stamp`) mints a stamp **equal to the current one**. The receipt CAS then false-positives: an in-flight response acks a revision the server never saw — precisely the silent-loss class rule 2 exists to prevent, and precisely what I2/E would catch if the model had the bug. The model doesn't have the bug; the document a Dart engineer will implement from does. Fix: `new_stamp = max(now_clamped, current_stamp + 1 ms, seen + 1 ms)`, and add strict-monotonicity-per-mutation to the S9 test's assertions.''';

    final parser = CmarkParser()..feed(markdown);
    final document = parser.finish();
    final blocks = document.children.toList();

    expect(
      blocks.map((node) => node.type),
      [
        CmarkNodeType.heading,
        CmarkNodeType.heading,
        CmarkNodeType.paragraph,
      ],
    );
    expect(blocks[0].headingData.level, 2);
    expect(blocks[1].headingData.level, 3);
    expect(
      blocks[2].content.toString().trimRight(),
      startsWith('ADR §3 rule 3: `modified_at = max(now,'),
    );
  });
}
