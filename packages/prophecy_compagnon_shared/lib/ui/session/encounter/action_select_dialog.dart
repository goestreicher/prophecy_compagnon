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
import 'package:prophecy_compagnon_shared/classes/session/encounter/turn.dart';

class SessionEncounterTurnSelectActionDialog extends StatefulWidget {
  const SessionEncounterTurnSelectActionDialog({
    super.key,
    required this.description,
    required this.turn,
    required this.entityId,
    this.excludedActionUuids = const <String>[],
    this.multiselect = false,
    this.selectRange = false,
    this.allowEmptySelection = false,
    this.usableOnly = true,
    this.showWeakHandAction = true,
  });

  final String description;
  final SessionEncounterTurn turn;
  final String entityId;
  final List<String> excludedActionUuids;
  final bool multiselect;
  final bool selectRange;
  final bool allowEmptySelection;
  final bool usableOnly;
  final bool showWeakHandAction;

  @override
  State<SessionEncounterTurnSelectActionDialog> createState() => _SessionEncounterTurnSelectActionDialogState();
}

class _SessionEncounterTurnSelectActionDialogState extends State<SessionEncounterTurnSelectActionDialog> {
  late final List<SessionEncounterEntityAction> sorted;
  final List<SessionEncounterEntityAction> selected = <SessionEncounterEntityAction>[];

  @override
  void initState() {
    super.initState();

    Iterable<SessionEncounterEntityAction> actionsIterable;
    if(widget.usableOnly) {
      actionsIterable = widget.turn.filteredActions((SessionEncounterEntityAction a) => a.stage == SessionEncounterEntityActionStage.none);
    }
    else {
      actionsIterable = widget.turn.actions;
    }

    sorted = actionsIterable
      .where((SessionEncounterEntityAction a) => a.entity.id == widget.entityId)
      .where((SessionEncounterEntityAction a) => !widget.excludedActionUuids.contains(a.uuid))
      .where((SessionEncounterEntityAction a) => widget.showWeakHandAction || !a.weakHand)
      .toList()
      ..sort((SessionEncounterEntityAction a, SessionEncounterEntityAction b) => b.rank - a.rank);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: Text('Sélectionner les actions'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12.0,
          children: [
            Text(widget.description),
            Row(
              spacing: 12.0,
              children: [
                for(var (i, a) in sorted.indexed)
                  _ActionPill(
                    rank: a.rank,
                    selected: selected.contains(a),
                    onToggle: () {
                      var isSelected = selected.contains(a);

                      if(widget.selectRange) {
                        setState(() {
                          if(selected.length == 1 && i == 0) {
                            selected.clear();
                          }
                          else {
                            selected.clear();
                            selected.addAll(sorted.getRange(0, i + 1));
                          }
                        });
                      }
                      else {
                        setState(() {
                          if (widget.multiselect) {
                            if (isSelected) {
                              selected.remove(a);
                            }
                            else {
                              selected.add(a);
                            }
                          }
                          else {
                            if (!isSelected) {
                              selected.clear();
                              selected.add(a);
                            }
                          }
                        });
                      }
                    }
                  )
              ],
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: selected.isEmpty ? null : () {
            Navigator.of(context, rootNavigator: true).pop(selected);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          child: const Text('OK'),
        ),
      ]
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({
    required this.rank,
    required this.selected,
    required this.onToggle,
  });

  final int rank;
  final bool selected;
  final void Function() onToggle;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(20.0),
      child: Material(
        color: selected
          ? theme.colorScheme.secondaryContainer
          : theme.disabledColor,
        child: InkWell(
          onTap: onToggle,
          child: SizedBox(
            width: 40.0,
            height: 40.0,
            child: Center(
              child: Text(
                rank.toString(),
                style: theme.textTheme.bodyLarge!
                  .copyWith(
                    fontWeight: FontWeight.bold,
                    color: selected
                      ? theme.colorScheme.onSecondaryContainer
                      : Colors.white,
                  )
              )
            ),
          )
        ),
      ),
    );
  }
}