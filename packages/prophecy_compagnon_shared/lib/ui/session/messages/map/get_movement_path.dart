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

import 'package:prophecy_compagnon_shared/ui/session/messages/map/session_action_map.dart';

class SessionMapGetMovementPath extends SessionActionMapMessage {
  SessionMapGetMovementPath({
    super.source,
    required super.destination,
    super.waitResponseTimeout,
    required this.entityId,
    this.distanceMultiplier = 1.0,
  });

  final String entityId;
  final double distanceMultiplier;
}

class SessionMapCancelGetMovementPath extends SessionActionMapMessage {
  SessionMapCancelGetMovementPath({
    super.source,
    required super.destination,
    required this.entityId,
    this.cancelReason,
  })
    : super(hasResponse: false);

  final String entityId;
  final String? cancelReason;
}