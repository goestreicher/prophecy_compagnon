/*
 * Copyright (C) 2024-2026 Grégory Oestreicher
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
import 'package:prophecy_compagnon_shared/classes/creature.dart';
import 'package:prophecy_compagnon_shared/classes/object_source.dart';
import 'package:prophecy_compagnon_shared/ui/creature/create_dialog.dart';
import 'package:prophecy_compagnon_shared/ui/creature/display_widget.dart';
import 'package:prophecy_compagnon_shared/ui/creature/edit_widget.dart';
import 'package:prophecy_compagnon_shared/ui/creature/list_widget.dart';

class ScenarioEditCreaturesPage extends StatefulWidget {
  const ScenarioEditCreaturesPage({
    super.key,
    required this.creatures,
    required this.scenarioSource,
    required this.onCreatureCreated,
    required this.onCreatureModified,
    required this.onCreatureDeleted,
    this.onEditStarted,
    this.onEditFinished,
  });

  final List<Creature> creatures;
  final ObjectSource scenarioSource;
  final void Function(Creature) onCreatureCreated;
  final void Function(Creature) onCreatureModified;
  final void Function(Creature) onCreatureDeleted;
  final void Function()? onEditStarted;
  final void Function()? onEditFinished;

  @override
  State<ScenarioEditCreaturesPage> createState() => _ScenarioEditCreaturesPageState();
}

class _ScenarioEditCreaturesPageState extends State<ScenarioEditCreaturesPage> {
  late List<CreatureSummary> creatureSummaries;
  String? selected;
  Creature? editModel;
  bool creatingNewCreature = false;

  void _startEditing(Creature model) {
    widget.onEditStarted?.call();

    setState(() {
      selected = model.id;
      editModel = model;
    });
  }

  @override
  void initState() {
    super.initState();
    creatureSummaries = [for(var c in widget.creatures) c.summary]
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    Widget mainArea;
    if(editModel != null) {
      mainArea = Container(
        color: theme.colorScheme.surfaceContainerHighest,
        child: CreatureEditWidget(
          creature: editModel!,
          onEditDone: (bool result) async {
            if(result) {
              var summaryIndex = creatureSummaries.indexWhere((CreatureSummary s) => s.id == editModel!.id);
              if(summaryIndex == -1) {
                creatureSummaries.add(editModel!.summary);
                widget.creatures.add(editModel!);
              }
              else {
                creatureSummaries[summaryIndex] = editModel!.summary;
              }

              if(creatingNewCreature) {
                widget.onCreatureCreated(editModel!);
              }
              else {
                widget.onCreatureModified(editModel!);
              }
            }
            else {
              if(creatingNewCreature) {
                Creature.removeFromCache(editModel!.id);
                selected = null;
              }
              else {
                await Creature.reloadFromStore(editModel!.id);
              }
            }

            widget.onEditFinished?.call();
            setState(() {
              creatingNewCreature = false;
              editModel = null;
            });
          },
        ),
      );
    }
    else {
      mainArea = Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
        ),
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            Expanded(
              child: Column(
                spacing: 12.0,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      var creature = await showDialog<Creature>(
                        context: context,
                        builder: (BuildContext context) => CreatureCreateDialog(
                          source: widget.scenarioSource,
                        ),
                      );
                      if(!context.mounted) return;
                      if(creature == null) return;

                      creatingNewCreature = true;
                      _startEditing(creature);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Nouvelle créature'),
                  ),
                  Expanded(
                    child: CreaturesListWidget(
                      creatures: creatureSummaries,
                      selected: selected,
                      onSelected: (String? id) {
                        setState(() {
                          selected = id;
                        });
                      },
                      onEditRequested: (String id) async {
                        var model = widget.creatures.firstWhere(
                            (Creature c) => c.id == id
                        );

                        creatingNewCreature = false;
                        _startEditing(model);
                      },
                      onCloneRequested: (String id) async {
                        var model = widget.creatures.firstWhere(
                            (Creature c) => c.id == id
                        );

                        var clone = await showDialog<Creature>(
                          context: context,
                          builder: (BuildContext context) => CreatureCreateDialog(
                            source: widget.scenarioSource,
                            cloneFrom: model,
                          ),
                        );
                        if(!context.mounted) return;
                        if(clone == null) return;

                        creatingNewCreature = true;
                        _startEditing(clone);
                      },
                      onDeleteRequested: (String id) async {
                        var index = widget.creatures.indexWhere(
                            (Creature c) => c.id == id
                        );
                        var summaryIndex = creatureSummaries.indexWhere(
                            (CreatureSummary c) => c.id == id
                        );

                        setState(() {
                          creatureSummaries.removeAt(summaryIndex);
                          if(editModel?.id == id) editModel = null;
                          widget.onCreatureDeleted(widget.creatures[index]);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            if(selected != null)
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 8.0),
                    child: CreatureDisplayWidget(
                      id: selected!,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return mainArea;
  }
}