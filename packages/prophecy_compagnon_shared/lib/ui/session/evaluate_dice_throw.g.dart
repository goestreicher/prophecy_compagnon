// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evaluate_dice_throw.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiceThrowEvaluation _$DiceThrowEvaluationFromJson(Map<String, dynamic> json) =>
    DiceThrowEvaluation(
      resultType: $enumDecode(
        _$DiceThrowResultTypeEnumMap,
        json['result_type'],
      ),
      criticalType: $enumDecode(
        _$DiceThrowResultTypeEnumMap,
        json['critical_type'],
      ),
      margin: (json['margin'] as num).toInt(),
      nr: (json['nr'] as num).toInt(),
      usedLuck: json['used_luck'] as bool,
    );

Map<String, dynamic> _$DiceThrowEvaluationToJson(
  DiceThrowEvaluation instance,
) => <String, dynamic>{
  'result_type': _$DiceThrowResultTypeEnumMap[instance.resultType]!,
  'critical_type': _$DiceThrowResultTypeEnumMap[instance.criticalType]!,
  'margin': instance.margin,
  'nr': instance.nr,
  'used_luck': instance.usedLuck,
};

const _$DiceThrowResultTypeEnumMap = {
  DiceThrowResultType.none: 'none',
  DiceThrowResultType.criticalFail: 'criticalFail',
  DiceThrowResultType.fail: 'fail',
  DiceThrowResultType.success: 'success',
  DiceThrowResultType.criticalSuccess: 'criticalSuccess',
};
