// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'human_character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterOrigin _$CharacterOriginFromJson(Map<String, dynamic> json) =>
    CharacterOrigin(
      uuid: json['uuid'] as String?,
      place: json['place'] == null
          ? null
          : Place.fromJson(json['place'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CharacterOriginToJson(CharacterOrigin instance) =>
    <String, dynamic>{'uuid': instance.uuid};

HumanCharacter _$HumanCharacterFromJson(
  Map<String, dynamic> json,
) => HumanCharacter(
  uuid: json['uuid'] as String?,
  name: json['name'] as String,
  source: ObjectSource.fromJson(json['source'] as Map<String, dynamic>),
  location: json['location'] == null
      ? ObjectLocation.memory
      : ObjectLocation.fromJson(json['location'] as Map<String, dynamic>),
  abilities: json['abilities'] == null
      ? null
      : EntityAbilities.fromJson(json['abilities'] as Map<String, dynamic>),
  attributes: json['attributes'] == null
      ? null
      : EntityAttributes.fromJson(json['attributes'] as Map<String, dynamic>),
  initiative: (json['initiative'] as num?)?.toInt() ?? 1,
  injuries: json['injuries'] == null
      ? null
      : EntityInjuries.fromJson(json['injuries'] as Map<String, dynamic>),
  size: (json['size'] as num?)?.toDouble(),
  description: json['description'] as String?,
  skills: json['skills'] == null
      ? null
      : EntitySkills.fromJson(json['skills'] as Map<String, dynamic>),
  healthStatus: json['health_status'] == null
      ? null
      : EntityHealthStatus.fromJson(
          json['health_status'] as Map<String, dynamic>,
        ),
  combatStatus: json['combat_status'] == null
      ? null
      : EntityCombatStatus.fromJson(
          json['combat_status'] as Map<String, dynamic>,
        ),
  equipment: EntityEquipment.fromJson(json['equipment'] as List),
  money: json['money'] == null
      ? null
      : MoneyWallet.fromJson(json['money'] as Map<String, dynamic>),
  magic: json['magic'] == null
      ? null
      : EntityMagic.fromJson(json['magic'] as Map<String, dynamic>),
  favors: EntityDraconicFavors.fromJson(
    EntityDraconicFavors.readFavorsFromJson(json, 'favors') as List,
  ),
  fervor: json['fervor'] == null
      ? null
      : EntityFervor.fromJson(json['fervor'] as Map<String, dynamic>),
  image: json['image'] == null
      ? null
      : ExportableBinaryData.fromJson(json['image'] as Map<String, dynamic>),
  icon: json['icon'] == null
      ? null
      : ExportableBinaryData.fromJson(json['icon'] as Map<String, dynamic>),
  caste: json['caste'] == null
      ? null
      : CharacterCaste.fromJson(json['caste'] as Map<String, dynamic>),
  honoraryCaste: json['honorary_caste'] == null
      ? null
      : CharacterCaste.fromJson(json['honorary_caste'] as Map<String, dynamic>),
  luck: (json['luck'] as num?)?.toInt() ?? 0,
  usedLuck: (json['used_luck'] as num?)?.toInt() ?? 0,
  proficiency: (json['proficiency'] as num?)?.toInt() ?? 0,
  usedProficiency: (json['used_proficiency'] as num?)?.toInt() ?? 0,
  renown: (json['renown'] as num?)?.toInt() ?? 0,
  age: (json['age'] as num?)?.toInt() ?? 25,
  height: (json['height'] as num?)?.toDouble() ?? 1.7,
  weight: (json['weight'] as num?)?.toDouble() ?? 60.0,
  origin: json['origin'] == null
      ? null
      : CharacterOrigin.fromJson(json['origin'] as Map<String, dynamic>),
  disadvantages: CharacterDisadvantages.fromJson(
    json['disadvantages'] as List?,
  ),
  advantages: CharacterAdvantages.fromJson(json['advantages'] as List?),
  tendencies: json['tendencies'] == null
      ? null
      : CharacterTendencies.fromJson(
          json['tendencies'] as Map<String, dynamic>,
        ),
  draconicLink: json['draconic_link'] == null
      ? null
      : DraconicLink.fromJson(json['draconic_link'] as Map<String, dynamic>),
);

Map<String, dynamic> _$HumanCharacterToJson(HumanCharacter instance) =>
    <String, dynamic>{
      'source': instance.source.toJson(),
      'name': instance.name,
      'uuid': ?instance.uuid,
      'abilities': instance.abilities.toJson(),
      'attributes': instance.attributes.toJson(),
      'initiative': instance.initiative,
      'injuries': instance.injuries.toJson(),
      'size': instance.size,
      'description': instance.description,
      'skills': instance.skills.toJson(),
      'health_status': instance.healthStatus.toJson(),
      'combat_status': instance.combatStatus.toJson(),
      'equipment': EntityEquipment.toJson(instance.equipment),
      'money': instance.money.toJson(),
      'magic': instance.magic.toJson(),
      'favors': EntityDraconicFavors.toJson(instance.favors),
      'fervor': instance.fervor.toJson(),
      'image': instance.image?.toJson(),
      'icon': instance.icon?.toJson(),
      'caste': instance.caste.toJson(),
      'honorary_caste': instance.honoraryCaste?.toJson(),
      'age': instance.age,
      'height': instance.height,
      'weight': instance.weight,
      'origin': instance.origin.toJson(),
      'luck': instance.luck,
      'used_luck': instance.usedLuck,
      'proficiency': instance.proficiency,
      'used_proficiency': instance.usedProficiency,
      'renown': instance.renown,
      'disadvantages': CharacterDisadvantages.toJson(instance.disadvantages),
      'advantages': CharacterAdvantages.toJson(instance.advantages),
      'tendencies': instance.tendencies.toJson(),
      'draconic_link': instance.draconicLink.toJson(),
    };
