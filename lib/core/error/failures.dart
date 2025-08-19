import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([this.properties = const <dynamic>[]]);
  final List<dynamic> properties;

  @override
  List<Object?> get props => [properties];
}

class ServerFailure extends Failure {}

class NetworkFailure extends Failure {}

class CacheFailure extends Failure {}

class GeneralFailure extends Failure {}