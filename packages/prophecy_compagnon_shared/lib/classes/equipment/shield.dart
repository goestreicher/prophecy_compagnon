/*
 * Copyright (C) 2026 Grégory Oestreicher
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

import 'package:json_annotation/json_annotation.dart';
import 'package:prophecy_compagnon_shared/classes/combat.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_matchers/skill_family.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_modifier.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_modifier_type.dart';
import 'package:prophecy_compagnon_shared/classes/entity/abilities.dart';
import 'package:prophecy_compagnon_shared/classes/entity/base.dart';
import 'package:prophecy_compagnon_shared/classes/entity/skill_family.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/enums.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/equipment.dart';
import 'package:prophecy_compagnon_shared/classes/object_location.dart';
import 'package:prophecy_compagnon_shared/classes/object_source.dart';
import 'package:prophecy_compagnon_shared/classes/storage/default_assets_store.dart';
import 'package:prophecy_compagnon_shared/classes/storage/storable.dart';
import 'package:synchronized/synchronized.dart';
import 'package:uuid/uuid.dart';

part 'shield.g.dart';

class ShieldModelStore extends JsonStoreAdapter<ShieldModel> {
  @override
  String storeCategory() => 'shieldModels';

  @override
  String key(ShieldModel object) => object.uuid;

  @override
  Future<ShieldModel> fromJsonRepresentation(Map<String, dynamic> j) async =>
      ShieldModel.fromJson(j);

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(ShieldModel object) async =>
      object.toJson();
}

class _ShieldFactoryImplementation implements EquipmentFactoryImplementation {
  @override
  EquipmentModel? fromJson(Map<String, dynamic> json) =>
      ShieldModel.fromJson(json);

  @override
  EquipmentModel? model(String id) {
    return ShieldModel.get(id);
  }

  @override
  Equipment? forge(String id, Map<String, dynamic>? json) {
    var m = ShieldModel.get(id);
    if(m == null) return null;

    if(json != null && json.containsKey('uuid')) {
      return Shield(json['uuid'], model: m);
    }
    else {
      return Shield.create(model: m);
    }
  }

  @override
  Future<void> saveLocalModel(EquipmentModel model) async {
    if(model is! ShieldModel) return;
    await ShieldModel.saveLocalModel(model);
  }

  @override
  Future<void> deleteLocalModel(EquipmentModel model) async {
    if(model is! ShieldModel) return;
    await ShieldModel.deleteLocalModel(model.uuid);
  }

  @override
  Future<void> reloadFromStore(String uuid) async {
    await ShieldModel.reloadFromStore(uuid);
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ShieldModel extends EquipableItemModel {
  factory ShieldModel({
    required String uuid,
    required String name,
    bool unique = false,
    required ObjectSource source,
    ObjectLocation location = ObjectLocation.memory,
    String description = '',
    required double weight,
    required int creationDifficulty,
    required int creationTime,
    required EquipmentAvailability villageAvailability,
    required EquipmentAvailability cityAvailability,
    EquipableItemSlot slot = EquipableItemSlot.hands,
    int handiness = 1,
    EquipableItemLayer layer = EquipableItemLayer.normal,
    required Map<Ability, int> requirements,
    required int protection,
    required int penalty,
    required AttributeBasedCalculator damage,
    bool supportsMetal = false,
    EquipmentQuality? intrinsicResistance,
    List<EquipmentSpecialCapability>? special,
  })
  {
    var sm = _cache[uuid]
        ?? ShieldModel._create(
            uuid: uuid,
            name: name,
            unique: unique,
            source: source,
            location: location,
            description: description,
            weight: weight,
            creationDifficulty: creationDifficulty,
            creationTime: creationTime,
            villageAvailability: villageAvailability,
            cityAvailability: cityAvailability,
            slot: slot,
            handiness: handiness,
            layer: layer,
            requirements: requirements,
            protection: protection,
            penalty: penalty,
            damage: damage,
            supportsMetal: supportsMetal,
            intrinsicResistance: intrinsicResistance,
            special: special,
        );
    _cache[sm.uuid] = sm;
    return sm;
  }

  ShieldModel._create({
    required super.uuid,
    required super.name,
    super.unique,
    required super.source,
    super.location,
    super.description,
    required super.weight,
    required super.creationDifficulty,
    required super.creationTime,
    required super.villageAvailability,
    required super.cityAvailability,
    super.slot = EquipableItemSlot.hands,
    super.handiness = 1,
    super.layer,
    required this.requirements,
    required this.protection,
    required this.penalty,
    required this.damage,
    super.supportsMetal,
    super.intrinsicResistance,
    super.special,
  });

  Map<Ability, int> requirements;
  int protection;
  int penalty;
  AttributeBasedCalculator damage;

  @JsonKey(includeToJson: true)
  @override
  String get factory => 'shield';

  Shield instantiate() {
    return Shield.create(model: this);
  }

  static Iterable<String> ids() => _cache.keys;

  static ShieldModel? get(String id) => _cache[id];

  static Future<void> init() async {
    // ignore:unused_local_variable
    var c = _cache;
    await loadAll();
  }

  static Future<void> loadAll() async {
    EquipmentFactory.instance.registerFactory('shield', _ShieldFactoryImplementation());

    await _loadLock.synchronized(() async {
      var assetFiles = [
        'shield.json',
      ];

      for (var f in assetFiles) {
        for (var model in await loadJSONAssetObjectList(f)) {
          try {
            // ignore:unused_local_variable
            var instance = ShieldModel.fromJson(model);
            _cache[instance.uuid] = instance;
          } catch (e, stacktrace) {
            print('Error loading shield ${model["name"]}: ${e.toString()}\n${stacktrace.toString()}');
          }
        }
      }

      for(var instance in (await ShieldModelStore().getAll())) {
        _cache[instance.uuid] = instance;
      }
    });
  }

  static Future<void> saveLocalModel(ShieldModel shield) async {
    await ShieldModelStore().save(shield);
    _cache[shield.uuid] = shield;
  }

  static Future<void> deleteLocalModel(String id) async {
    var shield = await ShieldModelStore().get(id);
    if(shield != null) await ShieldModelStore().delete(shield);
    _cache.remove(id);
  }

  static Future<void> reloadFromStore(String id) async {
    var m = await ShieldModelStore().get(id);
    if(m != null) _cache[id] = m;
  }

  static final Map<String, ShieldModel> _cache = <String, ShieldModel>{};
  static final _loadLock = Lock();

  factory ShieldModel.fromJson(Map<String, dynamic> json) =>
      _$ShieldModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$ShieldModelToJson(this);
}

class Shield extends EquipableItem implements ProtectionProvider, DamageProvider {
  Shield(this._uuid, {
    required super.model,
    super.alias,
    super.quality,
    super.metal,
  })
  {
    _diceThrowModifier = EquipmentDiceThrowModifier(
      type: DiceThrowModifierType.malus,
      family: DiceThrowModifierFamily.movementPenalty,
      label: 'Encombrement (${model.name})',
      value: (model as ShieldModel).penalty,
      matcher: SkillFamilyDiceThrowMatcher(
        family: SkillFamily.mouvement,
      ),
      equipment: this,
    );
  }

  factory Shield.create({
    required EquipmentModel model,
    String? alias,
    EquipmentQuality quality = EquipmentQuality.normal,
    EquipmentMetal metal = EquipmentMetal.none,
  }) => Shield(
          const Uuid().v4().toString(),
          model: model,
          alias: alias,
          quality: quality,
          metal: metal,
        );

  final String _uuid;

  @override
  String uuid() => _uuid;

  @override
  Map<Ability, int> equipRequirements() => (model as ShieldModel).requirements;

  @override
  void equiped(SupportsEquipableItem owner, EquipableItemSlot target) {
    super.equiped(owner, target);

    if(owner is EntityBase) {
      owner.addProtectionProvider(this);
      owner.addDamageProvider(WeaponRange.contact, this);
      owner.addDamageProvider(WeaponRange.melee, this);

      if((model as ShieldModel).penalty < 0) {
        owner.addThrowModifier(_diceThrowModifier);
      }
    }
  }

  @override
  void unequiped(SupportsEquipableItem owner) {
    super.unequiped(owner);

    if(owner is EntityBase) {
      owner.removeProtectionProvider(this);
      owner.removeDamageProvider(this);
      owner.removeThrowModifier(_diceThrowModifier.id);
    }
  }

  @override
  int protection() => (model as ShieldModel).protection;

  @override
  int damage(EntityBase owner, {List<int>? throws }) =>
      (model as ShieldModel).damage.calculate(
          (model as ShieldModel).damage.ability != null
            ? owner.abilities.ability((model as ShieldModel).damage.ability!)
            : 0,
        throws: throws
      ).toInt();

  late final EquipmentDiceThrowModifier _diceThrowModifier;
}
