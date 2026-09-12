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

import 'package:file_picker/file_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_shared/classes/storage/storage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({ super.key });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isWorking = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 0.0),
            child: Column(
              spacing: 16.0,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 16.0,
                  children: [
                    ElevatedButton.icon(
                      label: const Text('Exporter les données'),
                      icon: Icon(Icons.download),
                      onPressed: () async {
                        setState(() {
                          isWorking = true;
                        });
                        await FilePicker.saveFile(
                          fileName: 'prophecy-compagnon-mj-export.zip',
                          bytes: await DataStorage.instance.export(),
                        );
                        setState(() {
                          isWorking = false;
                        });
                      },
                    ),
                    ElevatedButton.icon(
                      label: const Text('Importer une sauvegarde'),
                      icon: Icon(Icons.publish),
                      onPressed: () async {
                        var result = await FilePicker.pickFile(
                          type: FileType.custom,
                          allowedExtensions: ['zip'],
                        );
                        if(!context.mounted) return;
                        if(result == null) return;

                        setState(() {
                          isWorking = true;
                        });
                        await DataStorage.instance.import(await result.readAsBytes());
                        setState(() {
                          isWorking = false;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if(isWorking)
          const Opacity(
            opacity: 0.6,
            child: ModalBarrier(
              dismissible: false,
              color: Colors.black,
            ),
          ),
        if(isWorking)
          const Center(
            child: CircularProgressIndicator()
          ),
      ],
    );
  }
}