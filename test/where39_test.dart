import 'package:dart_where39/where39.dart';
import 'package:latlong/latlong.dart';
import 'package:test/test.dart';

// Room77, Berlin
final LatLng latLng = LatLng(52.49303704, 13.41792593);
final List<String> wordsStandard = [
  'slush',
  'extend',
  'until',
  'layer',
  'arch',
];
final int shuffleValue = 1337;
final List<String> wordsShuffled1337 = [
  'small',
  'extra',
  'unusual',
  'lazy',
  'accident',
];

void main() {
  test('Convert coordiates to words', () {
    final Where39 w39 = Where39();
    List<String> words = w39.toWords(latLng);
    expect(words, wordsStandard);
  });

  test('Convert words to coordinates', () {
    final Where39 w39 = Where39();
    LatLng coords = w39.fromWords(wordsStandard);
    expect(
      coords.latitude.toStringAsPrecision(10),
      latLng.latitude.toStringAsPrecision(10),
    );
    expect(
      coords.longitude.toStringAsPrecision(10),
      latLng.longitude.toStringAsPrecision(10),
    );
  });

  test('Shuffle multiple times and unshuffle', () {
    final Where39 w39 = Where39();
    w39.shuffle = shuffleValue;
    w39.shuffle = shuffleValue + 1;
    w39.shuffle = shuffleValue;
    List<String> words = w39.toWords(latLng);
    expect(words, wordsShuffled1337);

    // unshuffle
    w39.shuffle = 1;
    words = w39.toWords(latLng);
    expect(words, wordsStandard);
  });

  test('Shuffle with 1337 toWords', () {
    final Where39 w39 = Where39();
    w39.shuffle = shuffleValue;
    List<String> words = w39.toWords(latLng);
    expect(words, wordsShuffled1337);
  });

  test('Shuffle with 1337 fromWords', () {
    final Where39 w39 = Where39();
    w39.shuffle = shuffleValue;
    LatLng coords = w39.fromWords(wordsShuffled1337);
    expect(
      coords.latitude.toStringAsPrecision(10),
      latLng.latitude.toStringAsPrecision(10),
    );
    expect(
      coords.longitude.toStringAsPrecision(10),
      latLng.longitude.toStringAsPrecision(10),
    );
  });

  test('Argument errors', () {
    final Where39 w39 = Where39();
    expect(() => w39.fromWords(null), throwsArgumentError);
    expect(() => w39.fromWords([]), throwsArgumentError);
    expect(
      () => w39.fromWords(['1', '2', '3', '4', '5', '6']),
      throwsArgumentError,
    );
  });
}
