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
import 'package:prophecy_compagnon_shared/classes/session/clients/session_message_bus_client.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/entity_action.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/encounter/turn/action_planning.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/session_message_response.dart';

class ActionInitializerException implements Exception {
  ActionInitializerException({
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  String toString() => '$title\n$message';
}

abstract class ActionInitializer {
  ActionInitializer();

  String get name;
  IconData get icon;

  Future<void> plan(BuildContext context, SessionEncounterEntityAction action);

  @protected
  Future<void> guardPlan(
      BuildContext context,
      SessionEncounterEntityAction action,
      Future<void> Function(BuildContext, SessionEncounterEntityAction) guarded
  ) async {
    var messageBus = SessionMessageBusClient.instance;
    if(messageBus == null) {
      throw(
        SessionMessageBusClientException(
          "Aucune instance du bus de message n'a été trouvée, impossible de planifier l'action",
        )
      );
    }

    var planResponse = await messageBus.publishAndWaitForResponse(
      SessionEncounterTurnActionPlanningStart(
        destination: SessionMessageBusClient.instance!.uuid,
        actionUuid: action.uuid,
      )
    );

    if(!context.mounted) {
      return;
    }

    if(planResponse.status != SessionMessageResponseStatus.accepted) {
      throw(
        ActionInitializerException(
          title: "Début de planification non accepté",
          message:
            "La planification n'a pas été acceptée (statut "
            "${planResponse.status}), impossible de planifier l'action"
        )
      );
    }

    await guarded(context, action);

    messageBus.publish(
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