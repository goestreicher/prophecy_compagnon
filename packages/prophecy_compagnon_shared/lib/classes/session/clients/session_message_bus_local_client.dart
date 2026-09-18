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

import 'package:prophecy_compagnon_shared/classes/session/clients/session_message_bus_client.dart';
import 'package:prophecy_compagnon_shared/classes/session/game_session.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/management/request_master.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/session_message_response.dart';
import 'package:prophecy_compagnon_shared/classes/settings.dart';

class SessionCommandBusLocalClient extends SessionMessageBusClient {
  SessionCommandBusLocalClient({
    required this.sessionUuid,
  })
  {
    SessionMessageBusClient.instance = this;
  }

  final String sessionUuid;

  @override
  Future<GameSession?> connect() async {
    var response = await publishAndWaitForResponse(
      SessionRequestMaster(
        source: uuid,
        runUuid: ApplicationSettings.instance.runUuid,
        waitResponseTimeout: 2,
      )
    );

    if(response.status == SessionMessageResponseStatus.accepted) {
      session = await GameSessionStore().get(sessionUuid);
    }
    else {
      // TODO: throw an exception here; custom class?
    }

    return session;
  }
}