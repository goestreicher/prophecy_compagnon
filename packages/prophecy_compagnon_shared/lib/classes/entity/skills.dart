/*
 * Copyright (C) 2025-2026 Grégory Oestreicher
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

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:prophecy_compagnon_shared/classes/entity/skill.dart';
import 'package:prophecy_compagnon_shared/classes/entity/skill_family.dart';
import 'package:prophecy_compagnon_shared/classes/entity/skill_instance.dart';

part 'skills.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class EntitySkillFamily with ChangeNotifier {
  EntitySkillFamily({ required this.all });

  EntitySkillFamily.empty() : all = <SkillInstance>[];

  SkillInstance? skill(Skill s, { String? implementation }) {
    var idx = all.indexWhere(
        (SkillInstance i) =>
            i.skill == s
            && (implementation == null || implementation == i.implementation)
    );
    return idx >= 0
        ? all[idx]
        : null;
  }

  void add(SkillInstance instance) {
    var i = skill(instance.skill, implementation: instance.implementation);
    if(i == null) {
      all.add(instance);
      notifyListeners();
    }
  }

  void del(SkillInstance instance) {
    all.removeWhere(
        (SkillInstance i) =>
            i.skill == instance.skill
            && i.implementation == instance.implementation
    );
    notifyListeners();
  }

  List<SkillInstance> all;

  factory EntitySkillFamily.fromJson(Map<String, dynamic> json) =>
      _$EntitySkillFamilyFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EntitySkillFamilyToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class EntitySkills {
  EntitySkills({
    Map<SkillFamily, EntitySkillFamily>? families
  })
  {
    this.families = families ?? <SkillFamily, EntitySkillFamily>{};
    for(var f in SkillFamily.values) {
      if(!this.families.containsKey(f)) {
        this.families[f] = EntitySkillFamily.empty();
      }
    }
  }

  EntitySkills.empty()
  {
    families = Map.fromEntries(
        SkillFamily.values.map(
                (SkillFamily f) => MapEntry(f, EntitySkillFamily.empty())
        )
    );
  }

  EntitySkillFamily get combat => families[SkillFamily.combat]!;
  EntitySkillFamily get mouvement => families[SkillFamily.mouvement]!;
  EntitySkillFamily get theorie => families[SkillFamily.theorie]!;
  EntitySkillFamily get pratique => families[SkillFamily.pratique]!;
  EntitySkillFamily get technique => families[SkillFamily.technique]!;
  EntitySkillFamily get manipulation => families[SkillFamily.manipulation]!;
  EntitySkillFamily get communication => families[SkillFamily.communication]!;
  EntitySkillFamily get influence => families[SkillFamily.influence]!;

  List<SkillInstance> get all => [
    ...combat.all,
    ...mouvement.all,
    ...theorie.all,
    ...pratique.all,
    ...technique.all,
    ...manipulation.all,
    ...communication.all,
    ...influence.all,
  ];

  SkillInstance? skill(Skill s, { String? implementation }) =>
      families[s.family]!.skill(s, implementation: implementation);

  void add(SkillInstance i) => families[i.skill.family]!.add(i);

  void del(SkillInstance i) => families[i.skill.family]!.del(i);

  Iterable<SkillInstance> forFamily(SkillFamily family) =>
      families[family]!.all;

  late final Map<SkillFamily, EntitySkillFamily> families;

  factory EntitySkills.fromJson(Map<String, dynamic> json) =>
      _$EntitySkillsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EntitySkillsToJson(this);
}