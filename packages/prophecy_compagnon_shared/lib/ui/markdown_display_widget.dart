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
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:prophecy_compagnon_shared/classes/resource_link/resource_link.dart';
import 'package:prophecy_compagnon_shared/ui/resource_link/link_handler.dart';

class MarkdownDisplayWidget extends StatelessWidget {
  const MarkdownDisplayWidget({
    super.key,
    required this.data,
    this.extraActionButtonBuilders,
  });

  final String data;
  final Map<ResourceLinkType, List<ExtraActionButtonBuilder>>? extraActionButtonBuilders;

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: data,
      onTapLink: (String text, String? href, String title) async {
        if(href == null) return;
        if(!ResourceLink.isValidLink(href)) return;

        var link = ResourceLink(name: text, link: href);
        handleResourceLinkClicked(
          link,
          context,
          extraActionButtonBuilders: extraActionButtonBuilders?[link.type],
        );
      },
    );
  }
}