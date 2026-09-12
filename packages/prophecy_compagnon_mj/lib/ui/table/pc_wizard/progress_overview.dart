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
import 'package:prophecy_compagnon_mj/ui/table/pc_wizard/step_data.dart';
import 'package:prophecy_compagnon_mj/ui/table/pc_wizard/stepper.dart';
import 'package:provider/provider.dart';

class PlayerCharacterWizardProgressOverview extends StatelessWidget {
  const PlayerCharacterWizardProgressOverview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var stepper = context.watch<PlayerCharacterWizardStepper>();

    var children = <Widget>[];
    for(var (index, step) in stepper.steps.indexed) {
      children.addAll([
        _StepOverviewWidget(
          index: index,
          stepData: step,
          isCurrent: index == stepper.currentStep,
        ),
        Divider(),
      ]);
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Divider(),
          ...children,
        ],
      ),
    );
  }
}

class _StepOverviewWidget extends StatelessWidget {
  const _StepOverviewWidget({
    required this.index,
    required this.stepData,
    this.isCurrent = false,
  });

  final int index;
  final PlayerCharacterWizardStepData stepData;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var stepper = context.watch<PlayerCharacterWizardStepper>();

    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12.0,
          children: [
            Row(
              spacing: 12,
              children: [
                if(isCurrent)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  ),
                if(!isCurrent)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: stepData.completed ? theme.colorScheme.secondary : Colors.black26,
                      borderRadius: BorderRadius.circular(48.0),
                    ),
                    child: Center(
                      child: Text(
                        (index+1).toString(),
                        style: theme.textTheme.bodySmall!
                          .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                Text(
                  stepData.title,
                  style: theme.textTheme.titleLarge!
                    .copyWith(
                      fontWeight: FontWeight.bold,
                      color: stepData.completed || isCurrent ? null : Colors.black26,
                    ),
                ),
              ],
            ),
            if(stepper.currentStep > index)
              stepData.overviewWidget(context),
          ],
        )
      ],
    );
  }
}