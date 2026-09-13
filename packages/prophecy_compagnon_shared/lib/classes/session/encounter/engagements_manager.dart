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

import 'package:prophecy_compagnon_shared/classes/combat.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/string_pair_map_key.dart';

class EngagementsManager {
  EngagementsManager(List<(String, String, WeaponRange)>? engagements)
    : _engagements = <StringPairMapKey, WeaponRange>{}
  {
    for(var rec in engagements ?? []) {
      var k = StringPairMapKey(rec.$1, rec.$2);
      _engagements[k] = rec.$3;
    }
  }

  void engage(EntityBase attacker, EntityBase defender, WeaponRange range) {
    var k = StringPairMapKey(attacker.id, defender.id);

    if(!_engagements.containsKey(k) || _engagements[k]!.index > range.index) {
      _engagements[k] = range;
    }
  }

  void disengage(EntityBase attacker, EntityBase defender, { WeaponRange? newRange }) {
    var k = StringPairMapKey(attacker.id, defender.id);
    if(!_engagements.containsKey(k)) return;

    if(newRange != null && newRange.index > _engagements[k]!.index) {
      _engagements[k] = newRange;
    }
    else {
      _engagements.remove(k);
    }
  }

  Iterable<WeaponRange> allFor(EntityBase entity) =>
    _engagements.entries
      .where(
        (MapEntry<StringPairMapKey, WeaponRange> e) =>
            e.key.pair.$1 == entity.id || e.key.pair.$2 == entity.id
      )
      .map((MapEntry<StringPairMapKey, WeaponRange> e) => e.value);

  WeaponRange? smallestFor(EntityBase entity) {
    Iterable<WeaponRange> all = allFor(entity);

    if(all.isEmpty) return null;
    if(all.length == 1) return all.elementAt(0);

    return all.reduce(
      (WeaponRange current, WeaponRange next) =>
        current.index < next.index ? current : next
    );
  }

  final Map<StringPairMapKey, WeaponRange> _engagements;

  factory EngagementsManager.fromJson(List<dynamic> json) {
    var arg = <(String, String, WeaponRange)>[];

    for(var e in json) {
      if(e is! List) {
        throw(ArgumentError('Element is not a list in JSON for engagement'));
      }
      if(e.length != 3) {
        throw(ArgumentError('Wrong length for the list to decode as an engagement'));
      }

      arg.add((
        e[0] as String,
        e[1] as String,
        WeaponRange.values.byName(e[2]),
      ));
    }

    return EngagementsManager(arg);
  }

  List<List<String>> toJson() {
    var ret = <List<String>>[];

    for(var e in _engagements.entries) {
      ret.add([
        e.key.pair.$1,
        e.key.pair.$2,
        e.value.name,
      ]);
    }

    return ret;
  }
}