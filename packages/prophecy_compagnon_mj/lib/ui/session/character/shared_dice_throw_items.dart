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

import 'package:prophecy_compagnon_mj/ui/session/character/dice_throw_menu_item.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_entity_base/ability.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_entity_base/luck.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_entity_base/skill.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_entity_base/threshold.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/entity/abilities.dart';
import 'package:prophecy_compagnon_shared/classes/entity/attributes.dart';
import 'package:prophecy_compagnon_shared/classes/entity/skill.dart';

final Map<String, List<DiceThrowMenuItem>> sharedDiceThrowItems = {
  'discretion': [
    DiceThrowMenuItem(
      label: 'Discrétion',
      canChangeDifficulty: true,
      request: DiceThrowRequest(
        type: DiceThrowRequestType.simple,
        context: DiceThrowRequestContext.discretion,
        difficulty: 15,
        base: DiceThrowEntityBaseSkill(
          attribute: Attribute.physique,
          skill: Skill.discretion,
          ability: Ability.coordination,
        ),
      ),
    ),
  ],
  'luck': [
    DiceThrowMenuItem(
      label: 'Chance (inf. ou égal)',
      canChangeDifficulty: false,
      request: DiceThrowRequest(
        type: DiceThrowRequestType.threshold,
        context: DiceThrowRequestContext.luck,
        base: DiceThrowEntityBaseThresholdLuck(
          comparison: DiceThrowThresholdComparison.lowerThanOrEqual,
        ),
      ),
    ),
    DiceThrowMenuItem(
      label: 'Chance + 1D10',
      canChangeDifficulty: false,
      request: DiceThrowRequest(
        type: DiceThrowRequestType.raw,
        context: DiceThrowRequestContext.luck,
        base: DiceThrowEntityBaseLuck(),
      ),
      canUseProficiency: false,
      canUseTendencies: false,
      canUseLuck: false,
    ),
  ],
  'perception': [
    for(var attr in [Attribute.mental, Attribute.manuel])
      DiceThrowMenuItem(
        label: 'Perception (${attr.title})',
        canChangeDifficulty: true,
        request: DiceThrowRequest(
          type: DiceThrowRequestType.simple,
          context: DiceThrowRequestContext.perception,
          difficulty: 15,
          base: DiceThrowEntityBaseAbility(
            attribute: attr,
            ability: Ability.perception,
          ),
        ),
        difficultyHints: {
          'Cible de grande taille ou très bruyante': 10,
          "La cible manque d'évidence sans être précisément dissimulée": 15,
          "La cible prend soin de se cacher ou a été cachée rapidement": 20,
          "La cible est minuscule ou presque invisible": 25,
          "La cible est indétectable sans recherche poussée": 30,
          "La cible est indétectable par un humain non averti": 35,
        },
        contextModifierHints: _perceptionContextModifierHints,
      ),
  ]
};

const _perceptionContextModifierHints = [
  "Personnage en alerte : +1 à +4",
  "Personnage attentif : +1 à +3",
  "Personnage fatigué, distrait : -1 à -2",
  "En pleine agitation : -1 à -3",
  "En plein chaos : -3 à -5",
  "Recherche à la hâte : -1 à -3",
  "Recherche soigneuse : +1 à +3",
  "Mauvaise visibilité : -1 à -5",
  "Dans l'obscurité presque totale : -10",
];