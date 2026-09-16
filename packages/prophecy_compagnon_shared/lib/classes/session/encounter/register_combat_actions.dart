// GENERATED CODE - DO NOT EDIT

import "package:prophecy_compagnon_shared/classes/session/encounter/combat_action.dart";
import "package:prophecy_compagnon_shared/classes/session/encounter/combat_actions/implementations/effect.dart";
import "package:prophecy_compagnon_shared/classes/session/encounter/combat_actions/implementations/movement.dart";

void registerCombatActions() {
  CombatAction.registerCombatActionJsonFactory(
    "CombatActionEffect",
    (Map<String, dynamic> json) => CombatActionEffect.fromJson(json),
  );

  CombatAction.registerCombatActionJsonFactory(
    "CombatActionAssignedMovement",
    (Map<String, dynamic> json) => CombatActionAssignedMovement.fromJson(json),
  );

  CombatAction.registerCombatActionJsonFactory(
    "CombatActionMovement",
    (Map<String, dynamic> json) => CombatActionMovement.fromJson(json),
  );

}
