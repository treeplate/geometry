class GeometryIterator implements Iterator {
  final Iterator<int> _iterator;
  GeometryIterator(this._iterator) {
    _iterator.moveNext();
  }

  int get current => _iterator.current;
  bool moveNext() => _iterator.moveNext();

  int getCharacter() {
    int char = _iterator.current;
    _iterator.moveNext();
    return char;
  }

  Point getPoint() {
    int char = getCharacter();
    int primes = 0;
    if (char < 65 || char > 90) throw FormatException('point expected');
    while (current == 39) {
      primes++;
      _iterator.moveNext();
    }
    return Point(char, primes);
  }
}

class Thing {
  const Thing();

  factory Thing.parse(GeometryIterator iterator) {
    int char1 = iterator.current;
    if (char1 >= 65 && char1 <= 90) {
      // capital letters
      Point p1 = iterator.getPoint();
      int char2 = iterator.current;
      if (char2 >= 65 && char2 <= 90) {
        // capital letters
        Point p2 = iterator.getPoint();
        return ValueOf(LineSegment(p1, p2));
      }
      return p1;
    }
    if (char1 == 45) {
      // -
      iterator.moveNext();
      Point a = iterator.getPoint();
      Point b = iterator.getPoint();
      switch (iterator.getCharacter()) {
        case 45: // -
          return LineSegment(a, b);
        case 62: // >
          return Ray(a, b);
        default:
          throw FormatException('Unexpected character after "-$a$b"');
      }
    }
    if (char1 == 60) {
      // <
      iterator.moveNext();
      Point a = iterator.getPoint();
      Point b = iterator.getPoint();
      if (iterator.current == 62) {
        // >
        iterator.moveNext();
        return Line(a, b);
      }
      Point c = iterator.getPoint();
      return Angle(a, b, c);
    }
    if (char1 == 109) {
      // m
      if (char1 == 60) {
        // <
        iterator.moveNext();
        Point a = iterator.getPoint();
        Point b = iterator.getPoint();
        Point c = iterator.getPoint();
        return ValueOf(Angle(a, b, c));
      }
    }
    if (char1 == 94) {
        // ^
        iterator.moveNext();
        Point a = iterator.getPoint();
        Point b = iterator.getPoint();
        Point c = iterator.getPoint();
        return Triangle(a, b, c);
      }
    throw UnimplementedError();
  }
}

class Point extends Thing {
  final int name;
  final int primes;
  const Point(this.name, this.primes);

  String toString() => String.fromCharCode(name) + '\'' * primes;
}

class Measurable extends Thing {
  const Measurable();
}

class LineSegment extends Measurable {
  final Point a;
  final Point b;
  const LineSegment(this.a, this.b);

  String toString() => 'segment $a$b';
}

class Ray extends Thing {
  final Point a; // endpoint
  final Point b;
  const Ray(this.a, this.b);

  String toString() => 'ray $a$b->';
}

class Line extends Thing {
  final Point a;
  final Point b;
  const Line(this.a, this.b);

  String toString() => 'line <-$a$b->';
}

class Angle extends Measurable {
  final Point a;
  final Point b;
  final Point c;
  const Angle(this.a, this.b, this.c);

  String toString() => '∠$a$b$c';
}

class Triangle extends Measurable {
  final Point a;
  final Point b;
  final Point c;
  const Triangle(this.a, this.b, this.c);

  String toString() => '△$a$b$c';
}

class ValueOf extends Thing {
  final Measurable thing;
  const ValueOf(this.thing);

  String toString() {
    switch (thing) {
      case LineSegment(a: Point a, b: Point b):
        return '$a$b';
      case Angle(a: Point a, b: Point b, c: Point c):
        return 'm∠$a$b$c';
      default:
        throw UnimplementedError();
    }
  }
}