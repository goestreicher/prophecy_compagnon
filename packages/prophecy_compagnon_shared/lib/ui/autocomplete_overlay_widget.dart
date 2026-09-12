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

class AutocompleteOverlayWidget extends StatefulWidget {
  const AutocompleteOverlayWidget({
    required super.key,
    required this.focusNode,
    required this.childBuilder,
    required this.onInput,
  });

  final FocusNode focusNode;
  final Widget Function(BuildContext, void Function(String)) childBuilder;
  final void Function(String) onInput;

  @override
  State<AutocompleteOverlayWidget> createState() => _AutocompleteOverlayWidgetState();
}

class _AutocompleteOverlayWidgetState extends State<AutocompleteOverlayWidget> {
  OverlayPortalController detailsController = OverlayPortalController();

  @override
  void initState() {
    super.initState();

    widget.focusNode.addListener(focusChanged);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(focusChanged);

    super.dispose();
  }

  void focusChanged() {
    if(widget.focusNode.hasFocus && !detailsController.isShowing) {
      detailsController.show();
    }
  }

  void tapOutside(PointerDownEvent event) {
    if(detailsController.isShowing) {
      detailsController.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal.overlayChildLayoutBuilder(
      controller: detailsController,
      overlayChildBuilder: (BuildContext context, OverlayChildLayoutInfo layoutInfo) {
        // This is lifted from flutter/lib/src/widgets/autocomplete.dart

        final EdgeInsets mediaQueryPadding = MediaQuery.paddingOf(context);
        final EdgeInsets viewInsets = MediaQuery.viewInsetsOf(context);

        final Rect overlayRect = mediaQueryPadding.deflateRect(
          viewInsets.deflateRect(Offset.zero & layoutInfo.overlaySize),
        );

        final Matrix4 invertTransform = layoutInfo.childPaintTransform.clone()..invert();
        final Rect overlayRectInField = MatrixUtils.transformRect(
            invertTransform,
            overlayRect
        );

        final boundingBox = Size(
          layoutInfo.childSize.width,
          max(overlayRectInField.bottom, kMinInteractiveDimension),
        );

        final Matrix4 transform = layoutInfo.childPaintTransform.clone()
          ..translateByDouble(0.0, overlayRectInField.bottom - boundingBox.height, 0, 1);

        return Transform(
          transform: transform,
          child: Align(
            alignment: Alignment.topLeft,
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: TapRegion(
                onTapOutside: tapOutside,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: boundingBox.width,
                  ),
                  child: widget.childBuilder(
                    context,
                        (String v) {
                      widget.onInput(v);
                      detailsController.hide();
                    }
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: const SizedBox(width: double.infinity, height: 0.0),
    );
  }
}