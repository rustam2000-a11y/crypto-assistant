import 'package:equatable/equatable.dart';

abstract class HomeEffect extends Equatable {
  const HomeEffect();

  @override
  List<Object?> get props => [];
}

class HomeShowError extends HomeEffect {
  const HomeShowError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
class Ext extends HomeEffect {
  const Ext();
}
