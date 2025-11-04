import 'package:flutter/material.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/core/widget/custom_text_form_field.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({
    super.key,
    required this.userName,
    required this.motivationQuote,
  });

  final String userName;
  final String? motivationQuote;

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late final TextEditingController userNameController;
  late final TextEditingController motivationQuoteController;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    userNameController = TextEditingController(text: widget.userName);
    motivationQuoteController = TextEditingController(
      text: widget.motivationQuote,
    );
  }

  void setUserDetails() async {
    await PreferencesManager().setString(
      'username',
      userNameController.value.text,
    );
    await PreferencesManager().setString(
      'motivation_quote',
      motivationQuoteController.value.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Details')),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _key,
          child: Column(
            children: [
              CustomTextFormField(
                title: 'User Name',
                controller: userNameController,
                hintText: 'Abdullah Abdullatif',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Add your Name';
                  }
                },
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                title: 'Motivation Quote',
                controller: motivationQuoteController,
                hintText: 'One task at a time. One step closer.',
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Add Motivation Quote';
                  }
                },
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () async {
                  if (_key.currentState?.validate() ?? false) {
                    //get shared preference
                    //save new key -> motivation_quote ->String
                    // setUserDetails();
                    await PreferencesManager().setString(
                      'username',
                      userNameController.value.text,
                    );
                    await PreferencesManager().setString(
                      'motivation_quote',
                      motivationQuoteController.value.text,
                    );
                    Navigator.of(context).pop(true);
                  }
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width, 40),
                ),
                child: Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
