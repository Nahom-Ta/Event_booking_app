import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/sign_up_controller.dart';

// Changed to GetView to automatically get the controller
class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: controller.signUpFormKey,
        child: ListView(
          padding: const EdgeInsets.all(32),
          children: [
            const Text(
              'Sign up',
              style: TextStyle(
                color: Color(0xff110c26),
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            fullname(),
            const SizedBox(height: 16),
            email(),
            const SizedBox(height: 16),
            password(),
            const SizedBox(height: 16),
            confirmPassword(),
            const SizedBox(height: 32),
            signUp(),
            const SizedBox(height: 16),
            const Center(child: Text('or')),
            const SizedBox(height: 16),
            loginWithGoogle(),
            const SizedBox(height: 12),
            loginWithFacebook(),
            const SizedBox(height: 24),
            signIn(),
          ],
        ),
      ),
    );
  }

  Widget fullname() {
    return TextFormField(
      // controller: controller.fullNamecontroller,
      decoration: InputDecoration(
        labelText: 'Full name',
        hintText: 'Full name',
        prefixIcon: Image.asset('images/icon_user.png'),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your full name';
        }
        return null;
      },
    );
  }

  Widget email() {
    return TextFormField(
      // controller: controller.emailcontroller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email address',
        hintText: 'abc@gmail.com',
        prefixIcon: Image.asset('images/icon_eamil.png'),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!GetUtils.isEmail(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  Widget password() {
    return Obx(
      () => TextFormField(
        controller: controller.passwordController,
        obscureText: controller.isObscurePassword.value,
        decoration: InputDecoration(
          labelText: 'Password',
          hintText: 'Your passwrod',
          prefixIcon: Image.asset('images/icon_lock.png'),
          suffixIcon: IconButton(
            onPressed: () {
              controller.isObscurePassword.toggle();
            },
            icon: Icon(
              controller.isObscurePassword.value
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.length < 6) {
            return 'Password must be at least 6 character long';
          }
          return null;
        },
      ),
    );
  }

  Widget confirmPassword() {
    return Obx(
      () => TextFormField(
        controller: controller.confirmPasswordController,
        obscureText: controller.isObscureConfirmPassword.value,
        decoration: InputDecoration(
          labelText: 'Confirm Password',
          hintText: 'Confirm Password',
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: Image.asset('images/icon_lock.png', width: 20, height: 20),
          ),
          suffixIcon: IconButton(
            onPressed: () {
              controller.isObscureConfirmPassword.toggle();
            },
            icon: Icon(
              controller.isObscureConfirmPassword.value
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
          ),
        ),
        validator: (Value) {
          if (Value == null || Value.isEmpty) {
            return 'Please confirm your password';
          }
          if (Value != controller.passwordController.text) {
            return 'Password do not match';
          }
          return null;
        },
      ),
    );
  }

  Widget signUp() {
    return Obx(
      () => SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : () => controller.registerUser(),
          child: controller.isLoading.value
              ? const CircularProgressIndicator(
                  color: Color.fromARGB(255, 99, 44, 44),
                )
              : const Text('SIGN UP', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  Widget loginWithGoogle() {
    return ElevatedButton.icon(
      onPressed: () {
        //social login logic will be implemented in a future sprint
      },
      icon: Image.asset("images/google.svg", width: 25, height: 25),
      label: const Text('Log in with Google'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey.shade700,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  Widget loginWithFacebook() {
    return ElevatedButton.icon(
      onPressed: () {
        // Social login logic will be implemented in a future sprint
      },
      icon: Image.asset('images/facebook.svg', width: 25, height: 25),
      label: const Text("Log in with Facebook"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey.shade700,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  Widget signIn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account?"),
        TextButton(
          onPressed: () {
            //Navigate to the sign In screen
            //  Get.offAllNamed(Routes.SIGN_IN);
            Get.offAllNamed('/singin');
          },
          child: const Text("Sign in"),
        ),
      ],
    );
  }
}
