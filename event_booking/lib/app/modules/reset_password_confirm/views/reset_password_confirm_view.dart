import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:event_booking/app/modules/reset_password_confirm/controllers/reset_password_confirm_controller.dart';

class ResetPasswordConfirmView extends GetView<ResetPasswordConfirmController> {
  const ResetPasswordConfirmView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm Reset"),
        centerTitle: true,
        elevation: 0,
        // backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Form(
        key: controller.confirmFormKey,
        child: ListView(
          padding: const EdgeInsets.all(32),
          children: [
            const Text(
              'Enter Code & New Password',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold, // Added weight
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'A 6-digit code was sent to',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ), //${controller.email} you will add this on the string now the email is late not intialized
            const SizedBox(height: 24),
            Pinput(
              controller: controller.codeController,
              length: 6,
              validator: (s) => s?.length == 6 ? null : 'Code must be 6 digit',
            ),
            const SizedBox(height: 24),
            Obx(
              () => TextFormField(
                controller: controller.passwordController,
                obscureText: controller.isObscurePass.value,
                validator: (s) => s!.length < 8 ? 'Password too short' : null,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  suffixIcon: IconButton(
                    onPressed: () => controller.isObscurePass.toggle(),
                    icon: Icon(
                      controller.isObscurePass.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () => TextFormField(
                controller: controller.passwordController,
                obscureText: controller.isObscureConfirm.value,
                validator: controller.validateConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  suffixIcon: Icon(
                    controller.isObscureConfirm.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.confirmPasswordReset(),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : const Text('Reset Password'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
