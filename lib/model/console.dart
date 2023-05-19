import 'dart:ui';

enum Console implements Comparable<Console> {
  NONE(
    id: 0,
    name: "BR",
    longName: "BlueRetro",
    colors: [('White', Color(0xFFFFFFFF)), ('Black', Color(0xFF000000))],
    asset: 'assets/dongles/GEN_0.png',
  ),
  N64(
    id: 1,
    name: "N64",
    longName: "Nintendo 64",
    colors: [('Gray', Color(0xFFD4D4D4)), ('Smoke Black', Color(0xAA000000))],
    asset: 'assets/dongles/N64_0.png',
  ),
  NGC(
    id: 2,
    name: "NGC",
    longName: "Nintendo Gamecube",
    colors: [
      ('Indigo', Color(0xFF645096)),
      ('Black', Color(0xFF000000)),
      ('Orange', Color(0xFFFE7F03)),
      ('Silver', Color(0xFFC3C3C3)),
    ],
    asset: 'assets/dongles/NGC_0.png',
  ),
  PSX(
    id: 3,
    name: "PSX",
    longName: "PlayStation",
    colors: [('Gray', Color(0xFFBCBCBC))],
    asset: 'assets/dongles/PSO_0.png',
  ),
  PSO(
    id: 4,
    name: "PSO",
    longName: "PlayStation One",
    colors: [('Soft Gray', Color(0xFFC8C9C5))],
    asset: 'assets/dongles/PSO_0.png',
  ),
  PS2(
    id: 5,
    name: "PS2",
    longName: "PlayStation 2",
    colors: [('Black', Color(0xFF000000))],
    asset: 'assets/dongles/PSO_0.png',
  );

  const Console({
    required this.id,
    required this.name,
    required this.longName,
    required this.colors,
    required this.asset,
  });

  final int id;
  final String name;
  final String longName;
  final String asset;
  final List<(String name, Color color)> colors;

  @override
  int compareTo(Console other) => id - other.id;
}
