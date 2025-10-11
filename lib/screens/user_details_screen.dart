import 'package:flutter/material.dart';
import 'package:tasky/core/widget/custom_text_form_field.dart';

class UserDetailsScreen extends StatelessWidget {
  UserDetailsScreen({super.key});

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController motivationQuoteController =
      TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

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
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  if(_key.currentState?.validate() ?? false){

                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff15B86C),
                  foregroundColor: Color(0xffFFFCFC),
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
