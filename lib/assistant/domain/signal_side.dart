/// С какой стороны крайность у монеты: перегрев (переоценена, шорт) или
/// зеркальная перепроданность (недооценена, лонг).
enum SignalSide {
  short,
  long;

  bool get isLong => this == SignalSide.long;
}
