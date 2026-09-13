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
import 'package:prophecy_compagnon_mj/ui/session/encounter/entities_initiative.dart';
import 'package:prophecy_compagnon_mj/ui/session/encounter/map_deployment_widget.dart';
import 'package:prophecy_compagnon_mj/ui/session/encounter/turn_management_widget.dart';
import 'package:prophecy_compagnon_shared/classes/entity/health_status.dart';
import 'package:prophecy_compagnon_shared/classes/entity_instance.dart';
import 'package:prophecy_compagnon_shared/classes/player_character.dart';
import 'package:prophecy_compagnon_shared/classes/session/board/item_map.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/turn.dart';
import 'package:prophecy_compagnon_shared/classes/session/game_session.dart';
import 'package:prophecy_compagnon_shared/classes/session/map/item.dart';

class EncounterManagementWidget extends StatefulWidget {
  const EncounterManagementWidget({
    super.key,
    required this.session,
    required this.map,
  });

  final GameSession session;
  final SessionBoardItemMap map;

  @override
  State<EncounterManagementWidget> createState() => _EncounterManagementWidgetState();
}

class _EncounterManagementWidgetState extends State<EncounterManagementWidget> {
  late SessionEncounter encounter;
  final Set<String> deployed = <String>{};

  @override
  void initState() {
    super.initState();

    encounter = widget.map.encounter!;

    deployed.addAll(
      widget.map.items.values.map((SessionMapItem i) => i.id)
    );
  }

  void updateEncounterStatus() {
    switch(encounter.status) {
      case SessionEncounterStatus.positioning:
        checkEncounterPositioningDone();
      default:
        break;
    }
  }

  void checkEncounterPositioningDone() {
    var undeployed = <String>{};
    undeployed.addAll(
        encounter.characters
            .where((PlayerCharacter p) => !deployed.contains(p.id))
            .map((PlayerCharacter p) => p.id)
    );
    undeployed.addAll(
        encounter.npcs
            .where((EntityInstance i) => !deployed.contains(i.id))
            .map((EntityInstance i) => i.id)
    );

    var remaining = undeployed.difference(deployed);
    if(remaining.isEmpty) {
      encounter.status = SessionEncounterStatus.ready;
    }
  }

  Future<bool> startNewTurn() async {
    var actions = await showDialog(
      context: context,
      builder: (BuildContext context) =>
        SessionEncounterEntitiesInitiativeDialog(
          encounter: encounter,
        ),
    );
    if(!context.mounted) return false;
    if(actions == null) return false;

    var turn = SessionEncounterTurn(
        actions: actions,
      );
    encounter.turns.add(turn);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    InlineSpan stage;
    switch(encounter.status) {
      case SessionEncounterStatus.positioning:
        stage = TextSpan(
          text: 'Déploiement',
        );
      case SessionEncounterStatus.ready:
        stage = TextSpan(
            text: 'Prête à commencer'
        );
      case SessionEncounterStatus.ongoing:
        stage = TextSpan(
          text: 'Tour ${encounter.currentTurnNumber}',
        );
      case SessionEncounterStatus.finished:
        stage = TextSpan(
          text: 'Terminée',
        );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.0,
      children: [
        Center(
          child: Text(
            'Rencontre: ${encounter.name}',
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyLarge!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Text.rich(
          TextSpan(
            text: 'Étape : ',
            children: [stage],
          ),
          textAlign: TextAlign.start,
          style: theme.textTheme.bodyMedium!
              .copyWith(color: Colors.white),
        ),
        if(encounter.status == SessionEncounterStatus.positioning)
          MapDeploymentWidget(
            session: widget.session,
            encounter: encounter,
            onEntityDeployed: (String id) {
              setState(() {
                deployed.add(id);
                updateEncounterStatus();
              });
            },
            deployed: deployed,
            showDeployed: false,
            onEntityRemoved: (String id) {
              encounter.characters.removeWhere((PlayerCharacter p) => p.id == id);
              encounter.npcs.removeWhere((EntityInstance i) => i.id == id);
              setState(() {
                deployed.remove(id);
                updateEncounterStatus();
              });
            },
          ),
        if(encounter.status == SessionEncounterStatus.ready)
          Row(
            spacing: 8.0,
            children: [
              IconButton.filled(
                onPressed: () async {
                  var started = await startNewTurn();
                  if(started) {
                    widget.map.freeMovementEnabled = false;

                    setState(() {
                      encounter.status = SessionEncounterStatus.ongoing;
                      updateEncounterStatus();
                    });
                  }
                },
                icon: Icon(Icons.play_arrow),
                padding: const EdgeInsets.all(4.0),
                constraints: const BoxConstraints(),
              ),
              Text(
                'Lancer la rencontre',
                style: theme.textTheme.titleLarge!
                    .copyWith(color: Colors.white),
              )
            ],
          ),
        if(encounter.status == SessionEncounterStatus.ongoing)
          TurnManagementWidget(
            turn: encounter.currentTurn!,
            onTurnFinished: () async {
              var allNpcsDead = encounter.npcs.every(
                  (EntityInstance npc) => npc.healthStatus.has(EntityHealthStatusFlag.dead)
              );
              if(allNpcsDead) {
                setState(() {
                  encounter.status = SessionEncounterStatus.finished;
                  updateEncounterStatus();
                });
                return;
              }

              var startNextTurn = await startNewTurn();

              while(!startNextTurn) {
                if(!context.mounted) return;
                var continueEncounter = await showDialog<bool>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) => SimpleDialog(
                    title: const Text('Terminer la rencontre ?'),
                    children: [
                      SimpleDialogOption(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop(false);
                        },
                        child: const Text(
                          'Oui, terminer la rencontre'
                        ),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop(true);
                        },
                        child: const Text(
                            'Non, continuer la rencontre'
                        ),
                      ),
                    ],
                  )
                );
                if(!context.mounted) return;

                continueEncounter ??= true;
                if(!continueEncounter) {
                  setState(() {
                    encounter.status = SessionEncounterStatus.finished;
                    updateEncounterStatus();
                  });
                  return;
                }

                startNextTurn = await startNewTurn();
              }

              setState(() {
                // no-op but required to trigger a redraw
              });
            },
          ),
        if(encounter.status == SessionEncounterStatus.finished)
          Row(
            spacing: 8.0,
            children: [
              IconButton.filled(
                onPressed: () async {
                  setState(() {
                    widget.map.freeMovementEnabled = true;
                    widget.session.encounter.value = null;
                  });
                },
                icon: Icon(Icons.stop),
                padding: const EdgeInsets.all(4.0),
                constraints: const BoxConstraints(),
              ),
              Text(
                'Terminer la rencontre',
                style: theme.textTheme.titleLarge!
                    .copyWith(color: Colors.white),
              )
            ],
          ),
      ],
    );
  }
}