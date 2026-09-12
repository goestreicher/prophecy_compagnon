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

import 'dart:async';

import 'package:prophecy_compagnon_shared/classes/settings.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/management/request_master.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/session_action.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/session_message.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/session_message_response.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/session_set_state.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/session_status_message.dart';


class SessionMessageBus {
  static SessionMessageBus get instance {
    _instance ??= SessionMessageBus._ctor();
    return _instance!;
  }

  static SessionMessageBus? _instance;

  SessionMessageBus._ctor()
    : _streamController = StreamController<SessionMessage>.broadcast();

  String? get master => _master;

  final StreamController<SessionMessage> _streamController;
  String? _master;

  void publish(SessionMessage message) {
    if(!_canSend(message)) {
      if(message.hasResponse) {
        _streamController.add(
          SessionMessageResponse(
            source: SessionMessage.busIdentifier,
            destination: message.source!,
            ack: message.uuid,
            status: SessionMessageResponseStatus.rejected,
            statusMessage: 'unauthorized',
          )
        );
      }
      return;
    }

    if(
        message is SessionRequestMaster
        && message.source != null
        && message.destination == SessionMessage.busIdentifier
    ) {
      if(ApplicationSettings.instance.runUuid == message.runUuid) {
        _master = message.source;
        _streamController.add(
          SessionMessageResponse(
            source: SessionMessage.busIdentifier,
            destination: message.source!,
            ack: message.uuid,
            status: SessionMessageResponseStatus.accepted,
          )
        );
      }
      else {
        _streamController.add(
          SessionMessageResponse(
            source: SessionMessage.busIdentifier,
            destination: message.source!,
            ack: message.uuid,
            status: SessionMessageResponseStatus.rejected,
            statusMessage: 'Invalid "runUuid"',
          )
        );
      }
      return;
    }

    if(message.destination == SessionMessage.masterIdentifier) {
      if(_master == null) {
        if(message.hasResponse) {
          _streamController.add(
            SessionMessageResponse(
              source: SessionMessage.busIdentifier,
              destination: message.source!,
              ack: message.uuid,
              status: SessionMessageResponseStatus.rejected,
              statusMessage: 'no master set on bus',
            )
          );
        }
        return;
      }
      message.destination = _master!;
    }

    _streamController.add(message);
  }

  // TODO: filter events
  Stream<SessionMessage> subscribe(String clientUuid) {
    return _streamController.stream
      .where((SessionMessage m) {
          if(m.destination == clientUuid) return true;
          if(m.destination == SessionMessage.broadcast) {
            if(m.source == clientUuid) {
              return m.broadcastIncludesSelf;
            }
            return true;
          }
          return false;
        });
  }

  bool _canSend(SessionMessage m) {
    if(m.source == null) return false;

    // Only master can change session state
    if(m is SessionSetStateMessage) {
      return m.source == _master;
    }

    // Only master can send session actions
    // TODO: also controlling clients can send actions about their entity
    if(m is SessionActionMessage) {
      return m.source == _master;
    }

    // Allow status messages
    // TODO: for entity status updates, allow master and the client controlling the entity
    if(m is SessionStatusMessage) {
      return true;
    }

    // Allow requests and responses
    return m.hasResponse || m is SessionMessageResponse;
  }
}