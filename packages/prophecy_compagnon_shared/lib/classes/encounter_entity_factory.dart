/*
 * Copyright (C) 2024-2026 Grégory Oestreicher
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

import 'package:prophecy_compagnon_shared/classes/entity_instance.dart';

mixin EncounterEntityModel {
  String displayName();
  bool isUnique();
  List<EntityInstance> instantiate({ int count = 1 });
}

class EncounterEntityFactory {
  static final EncounterEntityFactory instance = EncounterEntityFactory._create();

  void registerFactory(
    String id,
    Future<EncounterEntityModel?> Function(String) modelFactory,
    Future<Iterable<EntityInstance>> Function(String, int) instanceFactory,
  ) {
    _modelFactories[id] = modelFactory;
    _instanceFactories[id] = instanceFactory;
  }

  bool hasFactory(String id) => _instanceFactories.containsKey(id);

  Future<EncounterEntityModel?> Function(String)? getModelFactory(String id) =>
      _modelFactories[id];

  Future<EncounterEntityModel?> getModel(String id) async {
    var split = id.split(':');
    if(split.length < 2) return null;
    if(!_modelFactories.containsKey(split[0])) return null;
    return _modelFactories[split[0]]!(split[1]);
  }

  Future<Iterable<EntityInstance>> Function(String, int)? getInstanceFactory(String id) =>
      _instanceFactories[id];

  EncounterEntityFactory._create();

  static final Map<String, Future<Iterable<EntityInstance>> Function(String, int)> _instanceFactories = {};
  static final Map<String, Future<EncounterEntityModel?> Function(String)> _modelFactories = {};
}