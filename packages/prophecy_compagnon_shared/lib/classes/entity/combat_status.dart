import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'combat_status.g.dart';

enum EntityCombatStatusFlag {
  none(value: 0, label: 'OK'),
  onGround(value: 1 << 1, label: 'Au sol'),
  grappled(value: 1 << 2, label: 'Saisi(e)'),
  ;

  final int value;
  final String label;

  const EntityCombatStatusFlag({ required this.value, required this.label });
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, constructor: 'fromBitfield')
class EntityCombatStatusValue {
  EntityCombatStatusValue.empty() : bitfield = 0;
  EntityCombatStatusValue(EntityCombatStatusFlag flag) : bitfield = flag.value;
  EntityCombatStatusValue.fromBitfield(this.bitfield);

  int bitfield;

  EntityCombatStatusValue operator &(EntityCombatStatusValue other) =>
      EntityCombatStatusValue.fromBitfield(other.bitfield & bitfield);

  EntityCombatStatusValue operator |(EntityCombatStatusValue other) =>
      EntityCombatStatusValue.fromBitfield(other.bitfield | bitfield);

  EntityCombatStatusValue operator ~() =>
      EntityCombatStatusValue.fromBitfield(~bitfield);

  @override
  bool operator ==(Object other) =>
      other is EntityCombatStatusValue && other.bitfield == bitfield;

  @override
  int get hashCode => bitfield;

  factory EntityCombatStatusValue.fromJson(Map<String, dynamic> json) =>
      _$EntityCombatStatusValueFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EntityCombatStatusValueToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class EntityCombatStatus with ChangeNotifier {
  EntityCombatStatus({ required EntityCombatStatusValue value }) : _value = value;
  EntityCombatStatus.empty() : _value = EntityCombatStatusValue(EntityCombatStatusFlag.none);

  @JsonKey(defaultValue: EntityCombatStatusValue.empty)
  EntityCombatStatusValue get value => _value;
  set value(EntityCombatStatusValue v) {
    _value = v;
    notifyListeners();
  }

  EntityCombatStatusValue _value;

  bool has(EntityCombatStatusFlag status) =>
      (value & EntityCombatStatusValue(status)).bitfield != EntityCombatStatusFlag.none.value;

  void add(EntityCombatStatusFlag status) =>
      value = _value | EntityCombatStatusValue(status);

  void clear(EntityCombatStatusFlag status) =>
      value = _value & ~EntityCombatStatusValue(status);

  factory EntityCombatStatus.fromJson(Map<String, dynamic> json) =>
      _$EntityCombatStatusFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EntityCombatStatusToJson(this);
}