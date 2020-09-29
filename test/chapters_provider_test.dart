import 'package:test/test.dart';
import '../lib/controller/provider/chapters_provider.dart';
import '../lib/models/novel_data.dart';

void main() {
  test('Check if the function has fetched chapters', () {
    final chapterProvider = ChaptersProvider();

    chapterProvider.fetchChaptersQuicker();

    expect(
        chapterProvider.chapters.isNotEmpty, novelData[1].chapters.isNotEmpty);
  });
}
