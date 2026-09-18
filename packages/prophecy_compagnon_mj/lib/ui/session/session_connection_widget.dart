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

import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_mj/ui/session/pc_review_dialog.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_result.dart';
import 'package:prophecy_compagnon_shared/classes/human_character.dart';
import 'package:prophecy_compagnon_shared/classes/session/clients/session_message_bus_client.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/action/dice_throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/action/start_pc_review.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/responses/action/dice_throw_result.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/responses/action/pc_review_result.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/session_message.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/session_message_response.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/status/entity_effect.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/status/entity_property_status.dart';
import 'package:prophecy_compagnon_shared/ui/session/entity_dice_throw_dialog.dart';

class SessionConnectionWidget extends StatefulWidget {
  const SessionConnectionWidget({
    super.key,
    required this.client,
  });

  final SessionMessageBusClient client;

  @override
  State<SessionConnectionWidget> createState() => _SessionConnectionWidgetState();
}

class _SessionConnectionWidgetState extends State<SessionConnectionWidget> {
  late StreamSubscription<SessionMessage> subscription;

  @override
  void initState() {
    super.initState();
    subscription = widget.client.stream.stream.listen((SessionMessage m) => _onMessage(m));
  }

  @override
  void dispose() {
    subscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.check_circle_outline,);
  }

  void _onMessage(SessionMessage m) {
    if(m is SessionStartPlayerCharacterReview) {
      _startPCReview(m);
    }
    else if(m is SessionActionDiceThrowRequestMessage) {
      _doDiceThrow(m);
    }
    else if(m is SessionEntitySetPropertyMessage) {
      _doEntitySetProperty(m);
    }
    else if(m is SessionEntitySetEffectMessage) {
      _doEntitySetEffect(m);
    }
  }

  Future<void> _startPCReview(SessionStartPlayerCharacterReview m) async {
    if(widget.client.session == null) return;

    var messageBus = SessionMessageBusClient.instance;
    if(messageBus == null) {
      // TODO: display a message
      return;
    }

    var result = await showDialog<SessionPlayerCharacterReviewResult?>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => PlayerCharacterReviewDialog(
        characters: widget.client.session!.table.players,
      ),
    );

    if(result == null || result.selected.isEmpty) {
      messageBus.sendResponse(
          m,
          null,
          status: SessionMessageResponseStatus.cancelled
        );
      return;
    }

    messageBus.sendResponse(
        m,
        result.selected
      );
  }

  Future<void> _doDiceThrow(SessionActionDiceThrowRequestMessage m) async {
    if(widget.client.session == null) return;

    var messageBus = SessionMessageBusClient.instance;
    if(messageBus == null) {
      // TODO: display a message
      return;
    }

    var entity = widget.client.session!.entity(m.entityId);
    if(entity == null) {
      messageBus.sendResponse(
          m,
          null,
          status: SessionMessageResponseStatus.error,
          statusMessage: "Personnage non trouvé",
        );
      return;
    }

    if(!m.request.base.canThrow(entity)) {
      messageBus.sendResponse(
          m,
          DiceThrowRequestResult(
            request: m.request,
            result: DiceThrowResult(throwImpossible: true),
          ),
        );
      return;
    }

    var result = await showDialog<DiceThrowResult>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => EntityDiceThrowDialog(
        entity: entity,
        request: m.request,
      )
    );

    if(result == null) {
      messageBus.sendResponse(
          m,
          null,
          status: SessionMessageResponseStatus.cancelled,
        );
      return;
    }

    messageBus.sendResponse(
      m,
      DiceThrowRequestResult(
        request: m.request,
        result: result,
      ),
    );
  }

  void _doEntitySetProperty(SessionEntitySetPropertyMessage m) {
    var entity = widget.client.session?.entity(m.entityId);
    if(entity == null || entity is! HumanCharacter) return;

    switch(m.property) {
      case EntityMessageProperty.useLuckPoints:
        entity.usedLuck += m.value as int;
      case EntityMessageProperty.gainLuckPoints:
        entity.gainLuckPoints(m.value as int);
      case EntityMessageProperty.useProficiencyPoints:
        entity.usedProficiency += m.value as int;
      case EntityMessageProperty.gainProficiencyPoints:
        entity.gainProficiencyPoints(m.value as int);
    }
  }

  void _doEntitySetEffect(SessionEntitySetEffectMessage m) {
    var entity = widget.client.session?.entity(m.entityId);
    if(entity == null) return;

    m.effect.apply(entity);
    if(!(m.effect.once ?? false)) {
      widget.client.session?.effectManager.addEffect(m.entityId, m.effect);
    }
  }
}