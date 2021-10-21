import 'package:flutter/material.dart';
import 'package:global_strongman/constants.dart';

class MaterialFormFields extends StatelessWidget {
  const MaterialFormFields({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(
        top: kSpacing,
        bottom: kSpacing,
      ),
      child: Column(
        children: [
          TextFormField(
            // Todo  controller: userController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 12, right: 12),
              labelText: "First Name",
              // filled: true,
              // fillColor: Colors.white,
              //    border: InputBorder.none,
            ),
            // Todo  validator: _validateEmail,
          ),
          const SizedBox(
            height: kSpacing,
          ),
          TextFormField(
            // Todo  controller: userController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 12, right: 12),
              // filled: true,
              // fillColor: Colors.white,
              // border: InputBorder.none,
              labelText: "Last Name",
            ),
            // Todo  validator: _validateEmail,
          ),
          const SizedBox(
            height: kSpacing,
          ),
          Container(
            margin: const EdgeInsets.only(left: 12, right: 12),
            child: DropdownButton<String>(
              items: [for (var i = 18; i <= 99; i++) i.toString()].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: const Text("Age"),
              isExpanded: true,
              onChanged: (value) {
                print(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
