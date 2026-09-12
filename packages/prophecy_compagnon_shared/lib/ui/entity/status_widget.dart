import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_shared/classes/entity/combat_status.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/generic_image.dart';
import 'package:prophecy_compagnon_shared/ui/entity/pill_widget.dart';

class EntityStatusWidget extends StatelessWidget {
  const EntityStatusWidget({
    super.key,
    required this.entity,
    required this.iconWidth,
    required this.iconHeight,
    this.image,
  });

  final EntityBase entity;
  final double iconWidth;
  final double iconHeight;
  final GenericImage? image;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      spacing: 8.0,
      children: [
        EntityPillWidget(
          entity: entity,
          width: iconWidth,
          height: iconHeight,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entity.name,
              style: theme.textTheme.titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
            ),
            ListenableBuilder(
              listenable: entity.healthStatus,
              builder: (BuildContext context, Widget? child) {
                var healthStatuses = <String>[];
                // TODO: loop

                String healthStatus;
                if(healthStatuses.isNotEmpty) {
                  healthStatus = healthStatuses.join(', ');
                }
                else {
                  healthStatus = 'OK';
                }

                return Text(
                  'Santé : $healthStatus',
                  style: theme.textTheme.bodySmall,
                );
              }
            ),
            ListenableBuilder(
              listenable: entity.combatStatus,
              builder: (BuildContext context, Widget? child) {
                var combatStatuses = <String>[];
                for(var s in EntityCombatStatusFlag.values) {
                  if(entity.combatStatus.has(s)) {
                    combatStatuses.add(s.label);
                  }
                }

                String combatStatus;
                if(combatStatuses.isNotEmpty) {
                  combatStatus = combatStatuses.join(', ');
                }
                else {
                  combatStatus = "OK";
                }

                return Text(
                  'Statut de combat : $combatStatus',
                  style: theme.textTheme.bodySmall,
                );
              }
            ),
          ],
        ),
      ],
    );
  }
}