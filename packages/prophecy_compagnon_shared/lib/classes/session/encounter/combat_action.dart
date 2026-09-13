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

import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action_type.dart';
import 'package:prophecy_compagnon_shared/classes/session/entity_effect.dart';

typedef CombatActionJsonFactory = CombatAction Function(Map<String, dynamic>);

abstract class CombatAction {
  CombatAction({
    required this.entityId,
    required this.type,
    required this.rank,
    this.interpolate = false,
    this.effects = const <EntityEffect>[],
  });

  final String entityId;
  final CombatActionType type;
  final int rank;
  final bool interpolate;
  final List<EntityEffect> effects;

  Map<String, dynamic> combatActionToJson();

  CombatAction? lerp(int rank, double x) => null;

  factory CombatAction.fromJson(Map<String, dynamic> json) {
    if(!json.containsKey('_type')) {
      throw(ArgumentError('Missing "_type" key in JSON'));
    }
    return _combatActionFactories[json['_type']]!(json);
  }

  Map<String, dynamic> toJson() {
    var ret = combatActionToJson();
    ret['_type'] = runtimeType.toString();
    return ret;
  }

  static void registerCombatActionJsonFactory(String name, CombatActionJsonFactory factory) =>
      _combatActionFactories[name] = factory;

  static Map<String, CombatActionJsonFactory> _combatActionFactories =
      <String, CombatActionJsonFactory>{};
}