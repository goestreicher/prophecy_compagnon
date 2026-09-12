/*
 * Copyright (C) 2024-2026 Grégory Oestreicher
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

class SingleLineInputDialog extends StatelessWidget {
  SingleLineInputDialog({
    super.key,
    required this.title,
    required this.formKey,
    this.hintText = 'Valeur',
  });

  final String title;
  final GlobalKey<FormState> formKey;
  final String hintText;
  final TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: inputController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: hintText,
              ),
              validator: (String? value) {
                if(value == null || value.isEmpty) {
                  return 'La valeur est obligatoire';
                }
                return null;
              },
              onFieldSubmitted: (value) {
                if(formKey.currentState!.validate()) {
                  var input = inputController.text;
                  inputController.clear();
                  Navigator.of(context).pop(input);
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Annuler'),
                  ),
                  const SizedBox(width: 12.0),
                  ElevatedButton(
                    onPressed: () {
                      var input = inputController.text;
                      inputController.clear();
                      Navigator.of(context).pop(input);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                    ),
                    child: const Text('OK'),
                  )
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}