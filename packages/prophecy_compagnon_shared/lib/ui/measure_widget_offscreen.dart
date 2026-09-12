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
import 'package:flutter/rendering.dart';

Size measureWidgetOffscreen(Widget root) {
  var measured = Size.zero;

  final PipelineOwner pipelineOwner = PipelineOwner();
  final _MeasurementView rootView = pipelineOwner.rootNode = _MeasurementView(BoxConstraints());
  final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());
  final RenderObjectToWidgetElement<RenderBox> element = RenderObjectToWidgetAdapter<RenderBox>(
      container: rootView,
      debugShortDescription: '[root]',
      child: Directionality(textDirection: TextDirection.ltr, child: root),
    ).attachToRenderTree(buildOwner);

  try {
    rootView.scheduleInitialLayout();
    pipelineOwner.flushLayout();
    measured = rootView.size;
  } finally {
    // Clean up.
    element.update(RenderObjectToWidgetAdapter<RenderBox>(container: rootView));
    buildOwner.finalizeTree();
  }

  return measured;
}

class _MeasurementView extends RenderBox with RenderObjectWithChildMixin<RenderBox> {
  _MeasurementView(this.boxConstraints);

  final BoxConstraints boxConstraints;

  @override
  void performLayout() {
    assert(child != null);
    child!.layout(boxConstraints, parentUsesSize: true);
    size = child!.size;
  }

  @override
  void debugAssertDoesMeetConstraints() => true;
}