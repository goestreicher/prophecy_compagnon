// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_advantage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterAdvantage _$CharacterAdvantageFromJson(Map<String, dynamic> json) =>
    CharacterAdvantage(
      advantage: $enumDecode(_$AdvantageEnumMap, json['advantage']),
      cost: (json['cost'] as num).toInt(),
      details: json['details'] as String,
    );

Map<String, dynamic> _$CharacterAdvantageToJson(CharacterAdvantage instance) =>
    <String, dynamic>{
      'advantage': _$AdvantageEnumMap[instance.advantage]!,
      'cost': instance.cost,
      'details': instance.details,
    };

const _$AdvantageEnumMap = {
  Advantage.adopteParLAssemblee: 'adopteParLAssemblee',
  Advantage.agilite: 'agilite',
  Advantage.allie: 'allie',
  Advantage.ambidextre: 'ambidextre',
  Advantage.armeDuMaitre: 'armeDuMaitre',
  Advantage.augureFavorable: 'augureFavorable',
  Advantage.chance: 'chance',
  Advantage.charme: 'charme',
  Advantage.codeDeTruands: 'codeDeTruands',
  Advantage.confidences: 'confidences',
  Advantage.corpsAguerri: 'corpsAguerri',
  Advantage.droiture: 'droiture',
  Advantage.figureDuMilieu: 'figureDuMilieu',
  Advantage.fortunePersonnelle: 'fortunePersonnelle',
  Advantage.heritageDraconique: 'heritageDraconique',
  Advantage.humaniste: 'humaniste',
  Advantage.lienAssemblee: 'lienAssemblee',
  Advantage.lienSalamandres: 'lienSalamandres',
  Advantage.magieIntuitive: 'magieIntuitive',
  Advantage.magieNaturelle: 'magieNaturelle',
  Advantage.mentor: 'mentor',
  Advantage.present: 'present',
  Advantage.prestance: 'prestance',
  Advantage.pressentiment: 'pressentiment',
  Advantage.resistanceALaMagie: 'resistanceALaMagie',
  Advantage.salamandre: 'salamandre',
  Advantage.santeDeFer: 'santeDeFer',
  Advantage.sensAccru: 'sensAccru',
  Advantage.sensDeLOrientation: 'sensDeLOrientation',
  Advantage.sensEnAlerte: 'sensEnAlerte',
  Advantage.statutSocial: 'statutSocial',
  Advantage.surprise: 'surprise',
  Advantage.chanceInouie: 'chanceInouie',
  Advantage.empathieNaturelle: 'empathieNaturelle',
  Advantage.faeGardienne: 'faeGardienne',
  Advantage.fetiche: 'fetiche',
  Advantage.instinctProtecteur: 'instinctProtecteur',
  Advantage.precoce: 'precoce',
  Advantage.artInterdit: 'artInterdit',
  Advantage.conviction: 'conviction',
  Advantage.culture: 'culture',
  Advantage.habileteReconnue: 'habileteReconnue',
  Advantage.objetDePredilection: 'objetDePredilection',
  Advantage.techniquePersonnelle: 'techniquePersonnelle',
};
