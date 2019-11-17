# Where93 - Dart Version
This is the Dart version for the original where39 library for the web: [Where39](https://github.com/arcbtc/where39)



## Example


```Dart
final LatLng latLng = LatLng(52.49303704, 13.41792593);

    // create a Where39 instance without shuffle
    final Where39 w39 = Where39();

    // convert the coordinates to words
    List<String> words = w39.toWords(latLng);
    print(words);
    // prints: [slush extend until layer arch]

    LatLng coords = w39.fromWords([
      'slush',
      'extend',
      'until',
      'layer',
      'arch',
    ]);
    print(coords);
    // prints: LatLng(latitude:52.493037, longitude:13.417926)

    // shuffle the seed
    w39.shuffle = 1337;
    words = w39.toWords(latLng);
    print(words);
    // prints: [small, extra, unusual, lazy, accident]
```