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

import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/ticker.dart';

typedef EntityEffectJsonFactory = EntityEffect Function(Map<String, dynamic>);

abstract class EntityEffect {
  EntityEffect({
    this.once,
    this.permanent,
    this.duration,
  })
  {
    if(once == null && permanent == null && duration == null) {
      throw(ArgumentError('One of "once", "permanent" or "duration" must be given'));
    }
  }

  final bool? once;
  final bool? permanent;
  final TickerDuration? duration;

  void apply(EntityBase entity);
  void unapply(EntityBase entity);
  Map<String, dynamic> effectToJson();

  factory EntityEffect.fromJson(Map<String, dynamic> json) {
    if(!json.containsKey('_type')) {
      throw(ArgumentError('Missing "_type" key in JSON'));
    }
    return _effectFactories[json['_type']]!(json);
  }

  Map<String, dynamic> toJson() {
    var ret = effectToJson();
    ret['_type'] = runtimeType.toString();
    return ret;
  }

  static void registerEntityEffectJsonFactory(String name, EntityEffectJsonFactory factory) =>
      _effectFactories[name] = factory;

  static Map<String, EntityEffectJsonFactory> _effectFactories =
      <String, EntityEffectJsonFactory>{};
}