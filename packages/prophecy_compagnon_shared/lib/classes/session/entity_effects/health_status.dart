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

import 'package:prophecy_compagnon_shared/classes/entity/health_status.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/session/entity_effect.dart';

class EffectSetHealthStatus extends EntityEffect {
  EffectSetHealthStatus({
    required this.status,
  })
    : super(once: true);

  final EntityHealthStatusFlag status;

  @override
  void apply(EntityBase entity) => entity.healthStatus.add(status);

  @override
  void unapply(EntityBase entity) {}
}

class EffectClearHealthStatus extends EntityEffect {
  EffectClearHealthStatus({
    required this.status,
  })
    : super(once: true);

  final EntityHealthStatusFlag status;

  @override
  void apply(EntityBase entity) => entity.healthStatus.clear(status);

  @override
  void unapply(EntityBase entity) {}
}