import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../widget/custom_text_form_field.dart';
import '../widget/password_criteria.dart';
import '../utils/validators.dart';
import '../widget/phone_button_with_send_code.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.phoneController,
    required this.smsCodeController,
    required this.obscurePassword,
    required this.hasUpperCase,
    required this.hasLowerCase,
    required this.hasNumber,
    required this.hasSpecialCharacter,
    required this.hasMinLength,
    required this.isUsingPhoneNumber,
    required this.isCodeSent,
    required this.onPasswordChanged,
    required this.onToggleUsePhoneNumber,
    required this.onRegister,
    required this.onPhoneNumberChanged,
    required this.onSendCode,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController phoneController;
  final TextEditingController smsCodeController;
  final bool obscurePassword;
  final bool hasUpperCase;
  final bool hasLowerCase;
  final bool hasNumber;
  final bool hasSpecialCharacter;
  final bool hasMinLength;
  final bool isUsingPhoneNumber;
  final bool isCodeSent;
  final ValueChanged<String> onPasswordChanged;
  final ValueChanged<bool> onToggleUsePhoneNumber;
  final VoidCallback onRegister;
  final ValueChanged<PhoneNumber> onPhoneNumberChanged;
  final VoidCallback onSendCode;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Use Phone Number?'),
                  Switch(
                    value: isUsingPhoneNumber,
                    onChanged: onToggleUsePhoneNumber,
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              if (!isUsingPhoneNumber)
                Column(
                  children: [
                    CustomTextFormField(
                      controller: emailController,
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      validator: Validators.validateEmail,
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              const SizedBox(height: 16.0),
              CustomTextFormField(
                controller: passwordController,
                labelText: 'Password',
                obscureText: obscurePassword,
                prefixIcon: const Icon(Icons.lock),
                validator: Validators.validateRegistrationPassword,
                onChanged: onPasswordChanged,
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    onPasswordChanged(passwordController.text);
                  },
                ),
              ),
              const SizedBox(height: 20),
              PasswordCriteria(
                isValid: hasUpperCase,
                label: 'Contains uppercase letter',
              ),
              PasswordCriteria(
                isValid: hasLowerCase,
                label: 'Contains lowercase letter',
              ),
              PasswordCriteria(
                isValid: hasNumber,
                label: 'Contains number',
              ),
              PasswordCriteria(
                isValid: hasSpecialCharacter,
                label: 'Contains special character',
              ),
              PasswordCriteria(
                isValid: hasMinLength,
                label: 'At least 8 characters',
              ),
              const SizedBox(height: 20),
              if (isUsingPhoneNumber) ...[
                InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber number) {
                    phoneController.text = number.phoneNumber!;
                    onPhoneNumberChanged(number);
                  },
                  initialValue: PhoneNumber(isoCode: 'EG'),
                  textFieldController: phoneController,
                  formatInput: true,
                  inputDecoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.DROPDOWN,
                    showFlags: true,
                    useEmoji: true,
                  ),
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    return null;
                  },
                ),
                if (isCodeSent) ...[
                  const SizedBox(height: 16.0),
                  CustomTextFormField(
                    controller: smsCodeController,
                    labelText: 'SMS Code',
                    prefixIcon: const Icon(Icons.message),
                    validator: Validators.validateSmsCode,
                  ),
                ],
                const SizedBox(height: 16.0),
                PhoneButtonWithSendCode(
                  onPressed: onSendCode,
                  text: 'Send Code',
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
