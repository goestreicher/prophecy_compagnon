// GENERATED CODE - DO NOT EDIT

import "package:prophecy_compagnon_shared/classes/session/encounter/combat_action.dart";
import "package:prophecy_compagnon_shared/classes/session/encounter/combat_action/implementations/attack.dart";
import "package:prophecy_compagnon_shared/classes/session/encounter/combat_action/implementations/defense.dart";
import "package:prophecy_compagnon_shared/classes/session/encounter/combat_action/implementations/effect.dart";
import "package:prophecy_compagnon_shared/classes/session/encounter/combat_action/implementations/movement.dart";

void registerCombatActions() {
  CombatAction.registerCombatActionJsonFactory(
    "CombatActionAttack",
    (Map<String, dynamic> json) => CombatActionAttack.fromJson(json),
  );

  CombatAction.registerCombatActionJsonFactory(
    "CombatActionDefenseDodge",
    (Map<String, dynamic> json) => CombatActionDefenseDodge.fromJson(json),
  );

  CombatAction.registerCombatActionJsonFactory(
    "CombatActionDefenseParryShield",
    (Map<String, dynamic> json) => CombatActionDefenseParryShield.fromJson(json),
  );

  CombatAction.registerCombatActionJsonFactory(
    "CombatActionDefenseParryWeapon",
    (Map<String, dynamic> json) => CombatActionDefenseParryWeapon.fromJson(json),
  );

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
