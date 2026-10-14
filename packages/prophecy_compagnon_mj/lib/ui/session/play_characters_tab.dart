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
import 'package:prophecy_compagnon_mj/ui/session/character/info.dart';
import 'package:prophecy_compagnon_mj/ui/session/character/menus/dice_throw_menu.dart';
import 'package:prophecy_compagnon_mj/ui/session/character/menus/shared_dice_throw_items.dart';
import 'package:prophecy_compagnon_mj/ui/session/dice_throw_history_widget.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/session/game_session.dart';
import 'package:provider/provider.dart';

class PlayCharactersPage extends StatefulWidget {
  const PlayCharactersPage({
    super.key,
  });

  @override
  State<PlayCharactersPage> createState() => _PlayCharactersPageState();
}

class _PlayCharactersPageState extends State<PlayCharactersPage> {
  final List<EntityBase> selected = <EntityBase>[];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var session = context.read<GameSession>();

    var pcWidgets = <Widget>[];
    for(var pc in session.table.players) {
      pcWidgets.add(
        IntrinsicWidth(
          child: Row(
            children: [
              Checkbox(
                value: selected.contains(pc),
                onChanged: (bool? v) {
                  if(v == null) return;
          
                  setState(() {
                    v ? selected.add(pc) : selected.remove(pc);
                  });
                }
              ),
              Expanded(
                child: SessionCharacterInfoWidget(
                  character: pc,
                ),
              ),
            ],
          ),
        )
      );
    }
    var pcWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.0,
      children: [
        Row(
          children: [
            Expanded(
              child: const Divider(
                indent: 16.0,
                endIndent: 16.0,
              )
            ),
            Checkbox(
              value: session.table.players
                  .every((EntityBase pc) => selected.contains(pc)),
              onChanged: (bool? v) {
                if(v == null) return;

                setState(() {
                  for(var e in session.table.players) {
                    if(v && !selected.contains(e)) {
                      selected.add(e);
                    }
                    else if(!v && selected.contains(e)) {
                      selected.remove(e);
                    }
                  }
                });
              }
            ),
            Text('PJs'),
            Expanded(
              child: const Divider(
                indent: 16.0,
                endIndent: 16.0,
              )
            ),
          ],
        ),
        Wrap(
          spacing: 16.0,
          children: pcWidgets,
        )
      ],
    );

    Widget? encounterNpcWidget;
    var encounterNpcWidgets = <Widget>[];
    for(var npc in (session.encounter.value?.npcs ?? <EntityBase>[])) {
      encounterNpcWidgets.add(
        IntrinsicWidth(
          child: Row(
            children: [
              Checkbox(
                value: selected.contains(npc),
                onChanged: (bool? v) {
                  if(v == null) return;
          
                  setState(() {
                    v ? selected.add(npc) : selected.remove(npc);
                  });
                }
              ),
              Expanded(
                child: SessionCharacterInfoWidget(
                  character: npc,
                ),
              ),
            ],
          ),
        )
      );
    }
    if(encounterNpcWidgets.isNotEmpty) {
      encounterNpcWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.0,
        children: [
          Row(
            children: [
              Expanded(
                child: const Divider(
                  indent: 16.0,
                  endIndent: 16.0,
                )
              ),
              Checkbox(
                value: (session.encounter.value?.npcs ?? <EntityBase>[])
                    .every((EntityBase npc) => selected.contains(npc)),
                onChanged: (bool? v) {
                  if(v == null) return;

                  setState(() {
                    for(var e in (session.encounter.value?.npcs ?? <EntityBase>[])) {
                      if(v && !selected.contains(e)) {
                        selected.add(e);
                      }
                      else if(!v && selected.contains(e)) {
                        selected.remove(e);
                      }
                    }
                  });
                }
              ),
              Text('PNJ de la rencontre'),
              Expanded(
                child: const Divider(
                  indent: 16.0,
                  endIndent: 16.0,
                )
              ),
            ],
          ),
          Wrap(
            spacing: 16.0,
            children: encounterNpcWidgets,
          ),
        ],
      );
    }

    Widget? scenarioNpcWidget;
    var scenarioNpcWidgets = <Widget>[];
    for(var npc in (session.scenario?.entities() ?? <EntityBase>[])) {
      scenarioNpcWidgets.add(
        IntrinsicWidth(
          child: Row(
            children: [
              Checkbox(
                value: selected.contains(npc),
                onChanged: (bool? v) {
                  if(v == null) return;
          
                  setState(() {
                    v ? selected.add(npc) : selected.remove(npc);
                  });
                }
              ),
              Expanded(
                child: SessionCharacterInfoWidget(
                  character: npc,
                ),
              ),
            ],
          ),
        )
      );
    }
    if(scenarioNpcWidgets.isNotEmpty) {
      scenarioNpcWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.0,
        children: [
          Row(
            children: [
              Expanded(
                child: const Divider(
                  indent: 16.0,
                  endIndent: 16.0,
                )
              ),
              Checkbox(
                value: (session.scenario?.entities() ?? <EntityBase>[])
                    .every((EntityBase npc) => selected.contains(npc)),
                onChanged: (bool? v) {
                  if(v == null) return;

                  setState(() {
                    for(var e in (session.scenario?.entities() ?? <EntityBase>[])) {
                      if(v && !selected.contains(e)) {
                        selected.add(e);
                      }
                      else if(!v && selected.contains(e)) {
                        selected.remove(e);
                      }
                    }
                  });
                }
              ),
              Text('PNJ du scénario'),
              Expanded(
                child: const Divider(
                  indent: 16.0,
                  endIndent: 16.0,
                )
              ),
            ],
          ),
          Wrap(
            spacing: 16.0,
            children: scenarioNpcWidgets,
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              spacing: 12.0,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    spacing: 8.0,
                    children: [
                      DiceThrowMenuWidget(
                        label: 'Jets communs',
                        entities: selected,
                        items: [
                          ...sharedDiceThrowItems['perception']!,
                          ...sharedDiceThrowItems['discretion']!,
                          ...sharedDiceThrowItems['luck']!,
                        ],
                      )
                    ],
                  ),
                ),
                pcWidget,
                ?encounterNpcWidget,
                ?scenarioNpcWidget,
              ],
            ),
          ),
        ),
        SizedBox(
          width: 400,
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer,
              border: Border(
                left: BorderSide(color: theme.colorScheme.shadow.withAlpha(80)),
              )
            ),
            child: DiceThrowHistoryWidget(),
          ),
        )
      ],
    );
  }
}