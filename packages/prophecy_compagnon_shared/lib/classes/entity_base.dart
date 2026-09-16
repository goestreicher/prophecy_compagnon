/*
 * Copyright (C) 2024-2026 Grégory Oestreicher
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:prophecy_compagnon_shared/classes/combat.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_modifier.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_modifier_type.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/draconic_favor.dart';
import 'package:prophecy_compagnon_shared/classes/entity/abilities.dart';
import 'package:prophecy_compagnon_shared/classes/entity/attributes.dart';
import 'package:prophecy_compagnon_shared/classes/entity/combat_status.dart';
import 'package:prophecy_compagnon_shared/classes/entity/fervor.dart';
import 'package:prophecy_compagnon_shared/classes/entity/health_status.dart';
import 'package:prophecy_compagnon_shared/classes/entity/injury.dart';
import 'package:prophecy_compagnon_shared/classes/entity/magic.dart';
import 'package:prophecy_compagnon_shared/classes/entity/skills.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/enums.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/equipment.dart';
import 'package:prophecy_compagnon_shared/classes/exportable_binary_data.dart';
import 'package:prophecy_compagnon_shared/classes/money.dart';
import 'package:prophecy_compagnon_shared/classes/object_location.dart';
import 'package:prophecy_compagnon_shared/classes/object_source.dart';
import 'package:prophecy_compagnon_shared/classes/resource_base_class.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action_description.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action_type.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_actions/descriptions/movement.dart';
import 'package:prophecy_compagnon_shared/utils/text_utils.dart';
import 'package:uuid/uuid.dart';

part 'entity_base.g.dart';

typedef InjuryProvider = InjuryManager Function(EntityBase?, InjuryManager?);

abstract interface class ProtectionProvider {
  int protection();
}

abstract interface class DamageProvider {
  int damage(EntityBase owner, { List<int>? throws });
}

abstract interface class InitiativeProvider {
  int initiativeForRange(WeaponRange range);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class EntityBase extends ResourceBaseClass with SupportsEquipableItem {
  EntityBase({
    String? uuid,
    required super.name,
    required super.source,
    super.location = ObjectLocation.memory,
    EntityAbilities? abilities,
    EntityAttributes? attributes,
    this.initiative = 1,
    EntityInjuries? injuries,
    InjuryProvider injuryProvider = entityBaseDefaultInjuries,
    double? size,
    String? description,
    EntitySkills? skills,
    EntityHealthStatus? healthStatus,
    EntityCombatStatus? combatStatus,
    EntityEquipment? equipment,
    MoneyWallet? money,
    EntityMagic? magic,
    EntityDraconicFavors? favors,
    EntityFervor? fervor,
    ExportableBinaryData? image,
    ExportableBinaryData? icon,
  })
    : uuid = uuid ?? (!location.type.canWrite ? null : Uuid().v4().toString()),
      abilities = abilities ?? EntityAbilities.empty(),
      attributes = attributes ?? EntityAttributes.empty(),
      size = size ?? 0.8,
      description = description ?? '',
      skills = skills ?? EntitySkills.empty(),
      healthStatus = healthStatus ?? EntityHealthStatus.empty(),
      combatStatus = combatStatus ?? EntityCombatStatus.empty(),
      equipment = equipment ?? EntityEquipment(null),
      money = money ?? MoneyWallet(),
      magic = magic ?? EntityMagic(),
      favors = favors ?? EntityDraconicFavors(),
      fervor = fervor ?? EntityFervor(),
      _image = image,
      _icon = icon
  {
    this.injuries = injuries ?? EntityInjuries(manager: injuryProvider(this, null));
  }

  @JsonKey(includeIfNull: false)
    final String? uuid;
  @override
    String get id => uuid ?? sentenceToCamelCase(transliterateFrenchToAscii(name));

  EntityAbilities abilities;
  EntityAttributes attributes;
  int initiative;
  late EntityInjuries injuries;
  double size;
  String description;
  EntitySkills skills;
  EntityHealthStatus healthStatus;
  EntityCombatStatus combatStatus;
  @JsonKey(fromJson: EntityEquipment.fromJson, toJson: EntityEquipment.toJson)
    final EntityEquipment equipment;
  final MoneyWallet money;
  final EntityMagic magic;
  @JsonKey(
      fromJson: EntityDraconicFavors.fromJson,
      toJson: EntityDraconicFavors.toJson,
      readValue: EntityDraconicFavors.readFavorsFromJson,
    )
    final EntityDraconicFavors favors;
  final EntityFervor fervor;

  ExportableBinaryData? get image => _image;
  set image(ExportableBinaryData? i) {
    if(_image != null && (i == null || _image!.hash != i.hash)) BinaryDataStore().delete(_image!);
    _image = i;
  }

  ExportableBinaryData? get icon => _icon;
  set icon(ExportableBinaryData? i) {
    if(_icon != null && (i == null || _icon!.hash != i.hash)) BinaryDataStore().delete(_icon!);
    _icon = i;
  }

  double get baseMovementDistance => attributes.physique.toDouble();
  double get contactCombatRange => size / 2;

  ExportableBinaryData? _image;
  ExportableBinaryData? _icon;

  bool canAct() =>
      !healthStatus.has(EntityHealthStatusFlag.dead)
      && !healthStatus.has(EntityHealthStatusFlag.unconscious);

  bool canMove() =>
      canAct()
      && !combatStatus.has(EntityCombatStatusFlag.onGround)
      && !combatStatus.has(EntityCombatStatusFlag.grappled);

  List<CombatActionDescription> availableActionsForType(CombatActionType type) {
    var ret = <CombatActionDescription>[];
    if(!canAct()) return ret;

    switch(type) {
      case CombatActionType.effect:
        // Nothing to do here
        break;
      case CombatActionType.movement:
        if(canMove()) {
          ret.addAll([
            CombatActionMovementDescription(
                movementType: CombatActionMovementType.simple,
            ),
            CombatActionMovementDescription(
              movementType: CombatActionMovementType.run,
            ),
            CombatActionMovementDescription(
              movementType: CombatActionMovementType.sprint,
            ),
          ]);
        }
        else if(
            combatStatus.has(EntityCombatStatusFlag.onGround)
            && !combatStatus.has(EntityCombatStatusFlag.grappled)
        ) {
          // TODO: create action for the entity to get back up
        }
    }

    return ret;
  }

  int takeDamage(int amount, { int armorDivider = 1 }) {
    var finalDamage = amount;
    // TODO: manage shields when used to block an attack (in which case their protection don't apply
    for(var pp in _protectionProviders) {
      int reduction = pp.protection() ~/ armorDivider;
      finalDamage -= reduction;
    }

    if(finalDamage > 0) {
      injuries.manager.dealDamage(finalDamage);
      if(injuries.manager.isDead()) {
        healthStatus.add(EntityHealthStatusFlag.dead);
      }
    }

    return finalDamage > 0 ? finalDamage : 0;
  }

  int damageMalus() => injuries.manager.getMalus();

  final Map<String, DiceThrowModifier> _throwModifiers =
      <String, DiceThrowModifier>{};

  void addThrowModifier(DiceThrowModifier mod) {
    _throwModifiers[mod.id] = mod;
  }

  void removeThrowModifier(String id) {
    _throwModifiers.remove(id);
  }

  List<DiceThrowModifier> throwModifiers(DiceThrowRequest request) {
    var ret = <DiceThrowModifier>[];

    if(damageMalus() > 0) {
      ret.add(
        OneOffDiceThrowModifier(
          type: DiceThrowModifierType.damageMalus,
          label: 'Malus de dégâts',
          value: -damageMalus(),
          name: injuries.manager.getHighestInjuryLevel()!.name,
        )
      );
    }

    if(healthStatus.has(EntityHealthStatusFlag.stunned)) {
      ret.add(
        OneOffDiceThrowModifier(
          type: DiceThrowModifierType.healthStatus,
          label: 'Étourdi',
          value: -10,
          name: EntityHealthStatusFlag.stunned.name,
        )
      );
    }

    for(var mod in _throwModifiers.values) {
      if(mod.matcher == null || mod.matcher!.matches(request)) {
        ret.add(mod);
      }
    }

    // TODO: manage bonuses and temporary effects

    return ret;
  }

  @override
  bool meetsEquipableRequirements(EquipableItem item) {
    bool meets = true;
    for(var entry in item.equipRequirements().entries) {
      meets = abilities.ability(entry.key) >= entry.value;
      if(!meets) break;
    }
    return meets;
  }

  @override
  String unmetEquipableRequirementsDescription(EquipableItem item) {
    var ret = <String>[];
    for(var entry in item.equipRequirements().entries) {
      if(abilities.ability(entry.key) < entry.value) {
        ret.add('${entry.key.name} (${entry.value})');
      }
    }
    return ret.join(', ');
  }

  void addEquipment(Equipment eq) {
    equipment.add(eq);
  }
  void removeEquipment(Equipment eq) {
    if(!equipment.contains(eq)) return;

    if(eq is EquipableItem) unequip(eq);
    equipment.remove(eq);
  }

  void storeEquipment(Equipment eq) {
    if(eq is EquipableItem) unequip(eq);
    eq.inStore = true;
  }
  void unstoreEquipment(Equipment eq) {
    eq.inStore = false;
  }

  final List<DamageProvider> _naturalWeapons = <DamageProvider>[];

  void addNaturalWeapon(WeaponRange range, DamageProvider nw) {
    if(!_naturalWeapons.contains(nw)) _naturalWeapons.add(nw);
    addDamageProvider(range, nw);
  }

  final List<ProtectionProvider> _protectionProviders = <ProtectionProvider>[];

  void addProtectionProvider(ProtectionProvider pp) {
    _protectionProviders.add(pp);
  }
  void removeProtectionProvider(ProtectionProvider pp) {
    _protectionProviders.remove(pp);
  }

  final Map<WeaponRange, List<DamageProvider>> _damageProviders = <WeaponRange, List<DamageProvider>>{};

  void addDamageProvider(WeaponRange range, DamageProvider dp) {
    if(!_damageProviders.containsKey(range)) _damageProviders[range] = <DamageProvider>[];
    if(!_damageProviders[range]!.contains(dp)) _damageProviders[range]!.add(dp);
  }
  void removeDamageProvider(DamageProvider dp) {
    for(var range in _damageProviders.keys) {
      _damageProviders[range]!.remove(dp);
    }
  }
  List<DamageProvider> damageProvidersForRange(WeaponRange range) {
    return _damageProviders[range] ?? <DamageProvider>[];
  }
  List<DamageProvider> damageProviderForHand(EquipableItemSlot hand) {
    var ret = <DamageProvider>[];

    if(hand == EquipableItemSlot.dominantHand || hand == EquipableItemSlot.weakHand) {
      for(var eq in equipedForSlot(hand)) {
        if(eq is DamageProvider) {
          ret.add(eq as DamageProvider);
        }
      }
    }

    // Add the natural weapons
    // Only select hand-based natural weapons if hands are free
    if(ret.isEmpty) {
      for (var nw in _naturalWeapons) {
        if (nw is EquipableItem) {
          ret.add(nw);
        }
      }
    }

    return ret;
  }

  @Deprecated("No longer supported")
  (List<int>, int?) rollInitiatives({
    int additionalDices = 0,
  }) {
    var dominantHandInitiatives = List.generate(initiative + additionalDices, (index) => Random().nextInt(10) + 1);
    dominantHandInitiatives.sort((a, b) => b - a);
    if(additionalDices > 0) {
      dominantHandInitiatives = dominantHandInitiatives.sublist(0, initiative);
    }

    int? weakHandInitiative;
    for(var eq in equipedForSlot(EquipableItemSlot.weakHand)) {
      if(eq is InitiativeProvider) {
        weakHandInitiative = Random().nextInt(10) + 1;
        break;
      }
    }

    return (dominantHandInitiatives, weakHandInitiative);
  }

  static void preImportFilter(Map<String, dynamic> json) {
    if(json.containsKey('image') && json['image'] != null) {
      json['image'].remove('is_new');
    }

    if(json.containsKey('icon') && json['icon'] != null) {
      json['icon'].remove('is_new');
    }
  }

  @override
  Map<String, dynamic> toJson() {
    var j = _$EntityBaseToJson(this);
    saveNonExportableJson(j);
    return j;
  }

  factory EntityBase.fromJson(Map<String, dynamic> json) {
    EntityBase c = _$EntityBaseFromJson(json);
    c.loadNonRestorableJson(json);
    return c;
  }

  @mustCallSuper
  void saveNonExportableJson(Map<String, dynamic> json) {
  }

  @mustCallSuper
  void loadNonRestorableJson(Map<String, dynamic> json) {
    for(var eq in equipment) {
      if(eq is EquipableItem && eq.equipedOn != null) {
        equip(item: eq, target: eq.equipedOn!);
      }
    }
  }
}

InjuryManager entityBaseDefaultInjuries(EntityBase? entity, InjuryManager? source) {
  if(source == null) {
    return InjuryManager.simple(
      injuredCeiling: 30,
      injuredCount: 3,
      deathCount: 1,
      source: source
    );
  }
  else {
    return InjuryManager(
      levels: source.levels(),
      source: source,
    );
  }
}

Map<String, dynamic> enumKeyedMapToJson(Map<Enum, dynamic> m) {
  return <String, dynamic>{for(var k in m.keys) k.name: m[k]};
}