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
import 'package:prophecy_compagnon_shared/classes/character/tendencies.dart';
import 'package:prophecy_compagnon_shared/classes/dice/evaluate_dice_throw.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_modifier.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_modifier_type.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_result.dart';
import 'package:prophecy_compagnon_shared/ui/custom_icons.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class DiceThrowRow extends StatelessWidget {
  const DiceThrowRow({
    super.key,
    this.title,
    required this.label,
    required this.child,
  });

  final Widget? title;
  final Widget label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: title,
      titleBackgroundColor: theme.colorScheme.surfaceContainerHigh,
      child: Row(
        spacing: 8.0,
        children: [
          label,
          Spacer(),
          child,
        ],
      )
    );
  }
}

class DiceThrowTextPill extends StatelessWidget {
  const DiceThrowTextPill({
    super.key,
    this.text,
  });

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
          child: Text(
            text ?? '?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class DiceThrowValuePill extends StatelessWidget {
  const DiceThrowValuePill({
    super.key,
    required this.value,
  });

  final int value;

  @override
  Widget build(BuildContext context) {
    // TODO: manage text color if the value is positive or negative
    return DiceThrowTextPill(
      text: value.toString(),
    );
  }
}

class DiceThrowResultStatusWidget extends StatelessWidget {
  const DiceThrowResultStatusWidget({
    super.key,
    this.bundle,
  });

  final EntityThrowBundle? bundle;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var totalColor = Colors.indigo;
    String? totalText;
    if(bundle != null) {
      var eval = evaluateDiceThrow(bundle!);

      if(eval.resultType == DiceThrowResultType.fail) {
        totalColor = Colors.red;
        totalText = 'Échec';
      }
      else {
        totalColor = Colors.green;
        totalText = 'Réussite';
      }
    }

