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
import 'package:prophecy_compagnon_shared/classes/dice/throw_entity_base_skill.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_result.dart';
import 'package:prophecy_compagnon_shared/classes/entity/abilities.dart';
import 'package:prophecy_compagnon_shared/classes/entity/attributes.dart';
import 'package:prophecy_compagnon_shared/classes/entity/combat_status.dart';
import 'package:prophecy_compagnon_shared/classes/entity/skill.dart';
import 'package:prophecy_compagnon_shared/classes/session/entity_effect.dart';
import 'package:prophecy_compagnon_shared/classes/session/entity_effects/combat_status.dart';
import 'package:prophecy_compagnon_shared/classes/session/game_session.dart';
import 'package:prophecy_compagnon_shared/ui/entity/status_widget.dart';
import 'package:prophecy_compagnon_shared/ui/session/clients/session_message_bus_client.dart';
import 'package:prophecy_compagnon_shared/ui/session/entity_dice_throw_dialog.dart';
import 'package:prophecy_compagnon_shared/ui/session/evaluate_dice_throw.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/status/entity_effect.dart';
import 'package:provider/provider.dart';

class PlayCharactersPage extends StatelessWidget {
  const PlayCharactersPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var session = context.read<GameSession>();

    var pcWidgets = <Widget>[];
    for(var pc in session.table.players) {
      pcWidgets.add(
        Row(
          spacing: 16.0,
          children: [
            EntityStatusWidget(
              entity: pc,
              iconWidth: 50.0,
              iconHeight: 50.0,
            ),
            TextButton(
              onPressed: () async {
                var request = DiceThrowRequest(
                  difficulty: 15,
                  base: DiceThrowEntityBaseSkill(
                    attribute: Attribute.physique,
                    ability: Ability.force,
                    skill: Skill.athletisme,
                  )
                );

                var result = await showDialog<DiceThrowResult>(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) => EntityDiceThrowDialog(
                    entity: pc,
                    request: request,
                  ),
                );
                if(result == null) return;

                var bundle = EntityThrowBundle(
                  entity: pc,
                  request: request,
                  result: result,
                );

                var evaluation = evaluateDiceThrow(bundle);
                if(evaluation.criticalType == DiceThrowResultType.criticalFail) {
                  SessionMessageBusClient.instance?.publish(
                    SessionEntitySetEffectMessage(
                      broadcastIncludesSelf: true,
                      entityId: pc.id,
                      effect: EffectSetCombatStatus(
                        status: EntityCombatStatusFlag.onGround,
                      )
                    )
                  );
                }
              },
              child: Text('click-o'),
            )
          ],
        )
      );
    }

    return Column(
      spacing: 12.0,
      children: pcWidgets,
    );
  }
}