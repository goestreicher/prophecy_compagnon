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
import 'package:prophecy_compagnon_mj/ui/table/pc_wizard/model.dart';

abstract class PlayerCharacterWizardStepData {
  PlayerCharacterWizardStepData({
    required this.title,
    this.canSkip = false,
    this.completed = false,
    this.changed = false,
    this.clearNextOnChange = true,
  });

  String title;
  bool canSkip;
  bool completed;
  bool changed;
  bool clearNextOnChange;

  Widget overviewWidget(BuildContext context);
  List<Widget> stepWidget(BuildContext context);
  void reset(PlayerCharacterWizardModel model);
  void init(PlayerCharacterWizardModel model);
  void clear();
  bool validate(PlayerCharacterWizardModel model, BuildContext context);
  void save(PlayerCharacterWizardModel model);
  
  Widget sliverWrap(List<Widget> widgets) {
    return SliverList(
      delegate: SliverChildListDelegate(widgets)
    );
  }
}