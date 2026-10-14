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
import 'package:prophecy_compagnon_shared/classes/dice/throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_result.dart';
import 'package:prophecy_compagnon_shared/classes/session/game_session.dart';
import 'package:prophecy_compagnon_shared/ui/entity/pill_widget.dart';

class DiceThrowHistoryWidget extends StatefulWidget {
  const DiceThrowHistoryWidget({
    super.key,
  });

  @override
  State<DiceThrowHistoryWidget> createState() => _DiceThrowHistoryWidgetState();
}

class _DiceThrowHistoryWidgetState extends State<DiceThrowHistoryWidget> {
  @override
  Widget build(BuildContext context) {
    var history = GameSession.instance!.diceThrowHistory;

    return ListenableBuilder(
      listenable: GameSession.instance!.diceThrowHistory,
      builder: (BuildContext context, Widget? child) {
        var theme = Theme.of(context);

        return ListView.builder(
          reverse: true,
          itemCount: history.length,
          itemBuilder: (BuildContext context, int index) {
            var entry = history.elementAt(index);

            return Card(
              key: ValueKey(entry.uuid),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8.0,
                  children: [
                    EntityPillWidget(
                      entity: entry.actor,
                      width: 40.0,
                      height: 40.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4.0,
                      children: [
                        Text(
                          entry.request.base.label,
                          style: theme.textTheme.bodyLarge,
                        ),
                        if(entry.request.context != DiceThrowRequestContext.none)
                          Text(
                            'Contexte : ${entry.request.context.title}',
                            style: theme.textTheme.bodySmall,
                          ),
                        Text(
                          'Résultat : ${entry.evaluation.resultLabel}',
                          style: theme.textTheme.bodySmall,
                        ),
                        if(entry.evaluation.resultType == DiceThrowResultType.success)
                          Text(
                            'Marge : +${entry.evaluation.margin.toString()} / ${entry.evaluation.nr.toString()} NR',
                            style: theme.textTheme.bodySmall,
                          )
                      ],
                    )
                  ],
                )
              ),
            );
          },
        );
      }
    );
  }
}