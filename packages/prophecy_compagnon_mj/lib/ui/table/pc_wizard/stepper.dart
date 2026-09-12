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

import 'package:flutter/foundation.dart';
import 'package:prophecy_compagnon_mj/ui/table/pc_wizard/step_data.dart';
import 'package:prophecy_compagnon_mj/ui/table/pc_wizard/step_data_0_concept.dart';
import 'package:prophecy_compagnon_mj/ui/table/pc_wizard/step_data_10_xp.dart';
import 'package:prophecy_compagnon_mj/ui/table/pc_wizard/step_data_11_skill_points.dart';
import 'package:prophecy_compagnon_mj/ui/table/pc_wizard/step_data_12_equipment.dart';
import 'package:prophecy_compagnon_mj/ui/table/pc_wizard/step_data_13_names.dart';
import 'package:prophecy_compagnon_mj/ui/table/pc_wizard/step_data_1_augure.dart';
import 'package:prophecy_compagnon_mj/ui/table/pc_wizard/step_data_2_age.dart';
import 'package:prophecy_compagnon_mj/ui/table/pc_wizard/step_data_3_caste.dart';
import 'package:prophecy_compagnon_mj/ui/table/pc_wizard/step_data_4_abilities.dart';
import 'package:prophecy_compagnon_mj/ui/table/pc_wizard/step_data_5_attributes.dart';
import 'package:prophecy_compagnon_mj/ui/table/pc_wizard/step_data_6_tendencies.dart';
import 'package:prophecy_compagnon_mj/ui/table/pc_wizard/step_data_7_disadvantages.dart';
import 'package:prophecy_compagnon_mj/ui/table/pc_wizard/step_data_8_advantages.dart';
import 'package:prophecy_compagnon_mj/ui/table/pc_wizard/step_data_9_base_skills.dart';

class PlayerCharacterWizardStepper extends ChangeNotifier {
  PlayerCharacterWizardStepper();

  int get currentStep => _currentStep;
  set currentStep(int v) {
    _currentStep = v;
    notifyListeners();
  }
  int _currentStep = 0;

  List<PlayerCharacterWizardStepData> steps =
    <PlayerCharacterWizardStepData>[
      PlayerCharacterWizardStepDataConcept(),
      PlayerCharacterWizardStepDataAugure(),
      PlayerCharacterWizardStepDataAge(),
      PlayerCharacterWizardStepDataCaste(),
      PlayerCharacterWizardStepDataAbilities(),
      PlayerCharacterWizardStepDataAttributes(),
      PlayerCharacterWizardStepDataTendencies(),
      PlayerCharacterWizardStepDataDisadvantages(),
      PlayerCharacterWizardStepDataAdvantages(),
      PlayerCharacterWizardStepDataBaseSkills(),
      PlayerCharacterWizardStepDataXP(),
      PlayerCharacterWizardStepDataSkillPoints(),
      PlayerCharacterWizardStepDataEquipment(),
      PlayerCharacterWizardStepDataNames(),
    ];
}