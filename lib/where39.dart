library where39;

import 'package:latlong/latlong.dart';

import 'word_list.dart';

class Where39 {
  List<String> _fullSeed = [...wordList];

  List<String> _p45Seed;
  List<String> _p20Seed;

  List<List<String>> _split64Seed;
  List<List<String>> _split45Seed;
  List<List<String>> _split20Seed;

  final List<double> _tileSizes = [
    5.625,
    0.125,
    0.00277777777,
    0.00006172839,
    0.00000308642
  ];

  List<List<List<String>>> _tileSeeds;

  int _shuffleValue;

  Where39([this._shuffleValue = 1]) {
    if (_shuffleValue < 1 || _shuffleValue > 9999999) {
      throw ArgumentError("ShuffleValue muste be >= 1 and <= 9999999");
    }

    if (_shuffleValue > 1) {
      // shuffle calls _setup() for us
      _shuffle();
    } else {
      _setup();
    }
  }

  int get shuffle => _shuffleValue;
  set shuffle(int shuffleValue) {
    if (shuffleValue < 1 || shuffleValue > 9999999) {
      throw ArgumentError("ShuffleValue muste be >= 1 and <= 9999999");
    }

    _shuffleValue = shuffleValue;
    _shuffle();
  }

  LatLng fromWords(List<String> words) {
    ArgumentError.checkNotNull(words, 'words');

    if (words.length < 1 || words.length > 5) {
      throw ArgumentError('Word list length >= 1 && <= 5');
    }

    double lat = 0.0;
    double lng = 0.0;

    for (var i = 0; i < words.length; i++) {
      LatLng p = _getIndexOfWord(_tileSeeds[i], words[i]);
      lat += p.latitude * _tileSizes[i];
      lng += p.longitude * _tileSizes[i];
    }

    lng -= 180;
    lat -= 90;

    return LatLng(lat, lng);
  }

  List<String> toWords(LatLng coords) {
    double lat = coords.latitude;
    double lng = ((coords.longitude - 180.0).remainder(360.0)) + 180.0;

    lat += 90;
    lng += 180;

    List<String> finalWords = List<String>(5);
    var latw = lat;
    var lngw = lng;
    for (var i = 0; i < 5; i++) {
      var tilesize = _tileSizes[i];
      var seeds = _tileSeeds[i];
      var clatw = (latw / tilesize).floor();
      var clngw = (lngw / tilesize).floor();

      latw -= tilesize * clatw;
      lngw -= tilesize * clngw;
      finalWords[i] = seeds[clatw][clngw];
    }

    return finalWords;
  }

  List<List<String>> _chunkArray(List<String> myArray, int chunkSize) {
    int index = 0;
    int arrayLength = myArray.length;
    List<List<String>> tempArray = [];

    for (index = 0; index < arrayLength; index += chunkSize) {
      List<String> myChunk = myArray.sublist(index, index + chunkSize);
      tempArray.add(myChunk);
    }

    return tempArray;
  }

  LatLng _getIndexOfWord(List<List<String>> words, word) {
    for (int i = 0; i < words.length; i++) {
      int index = words[i].indexOf(word);
      if (index > -1) {
        return LatLng(i.toDouble(), index.toDouble());
      }
    }

    return null;
  }

  void _setup() {
    _p45Seed = _fullSeed.sublist(0, 2025);
    _p20Seed = _fullSeed.sublist(0, 400);

    _split64Seed = _chunkArray(_fullSeed, 64);
    _split45Seed = _chunkArray(_p45Seed, 45);
    _split20Seed = _chunkArray(_p20Seed, 20);

    _tileSeeds = [
      _split64Seed,
      _split45Seed,
      _split45Seed,
      _split45Seed,
      _split20Seed
    ];
  }

  void _shuffle() {
    if (_shuffleValue == 1) {
      _fullSeed = [...wordList];
    } else {
      double val = double.parse('0.' + _shuffleValue.toString());
      List<String> temp = [...wordList];
      for (int i = temp.length - 1; i > 0; i--) {
        int j = (val * (i + 1)).floor(); // random index from 0 to i
        String oldJ = temp[j];
        temp[j] = temp[i];
        temp[i] = oldJ;
      }
      _fullSeed = temp;
    }
    _setup();
  }
}
