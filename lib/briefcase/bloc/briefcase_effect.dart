import 'package:equatable/equatable.dart';

abstract class BriefcaseEffect extends Equatable {
  const BriefcaseEffect();

  @override
  List<Object?> get props => [];
}

class BriefcaseShowError extends BriefcaseEffect {
  const BriefcaseShowError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
