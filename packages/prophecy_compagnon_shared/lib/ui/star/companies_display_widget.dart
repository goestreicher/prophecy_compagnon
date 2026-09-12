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
import 'package:prophecy_compagnon_shared/classes/resource_link/resource_link.dart';
import 'package:prophecy_compagnon_shared/classes/star.dart';
import 'package:prophecy_compagnon_shared/ui/star/company_display_widget.dart';
import 'package:prophecy_compagnon_shared/ui/star/company_edit_dialog.dart';
import 'package:prophecy_compagnon_shared/ui/uniform_height_wrap.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class StarCompaniesDisplayWidget extends StatefulWidget {
  const StarCompaniesDisplayWidget({
    super.key,
    required this.star,
    this.edit = false,
    this.resourceLinkProvider,
  });

  final Star star;
  final bool edit;
  final ResourceLinkProvider? resourceLinkProvider;

  @override
  State<StarCompaniesDisplayWidget> createState() => _StarCompaniesDisplayWidgetState();
}

class _StarCompaniesDisplayWidgetState extends State<StarCompaniesDisplayWidget> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Compagnies',
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Column(
        spacing: 12.0,
        children: [
          UniformHeightWrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              for(var c in widget.star.companies)
                StarCompanyDisplayWidget(
                  company: c,
                  onEdit: !widget.edit ? null : () async {
                    var company = await showDialog(
                      context: context,
                      builder: (BuildContext context) => StarCompanyEditDialog(
                        company: c,
                        resourceLinkProvider: widget.resourceLinkProvider,
                      ),
                    );
                    if(!context.mounted) return;
                    if(company == null) return;

                    setState(() {
                      widget.star.companies.remove(c);
                      widget.star.companies.add(company);
                    });
                  },
                  onDelete: !widget.edit ? null : () {
                    setState(() {
                      widget.star.companies.remove(c);
                    });
                  },
                )
            ],
          ),
          if(widget.edit)
            ElevatedButton.icon(
              icon: const Icon(
                Icons.add,
                size: 16.0,
              ),
              style: ElevatedButton.styleFrom(
                textStyle: theme.textTheme.bodySmall,
              ),
              label: const Text('Nouvelle compagnie'),
              onPressed: () async {
                var company = await showDialog(
                  context: context,
                  builder: (BuildContext context) => StarCompanyEditDialog(),
                );
                if(!context.mounted) return;
                if(company == null) return;

                setState(() {
                  widget.star.companies.add(company);
                });
              },
            ),
        ],
      )
    );
  }
}