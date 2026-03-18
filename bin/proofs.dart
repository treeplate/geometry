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

  SymmetricProperty(this.b_a): a = b_a.b, b = b_a.a;
}

class TransitiveProperty<T extends Thing> extends EqualityProof<T> {
  final T a;
  final T mid;
  final T b;
  final EqualityProof<T> a_mid;
  final EqualityProof<T> mid_b;
  String toString() => 'Transitive Property: Because $a == $mid and $b == $mid, $a == $b';

  TransitiveProperty(this.a_mid, this.mid_b): a = a_mid.a, mid = a_mid.b, b = mid_b.b {
     if (a_mid.a != mid_b.b) {
      throw StateError('Invalid TransitiveProperty equality proof (a_mid.b: ${a_mid.b}, mid_b.a: ${mid_b.a})');
    }
  }
}

