import 'geometry.dart';

sealed class EqualityProof<T extends Thing> {
  T get a;
  T get b;
}

class ReflexiveProperty<T extends Thing> extends EqualityProof<T> {
  final T thing;
  T get a => thing;
  T get b => thing;

  String toString() => 'Reflexive Property: $thing == $thing';

  ReflexiveProperty(this.thing);
}

class SymmetricProperty<T extends Thing> extends EqualityProof<T> {
  final T a;
  final T b;
  final EqualityProof<T> b_a;

  String toString() => 'Symmetric Property: Because $b == $a, $a == $b';

  SymmetricProperty(this.a, this.b, this.b_a) {
    if (b_a.a != b || b_a.b != a) {
      throw StateError('Invalid SymmetricProperty equality proof');
    }
  }
}

class TransitiveProperty<T extends Thing> extends EqualityProof<T> {
  final T a;
  final T mid;
  final T b;
  final EqualityProof<T> a_mid;
  final EqualityProof<T> b_mid;
  String toString() => 'Transitive Property: Because $a == $mid and $b == $mid, $a == $b';

  TransitiveProperty(this.a, this.mid, this.b, this.a_mid, this.b_mid) {
    if (a_mid.a != a || a_mid.b != mid || b_mid.a != b || b_mid.b != mid) {
      throw StateError('Invalid TransitiveProperty equality proof');
    }
  }
}

