// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_disadvantage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterDisadvantage _$CharacterDisadvantageFromJson(
  Map<String, dynamic> json,
) => CharacterDisadvantage(
  disadvantage: $enumDecode(_$DisadvantageEnumMap, json['disadvantage']),
  cost: (json['cost'] as num).toInt(),
  details: json['details'] as String,
);

Map<String, dynamic> _$CharacterDisadvantageToJson(
  CharacterDisadvantage instance,
) => <String, dynamic>{
  'disadvantage': _$DisadvantageEnumMap[instance.disadvantage]!,
  'cost': instance.cost,
  'details': instance.details,
};

const _$DisadvantageEnumMap = {
  Disadvantage.anomalie: 'anomalie',
  Disadvantage.complexeDInferiorite: 'complexeDInferiorite',
  Disadvantage.curiositeMageVents: 'curiositeMageVents',
  Disadvantage.dette: 'dette',
  Disadvantage.echec: 'echec',
  Disadvantage.emotif: 'emotif',
  Disadvantage.ennemi: 'ennemi',
  Disadvantage.faiblesse: 'faiblesse',
  Disadvantage.fragilite: 'fragilite',
  Disadvantage.instinctSuperieur: 'instinctSuperieur',
  Disadvantage.interdit: 'interdit',
  Disadvantage.interditsDeBrorne: 'interditsDeBrorne',
  Disadvantage.maladie: 'maladie',
  Disadvantage.malchance: 'malchance',
  Disadvantage.maledictionDeKezyr: 'maledictionDeKezyr',
  Disadvantage.maledictionDeNenya: 'maledictionDeNenya',
  Disadvantage.manie: 'manie',
  Disadvantage.marqueDeNenya: 'marqueDeNenya',
  Disadvantage.mauvaiseReputation: 'mauvaiseReputation',
  Disadvantage.obsession: 'obsession',
  Disadvantage.phobie: 'phobie',
  Disadvantage.phobieDesCites: 'phobieDesCites',
  Disadvantage.serment: 'serment',
  Disadvantage.amnesie: 'amnesie',
  Disadvantage.appelDeLaBete: 'appelDeLaBete',
  Disadvantage.autocrate: 'autocrate',
  Disadvantage.blessure: 'blessure',
  Disadvantage.dependance: 'dependance',
  Disadvantage.deviance: 'deviance',
  Disadvantage.echecRare: 'echecRare',
  Disadvantage.ennemiRare: 'ennemiRare',
  Disadvantage.harmonieNaturelle: 'harmonieNaturelle',
  Disadvantage.incompetence: 'incompetence',
  Disadvantage.infirmite: 'infirmite',
  Disadvantage.maladresse: 'maladresse',
  Disadvantage.marqueAuFer: 'marqueAuFer',
  Disadvantage.mauvaisOeil: 'mauvaisOeil',
  Disadvantage.personneACharge: 'personneACharge',
  Disadvantage.regardDesDragons: 'regardDesDragons',
  Disadvantage.traumatismeMental: 'traumatismeMental',
  Disadvantage.troubleMental: 'troubleMental',
  Disadvantage.chetif: 'chetif',
  Disadvantage.curiosite: 'curiosite',
  Disadvantage.illusions: 'illusions',
  Disadvantage.insignifiant: 'insignifiant',
  Disadvantage.lassitude: 'lassitude',
  Disadvantage.mensongesInfantiles: 'mensongesInfantiles',
  Disadvantage.naivete: 'naivete',
  Disadvantage.revolte: 'revolte',
  Disadvantage.transfert: 'transfert',
  Disadvantage.versatilite: 'versatilite',
  Disadvantage.cardiaque: 'cardiaque',
  Disadvantage.edente: 'edente',
  Disadvantage.grincheux: 'grincheux',
  Disadvantage.impotent: 'impotent',
  Disadvantage.maladeImaginaire: 'maladeImaginaire',
  Disadvantage.nostalgieObsessionnelle: 'nostalgieObsessionnelle',
  Disadvantage.rhumatismes: 'rhumatismes',
  Disadvantage.senile: 'senile',
  Disadvantage.surdite: 'surdite',
  Disadvantage.vueDefaillante: 'vueDefaillante',
};
