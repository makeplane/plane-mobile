import 'package:dartz/dartz.dart';

extension EitherExtension<L,R> on Either<L,R> {
  bool get isLeft => this.isLeft();
  bool get isRight => this.isRight();

  L get leftValue => _getLValue();
  R get rightValue => _getRValue();

  L _getLValue() {
    return fold((l) => l, (r) => throw Exception('No left value'));
  }
  R _getRValue() {
    return fold((l) => throw Exception('No right value'), (r) => r);
  }
}
