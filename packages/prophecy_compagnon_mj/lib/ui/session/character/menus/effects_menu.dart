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
import 'package:prophecy_compagnon_mj/ui/session/character/menus/prepare_opposition_throw.dart';
import 'package:prophecy_compagnon_shared/classes/dice/evaluate_dice_throw.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effect.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/session/clients/session_message_bus_client.dart';
import 'package:prophecy_compagnon_shared/classes/session/dice_throw_history_entry.dart';
import 'package:prophecy_compagnon_shared/classes/session/game_session.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/status/entity_effect.dart';
import 'package:prophecy_compagnon_shared/ui/session/entity_dice_throw_dialog.dart';

class EffectsMenuWidget extends StatefulWidget {
  const EffectsMenuWidget({
    super.key,
    required this.entity,
  });

  final EntityBase entity;

  @override
  State<EffectsMenuWidget> createState() => _EffectsMenuWidgetState();
}

class _EffectsMenuWidgetState extends State<EffectsMenuWidget> {
  EntityEffect? selected;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        spacing: 8.0,
        children: [
          DropdownMenu(
            label: Text(
              'Effets',
            ),
            textStyle: theme.textTheme.bodySmall,
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
              isCollapsed: true,
              constraints: BoxConstraints(maxHeight: 36.0),
              contentPadding: EdgeInsets.all(12.0),
            ),
            onSelected: (EntityEffect? e) {
              setState(() {
                selected = e;
              });
            },
            dropdownMenuEntries: widget.entity.effects
              .where((EntityEffect e) => e.trigger == EntityEffectTrigger.request)
              .map(
                (EntityEffect e) => DropdownMenuEntry(value: e, label: e.name)
              )
              .toList(),
          ),
          IconButton(
            onPressed: selected == null ? null : () async {
              if(selected!.active) {
                SessionMessageBusClient.instance?.publish(
                  SessionEntityUnapplyEffectMessage(
                    broadcastIncludesSelf: true,
                    entityId: widget.entity.id,
                    effectId: selected!.id,
                  )
                );
              }
              else {
                bool isOpposition;
                DiceThrowEvaluation? activationDiceThrowEvaluation;

                if (selected!.activationDiceThrowRequest != null) {
                  var request = selected!.activationDiceThrowRequest!;
                  List<EntityBase> entities;
                  DiceThrowRequest? opposingRequest;

                  if(
                      request.type == DiceThrowRequestType.oppositionDirect
                      || request.type == DiceThrowRequestType.oppositionNR
                  ) {
                    isOpposition = true;
                    var preparationResult = await showDialog<PrepareOppositionThrowResult>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) => PrepareOppositionThrowDialog(
                        actor: widget.entity,
                      ),
                    );
                    if(preparationResult == null) return;
                    if(!context.mounted) return;

                    opposingRequest = DiceThrowRequest(
                      type: request.type,
                      context: DiceThrowRequestContext.none,
                      difficulty: preparationResult.difficulty ?? request.difficulty,
                      base: preparationResult.opposingBase ?? request.base,
                      allowTendencies: request.allowTendencies,
                    );

                    entities = [widget.entity, preparationResult.opposing];
                  }
                  else {
                    isOpposition = false;
                    entities = [widget.entity];
                  }

                  var bundles = await showDialog<List<EntityThrowBundle>>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) =>
                      EntityDiceThrowDialog(
                        entities: entities,
                        request: request,
                        opposingRequest: opposingRequest,
                      )
                  );
                  if(bundles == null || bundles.isEmpty) return;
                  if(!context.mounted) return;

                  if(isOpposition) {
                    activationDiceThrowEvaluation = evaluateDiceThrow(
                      bundles[0],
                      opposing: bundles[1],
                    );
                  }
                  else {
                    activationDiceThrowEvaluation = evaluateDiceThrow(
                      bundles[0]
                    );
                  }

                  GameSession.instance!.diceThrowHistory.add(
                    DiceThrowHistoryEntry(
                      actor: bundles.first.entity,
                      request: bundles.first.request,
                      evaluation: activationDiceThrowEvaluation,
                    )
                  );

                  if(!selected!.canApply(target: widget.entity, activationDiceThrowEvaluation: activationDiceThrowEvaluation)) {
                    // TODO: display a message?
                    return;
                  }
                }

                SessionMessageBusClient.instance?.publish(
                  SessionEntityAddEffectMessage(
                    broadcastIncludesSelf: true,
                    entityId: widget.entity.id,
                    effect: selected!,
                    activationDiceThrowEvaluation: activationDiceThrowEvaluation,
                  )
                );
              }

              setState(() {
                // no-op, required to have the button redraw if the effect
                // activation has changed
              });
            },
            tooltip: (selected?.active ?? false)
              ? 'Désactiver'
              : 'Activer',
            icon: (selected?.active ?? false)
              ? Icon(Icons.close)
              : Icon(Icons.arrow_forward),
          )
        ],
      )
    );
  }
}