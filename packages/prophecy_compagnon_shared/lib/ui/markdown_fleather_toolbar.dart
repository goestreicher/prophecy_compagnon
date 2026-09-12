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

import 'package:fleather/fleather.dart';
import 'package:material_ui/material_ui.dart';
import 'package:parchment/codecs.dart';
import 'package:prophecy_compagnon_shared/classes/resource_link/resource_link.dart';
import 'package:prophecy_compagnon_shared/ui/resource_link_picker_dialog.dart';

class MarkdownFleatherToolbarFormField extends FormField<bool> {
  MarkdownFleatherToolbarFormField({
    super.key,
    required this.controller,
    bool showResourcePicker = false,
    ResourceLinkProvider? localResourceLinkProvider,
    void Function(String)? onSaved,
  })
    : super(
        initialValue: false,
        onSaved: (bool? hasChanges) {
          onSaved?.call(
            ParchmentMarkdownCodec().encode(controller.document)
          );
        },
        builder: (FormFieldState<bool> s) {
          return MarkdownFleatherToolbar(
            controller: controller,
            showResourcePicker: showResourcePicker,
            localResourceLinkProvider: localResourceLinkProvider,
          );
        }
    );

  final FleatherController controller;
}

class MarkdownFleatherToolbar extends StatefulWidget {
  const MarkdownFleatherToolbar({
    super.key,
    required this.controller,
    this.showResourcePicker = false,
    this.localResourceLinkProvider,
    this.onSaved,
  });

  final FleatherController controller;
  final bool showResourcePicker;
  final ResourceLinkProvider? localResourceLinkProvider;
  final void Function(String)? onSaved;

  @override
  State<MarkdownFleatherToolbar> createState() => _MarkdownFleatherToolbarState();
}

class _MarkdownFleatherToolbarState extends State<MarkdownFleatherToolbar> {
  bool hasPendingChanges = false;

  @override
  void initState() {
    super.initState();

    widget.controller.document.changes.listen((ParchmentChange c) {
      setState(() {
        hasPendingChanges = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var trailing = <Widget>[];

    if(widget.showResourcePicker) {
      trailing.addAll([
        VerticalDivider(
          indent: 16,
          endIndent: 16,
        ),
        FLIconButton(
          onPressed: () async {
            var result = await showDialog<ResourceLink>(
              context: context,
              builder: (BuildContext context) => ResourceLinkPickerDialog(
                localProvider: widget.localResourceLinkProvider,
              ),
            );
            if(result == null) return;

            var selection = widget.controller.selection;
            var selectionLength = selection.extentOffset - selection.baseOffset;

            if(selectionLength == 0) {
              widget.controller.replaceText(
                selection.baseOffset,
                0,
                result.name
              );
              widget.controller.updateSelection(
                TextSelection(
                  baseOffset: widget.controller.selection.baseOffset,
                  extentOffset: widget.controller.selection.baseOffset + result.name.length,
                )
              );
              selectionLength = result.name.length;
            }

            widget.controller.formatSelection(
              ParchmentAttribute.link.fromString(result.link),
            );
            widget.controller.updateSelection(
              TextSelection(
                baseOffset: widget.controller.selection.baseOffset + selectionLength,
                extentOffset: widget.controller.selection.baseOffset + selectionLength,
              )
            );
          },
          size: 32,
          icon: Icon(
            Icons.book_outlined,
            size: 20,
          ),
        ),
      ]);
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.canvasColor,
        borderRadius: BorderRadius.circular(3.0),
      ),
      child: FleatherToolbar.basic(
        controller: widget.controller,
        hideUnderLineButton: true, // Not supported by markdown
        hideForegroundColor: true, // Not supported by markdown
        hideBackgroundColor: true, // Not supported by markdown
        hideDirection: true,
        hideAlignment: true, // Not supported by markdown
        hideIndentation: true, // No-op for markdown
        hideHorizontalRule: true,
        trailing: trailing,
      ),
    );
  }
}

Widget openBaseResourceLinkPickerDialog() {
  return ResourceLinkPickerDialog();
}