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

// TODO: implement limits on who can send these messages (master and the client controlling the entity)
import 'package:prophecy_compagnon_shared/classes/session/messages/session_status_message.dart';

abstract class SessionEntityStatusMessage extends SessionStatusMessage {
  SessionEntityStatusMessage({
    super.source,
    super.broadcastIncludesSelf,
    required this.entityId,
  });

  final String entityId;
}