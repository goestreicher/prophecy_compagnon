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

import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_shared/classes/object_source.dart';
import 'package:prophecy_compagnon_shared/classes/resource_link/assets_resource_link_provider.dart';
import 'package:prophecy_compagnon_shared/classes/resource_link/multi_resource_link_provider.dart';
import 'package:prophecy_compagnon_shared/classes/resource_link/scenario_resource_link_provider.dart';
import 'package:prophecy_compagnon_shared/classes/star.dart';
import 'package:prophecy_compagnon_shared/ui/star/create_widget.dart';
import 'package:prophecy_compagnon_shared/ui/star/display_widget.dart';
import 'package:prophecy_compagnon_shared/ui/star/edit_widget.dart';
import 'package:prophecy_compagnon_shared/ui/star/list_widget.dart';

class ScenarioEditStarsPage extends StatefulWidget {
  const ScenarioEditStarsPage({
    super.key,
    required this.stars,
    required this.scenarioSource,
    required this.onStarCreated,
    required this.onStarModified,
    required this.onStarDeleted,
    this.onEditStarted,
    this.onEditFinished,
  });

  final List<Star> stars;
  final ObjectSource scenarioSource;
  final void Function(Star) onStarCreated;
  final void Function(Star) onStarModified;
  final void Function(Star) onStarDeleted;
  final void Function()? onEditStarted;
  final void Function()? onEditFinished;

  @override
  State<ScenarioEditStarsPage> createState() => _ScenarioEditStarsPageState();
}

class _ScenarioEditStarsPageState extends State<ScenarioEditStarsPage> {
  String? selected;
  bool creating = false;
  Star? editing;
  String? cloning;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    Widget mainArea;

    if(creating) {
      mainArea = Container(
        color: theme.colorScheme.surfaceContainerHighest,
        child: StarCreateWidget(
          source: widget.scenarioSource,
          onStarCreated: (Star? star) {
            if(star != null) {
              selected = star.id;
              widget.onStarCreated(star);
            }

            setState(() {
              creating = false;
            });
          },
        ),
      );
    }
    else if(cloning != null) {
      mainArea = Container(
        color: theme.colorScheme.surfaceContainerHighest,
        child: StarCreateWidget(
          source: widget.scenarioSource,
          cloneFrom: cloning,
          onStarCreated: (Star? star) {
            if(star != null) {
              selected = star.id;
              widget.onStarCreated(star);
            }

            setState(() {
              cloning = null;
            });
          },
        ),
      );
    }
    else if(editing != null) {
      mainArea = Container(
        color: theme.colorScheme.surfaceContainerHighest,
        child: StarEditWidget(
          star: editing!,
            resourceLinkProvider: MultiResourceLinkProvider(
              providers: [
                AssetsResourceLinkProvider(),
                ScenarioResourceLinkProvider(
                  source: widget.scenarioSource,
                ),
              ]
            ),
          onEditDone: (bool result) async {
            if(result) {
              await Star.saveLocalModel(editing!);
            }
            else {
              await Star.reloadFromStore(editing!.id);
            }

            setState(() {
              selected = editing!.id;
              editing = null;
            });
          }
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
                    onPressed: () {
                      setState(() {
                        creating = true;
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Nouvelle étoile'),
                  ),
                  Expanded(
                    child: StarsListWidget(
                      stars: widget.stars,
                      selected: selected,
                      onSelected: (String? id) {
                        setState(() {
                          selected = id;
                        });
                      },
                      onEditRequested: (String id) async {
                        var star = widget.stars.firstWhere(
                            (Star s) => s.id == id
                          );

                        setState(() {
                          editing = star;
                        });
                      },
                      onCloneRequested: (String id) async {
                        setState(() {
                          cloning = id;
                        });
                      },
                      onDeleteRequested: (String id) async {
                        var star = widget.stars.firstWhere(
                            (Star s) => s.id == id
                          );

                        widget.onStarDeleted(star);
                        setState(() {
                          if(editing?.id == id) editing = null;
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
                    child: StarDisplayWidget(
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