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

import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/entity_action.dart';
import 'package:prophecy_compagnon_shared/ui/session/clients/session_message_bus_client.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/encounter/turn/action_planning.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/session_message_response.dart';

abstract class ActionConfiguration {
  ActionConfiguration();

  String get name;
  IconData get icon;

  Future<void> plan(SessionEncounterEntityAction action);

  @protected
  Future<void> guardPlan(
      SessionEncounterEntityAction action,
      Future<void> Function(SessionEncounterEntityAction action) guarded
  ) async {
    var planResponse = await SessionMessageBusClient.instance?.publishAndWaitForResponse(
      SessionEncounterTurnActionPlanningStart(
        destination: SessionMessageBusClient.instance!.uuid,
        actionUuid: action.uuid,
      )
    );

    if(planResponse == null) {
      // TODO: display a nice message?
      return;
    }

    if(planResponse.status != SessionMessageResponseStatus.accepted) {
      // TODO: display a nice message?
      return;
    }

    await guarded(action);

    SessionMessageBusClient.instance?.publish(
      SessionEncounterTurnActionPlanningEnd(
        destination: SessionMessageBusClient.instance!.uuid,
        actionUuid: action.uuid,
      )
    );
  }

  @protected
  (bool, String?) mustCancelAction(SessionMessageResponse response) {
    bool cancel = false;
    String? reason;

    switch(response.status) {
      case SessionMessageResponseStatus.cancelled:
        // User cancelled input, no need to cancel the
        // action as the widget that handled the action
        // is already aware of it
        break;
      case SessionMessageResponseStatus.rejected:
        cancel = true;
        reason = response.statusMessage;
      case SessionMessageResponseStatus.timeout:
        cancel = true;
        reason = "Délai d'attente dépassé";
      case SessionMessageResponseStatus.error:
        cancel = true;
        reason = "Erreur : ${response.statusMessage ?? 'pas de message remonté'}";
      case SessionMessageResponseStatus.accepted:
        break;
    }

    return (cancel, reason);
  }
}