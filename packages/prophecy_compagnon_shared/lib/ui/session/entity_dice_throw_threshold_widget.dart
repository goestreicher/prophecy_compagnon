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

import 'dart:math';

import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_shared/classes/dice/evaluate_dice_throw.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_result.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/ui/custom_icons.dart';
import 'package:prophecy_compagnon_shared/ui/session/dice_throw_shared_widgets.dart';

class EntityDiceThrowThresholdWidget extends StatefulWidget {
  const EntityDiceThrowThresholdWidget({
    super.key,
    required this.onBundleReady,
    required this.entity,
    required this.request,
  });

  final void Function(EntityThrowBundle) onBundleReady;
  final EntityBase entity;
  final DiceThrowRequest request;

  @override
  State<EntityDiceThrowThresholdWidget> createState() => _EntityDiceThrowThresholdWidgetState();
}

class _EntityDiceThrowThresholdWidgetState extends State<EntityDiceThrowThresholdWidget> {
  int? result;

  DiceThrowResult createResult() => DiceThrowResult(
    mainDie: result,
  );

  EntityThrowBundle createBundle() => EntityThrowBundle(
    entity: widget.entity,
    request: widget.request,
    result: createResult(),
  );

  void notifyBundle() {
    if(result == null) return;
    widget.onBundleReady(createBundle());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DiceThrowRow(
          label: Text(widget.request.base.label),
          child: DiceThrowValuePill(value: widget.request.base.value(widget.entity)),
        ),
        DiceThrowRow(
          label: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'Dé '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: IconButton(
                    onPressed: result != null ? null : () {
                      setState(() {
                        result = Random().nextInt(10) + 1;
                      });
                      notifyBundle();
                    },
                    icon: Icon(CustomIcons.d10),
                    iconSize: 18.0,
                    tooltip: 'Lancer',
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8.0),
                  ),
                ),
              ],
            ),
          ),
          child: DiceThrowTextPill(
            text: result?.toString(),
          ),
        ),
      ],
    );
  }
}