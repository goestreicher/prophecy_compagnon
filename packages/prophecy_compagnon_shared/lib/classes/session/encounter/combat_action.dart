import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action_type.dart';
import 'package:prophecy_compagnon_shared/classes/session/entity_effect.dart';

abstract class CombatAction {
  CombatAction({
    required this.entityId,
    required this.type,
    required this.rank,
    this.interpolate = false,
    this.effects = const <EntityEffect>[],
  });

  final String entityId;
  final CombatActionType type;
  final int rank;
  final bool interpolate;
  final List<EntityEffect> effects;

  CombatAction? lerp(int rank, double x) => null;
}