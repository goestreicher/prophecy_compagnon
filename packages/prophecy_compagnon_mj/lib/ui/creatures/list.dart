/*
 * Copyright (C) 2025-2026 Grégory Oestreicher
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

import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:prophecy_compagnon_shared/classes/creature.dart';
import 'package:prophecy_compagnon_shared/classes/object_source.dart';
import 'package:prophecy_compagnon_shared/ui/creature/display_widget.dart';
import 'package:prophecy_compagnon_shared/ui/creature/list_filter.dart';
import 'package:prophecy_compagnon_shared/ui/creature/list_filter_widget.dart';
import 'package:prophecy_compagnon_shared/ui/creature/list_widget.dart';
import 'package:prophecy_compagnon_shared/ui/error_feedback.dart';

class CreaturesListPage extends StatefulWidget {
  const CreaturesListPage({ super.key, this.selected });

  final String? selected;

  @override
  State<CreaturesListPage> createState() => _CreaturesListPageState();
}

class _CreaturesListPageState extends State<CreaturesListPage> {
  bool isWorking = false;
  CreatureListFilter filter = CreatureListFilter();
  Future<void>? creaturesFuture;
  List<CreatureSummary> creatures = <CreatureSummary>[];
  String? selected;

  @override
  void initState() {
    super.initState();
    selected = widget.selected;
  }

  void resetCreaturesList() {
    creaturesFuture = null;
    creatures.clear();
  }

  Future<void> updateCreaturesList() async {
    creatures = (await CreatureSummary.getAll()).toList();
    creatures.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  @override
  Widget build(BuildContext context) {
    if(creatures.isEmpty && creaturesFuture == null) {
      creaturesFuture = updateCreaturesList();
    }

    var listWidget = FutureBuilder(
      future: creaturesFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error!);
        }

        return CreaturesListWidget(
          creatures: creatures,
          filter: filter,
          selected: selected,
          onSelected: (String? id) {
            if(id == null && GoRouter.of(context).state.fullPath!.endsWith('/:uuid')) {
              context.replace('/creatures');
            }

            setState(() {
              selected = id;
            });
          },
          onEditRequested: (String id) async {
            context.go('/creatures/$id/edit');
          },
          onCloneRequested: (String id) async {
            context.go('/creatures/clone/$id');
          },
          onDeleteRequested: (String id) async {
            try {
              await Creature.deleteLocalModel(id);
              setState(() {
                selected = null;
                resetCreaturesList();
              });
            }
            catch(e) {
              if(!context.mounted) return;
              displayErrorDialog(
                context,
                "Suppression impossible",
                e.toString()
              );
            }
          },
          restrictModificationToSourceTypes: [
            ObjectSourceType.original
          ],
        );
      }
    );

    var mainArea = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 0.0),
          child: Wrap(
            direction: Axis.horizontal,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16.0,
            runSpacing: 8.0,
            children: [
              CreatureListFilterWidget(
                filter: filter,
                onFilterChanged: (CreatureListFilter f) {
                  setState(() {
                    filter = f;
                    selected = null;
                  });
                }
              ),
              MenuAnchor(
                alignmentOffset: const Offset(0, 4),
                builder: (BuildContext context, MenuController controller, Widget? child) {
                  return IconButton.filled(
                    icon: const Icon(Icons.add),
                    iconSize: 24.0,
                    padding: const EdgeInsets.all(4.0),
                    tooltip: 'Créer / Importer',
                    onPressed: () {
                      if(controller.isOpen) {
                        controller.close();
                      }
                      else {
                        controller.open();
                      }
                    },
                  );
                },
                menuChildren: [
                  MenuItemButton(
                    child: const Row(
                      children: [
                        Icon(Icons.create),
                        SizedBox(width: 4.0),
                        Text('Nouvelle créature'),
                      ],
                    ),
                    onPressed: () {
                      context.go('/creatures/create');
                    },
                  ),
                  MenuItemButton(
                    child: const Row(
                      children: [
                        Icon(Icons.publish),
                        SizedBox(width: 4.0),
                        Text('Importer une créature'),
                      ],
                    ),
                    onPressed: () async {
                      var result = await FilePicker.pickFile(
                        type: FileType.custom,
                        allowedExtensions: ['json'],
                      );
                      if(!context.mounted) return;
                      if(result == null) return;

                      try {
                        setState(() {
                          isWorking = true;
                        });

                        var jsonStr = const Utf8Decoder().convert((await result.readAsBytes()));
                        var j = json.decode(jsonStr);
                        var creature = await Creature.import(j);

                        setState(() {
                          selected = creature.id;
                          filter.category = creature.category;
                          isWorking = false;
                          resetCreaturesList();
                        });
                      } catch (e) {
                        setState(() {
                          isWorking = false;
                        });

                        if(!context.mounted) return;

                        displayErrorDialog(
                            context,
                            "Échec de l'import",
                            e.toString()
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12.0),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: listWidget,
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
          )
        ),
      ],
    );

    return Stack(
      children: [
        mainArea,
        if(isWorking)
          const Opacity(
            opacity: 0.6,
            child: ModalBarrier(
              dismissible: false,
              color: Colors.black,
            ),
          ),
        if(isWorking)
          const Center(
              child: CircularProgressIndicator()
          ),
      ],
    );
  }
}