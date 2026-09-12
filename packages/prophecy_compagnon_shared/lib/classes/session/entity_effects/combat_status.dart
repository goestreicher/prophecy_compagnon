import 'package:prophecy_compagnon_shared/classes/entity/combat_status.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/session/entity_effect.dart';

class EffectSetCombatStatus extends EntityEffect {
  EffectSetCombatStatus({
    required this.status,
  })
    : super(once: true);

  final EntityCombatStatusFlag status;

  @override
  void apply(EntityBase entity) =>
      entity.combatStatus.add(status);

  @override
  void unapply(EntityBase entity) {}
}

class EffectClearCombatStatus extends EntityEffect {
  EffectClearCombatStatus({
    required this.status
  })
    : super(once: true);

  final EntityCombatStatusFlag status;

  @override
  void apply(EntityBase entity) => entity.combatStatus.clear(status);

  @override
  void unapply(EntityBase entity) {}
}