    return Row(
      children: [
        Text(
          'Résultat',
          style: theme.textTheme.headlineSmall,
        ),
        Spacer(),
        Container(
          decoration: BoxDecoration(
            color: totalColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
            child: Text(
              totalText ?? '?',
              style: theme.textTheme.headlineSmall!
                .copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class DiceThrowResultSimpleWidget extends StatelessWidget {
  const DiceThrowResultSimpleWidget({
    super.key,
    this.bundle,
  });

  final EntityThrowBundle? bundle;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    String? totalText;
    var totalColor = Colors.indigo;
    if(bundle != null) {
      var evaluation = evaluateDiceThrow(bundle!);
      if(evaluation.criticalType == DiceThrowResultType.criticalFail) {
        totalText = 'Échec critique';
        totalColor = Colors.red;
      }

      if(totalText == null) {
        totalText =
            (bundle!.request.base.value(bundle!.entity)
            + bundle!.result.total()).toString();

        if(evaluation.resultType == DiceThrowResultType.fail) {
          totalColor = Colors.red;
        }
        else if(evaluation.resultType == DiceThrowResultType.success) {
          totalColor = Colors.green;
        }
      }
    }

    var totalWidget = Container(
      decoration: BoxDecoration(
        color: totalColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
        child: Text(
          totalText ?? '?',
          style: theme.textTheme.headlineSmall!
            .copyWith(color: Colors.white),
        ),
      ),
    );

    Widget? difficultyTotalWidget;
    if(bundle?.request.difficulty != null) {
      var difficultyModifiersTotal = 0;
      for(var mod in (bundle?.result.modifiers ?? <DiceThrowModifier>[])) {
        if(mod.type == DiceThrowModifierType.difficulty) {
          difficultyModifiersTotal += mod.value;
        }
      }

      difficultyTotalWidget = Container(
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
          child: Text(
            (bundle!.request.difficulty! + difficultyModifiersTotal).toString(),
            style: theme.textTheme.headlineSmall!
              .copyWith(color: Colors.white),
          ),
        ),
      );
    }

    return Row(
      children: [
        Text(
          'Total',
          style: theme.textTheme.headlineSmall,
        ),
        Spacer(),
        totalWidget,
        if(difficultyTotalWidget != null)
          Text(
            ' vs. ',
            style: theme.textTheme.headlineSmall,
          ),
        ?difficultyTotalWidget,
      ],
    );
  }
}

class TendencyThrowWidget extends StatefulWidget {
  const TendencyThrowWidget({
    super.key,
    this.diceThrowDone = false,
    required this.onDieChanged,
    required this.announcedTendency,
    this.keptTendency,
    required this.onDieKept,
    this.dragonDie,
    this.fatalityDie,
    this.humanDie,
  });

  final bool diceThrowDone;
  final void Function(Tendency, int) onDieChanged;
  final Tendency announcedTendency;
  final Tendency? keptTendency;
  final void Function(Tendency) onDieKept;
  final int? dragonDie;
  final int? fatalityDie;
  final int? humanDie;

  @override
  State<TendencyThrowWidget> createState() => _TendencyThrowWidgetState();
}

class _TendencyThrowWidgetState extends State<TendencyThrowWidget> {
  int? dragon;
  int? fatality;
  int? human;
  bool kept = false;

  @override
  void initState() {
    super.initState();

    dragon = widget.dragonDie;
    fatality = widget.fatalityDie;
    human = widget.humanDie;
  }

  bool canSelectKeptDie() =>
      !kept && dragon != null && fatality != null && human != null;

  @override
  Widget build(BuildContext context) {
    return WidgetGroupContainer(
      child: Column(
        spacing: 8.0,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'Lancer tous les dés '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: IconButton(
                    onPressed: widget.diceThrowDone ? null : () {
                      setState(() {
                        dragon = Random().nextInt(10) + 1;
                        fatality = Random().nextInt(10) + 1;
                        human = Random().nextInt(10) + 1;
                      });

                      widget.onDieChanged(Tendency.dragon, dragon!);
                      widget.onDieChanged(Tendency.fatality, fatality!);
                      widget.onDieChanged(Tendency.human, human!);
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
          Row(
            spacing: 8.0,
            children: [
              _TendencyDieLabel(
                label: 'Dé du Dragon',
                announced: widget.announcedTendency == Tendency.dragon,
                kept: widget.keptTendency == Tendency.dragon,
              ),
              Spacer(),
              DiceThrowTextPill(
                text: dragon?.toString(),
              ),
              if(!kept)
                Tooltip(
                  message: 'Conserver ce dé',
                  child: ElevatedButton(
                    onPressed: !canSelectKeptDie() ? null : () {
                      setState(() {
                        kept = true;
                      });
                      widget.onDieKept(Tendency.dragon);
                    },
                    child: Icon(Icons.check),
                  ),
                ),
            ],
          ),
          Row(
            spacing: 8.0,
            children: [
              _TendencyDieLabel(
                label: 'Dé de la Fatalité',
                announced: widget.announcedTendency == Tendency.fatality,
                kept: widget.keptTendency == Tendency.fatality,
              ),
              Spacer(),
              DiceThrowTextPill(
                text: fatality?.toString(),
              ),
              if(!kept)
                Tooltip(
                  message: 'Conserver ce dé',
                  child: ElevatedButton(
                    onPressed: !canSelectKeptDie() ? null : () {
                      setState(() {
                        kept = true;
                      });
                      widget.onDieKept(Tendency.fatality);
                    },
                    child: Icon(Icons.check),
                  ),
                ),
            ],
          ),
          Row(
            spacing: 8.0,
            children: [
              _TendencyDieLabel(
                label: "Dé de l'Homme",
                announced: widget.announcedTendency == Tendency.human,
                kept: widget.keptTendency == Tendency.human,
              ),
              Spacer(),
              DiceThrowTextPill(
                text: human?.toString(),
              ),
              if(!kept)
                Tooltip(
                  message: 'Conserver ce dé',
                  child: ElevatedButton(
                    onPressed: !canSelectKeptDie() ? null : () {
                      setState(() {
                        kept = true;
                      });
                      widget.onDieKept(Tendency.human);
                    },
                    child: Icon(Icons.check),
                  ),
                ),
            ],
          ),
        ],
      )
    );
  }
}

class _TendencyDieLabel extends StatelessWidget {
  const _TendencyDieLabel({
    required this.label,
    required this.announced,
    required this.kept,
  });

  final String label;
  final bool announced;
  final bool kept;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      spacing: 8.0,
      children: [
        Text('$label '),
        if(announced)
          Tooltip(
            message: 'Annoncé',
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: Text(
                  'A',
                  style: theme.textTheme.bodySmall!
                      .copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        if(kept)
          Tooltip(
            message: 'Conservé',
            child: Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: Text(
                  'C',
                  style: theme.textTheme.bodySmall!
                      .copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ]
    );
  }
}