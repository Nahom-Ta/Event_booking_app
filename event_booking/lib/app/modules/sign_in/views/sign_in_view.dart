import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:event_booking/app/routes/app_pages.dart';
import '../controllers/sign_in_controller.dart';

class SignInView extends GetView<SignInController> {
  const SignInView({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: controller.signInFormKey,
        child: ListView(
          padding: const EdgeInsets.all(32),
          children: [
            const SizedBox(height: 100),
            Image.asset('images/logo.svg', width: 100, height: 100),
            const SizedBox(height: 12),
            const Text(
              "Sign in",
              style: TextStyle(
                color: Color(0xff110c26),
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            email(),
            const SizedBox(height: 12),
            password(),
            const SizedBox(height: 12),
            rememberMeNForgotpassword(),
            const SizedBox(height: 12),
            signIn(),
            const SizedBox(height: 12),
            loginWithGoogle(),
            const SizedBox(height: 12),
            loginWithFacebook(),
            const SizedBox(height: 24),
            signUp(),
          ],
        ),
      ),
    );
  }

  Widget email() {
    return TextFormField(
      controller: controller.emailController,
      keyboardType: TextInputType.emailAddress,
      //add validator
      validator: (value) {
        if (value == null || !GetUtils.isEmail(value)) {
          return 'Please enter a valid email ';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Email adress',
        hintText: 'abc@email.com',
        prefixIcon: Image.asset(
          'images/icon_eamil.png',
        ), //error on the image name correct it latter
      ),
    );
  }

  Widget password() {
    return Obx(
      () => TextFormField(
        controller: controller.passwordController,
        keyboardType: TextInputType.text,
        obscureText: controller.isObscure.value,
        // add validator
        validator: (value) {
          if (value == null || value.isEmpty) {
            return ' Please enter your password';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: 'Password',
          hintText: 'Your password',
          prefixIcon: Image.asset('images/icon_lock.png'),
          suffixIcon: IconButton(
            onPressed: () => controller.isObscure.toggle(),
            icon: controller.isObscure.value
                ? Icon(Icons.visibility_off_outlined)
                : Icon(Icons.visibility_off_outlined),
          ),
        ),
      ),
    );
  }

  Widget signIn() {
    return Obx(
      () => ElevatedButton(
        // call the loginUser method
        onPressed: controller.isLoading.value
            ? null
            : () => controller.loginUser(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              //show loader or text based on loading state
              if (controller.isLoading.value)
                const CircularProgressIndicator(color: Colors.white)
              else
                const Text('SIGN IN'),
              if (!controller.isLoading.value)
                const Align(
                  alignment: Alignment.centerRight,
                  child: CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 219, 221, 238),
                    child: Icon(Icons.arrow_forward),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  //
  Widget rememberMeNForgotpassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Obx(
              () => Switch(
                value: controller.rememberMe.value,
                onChanged: (value) {
                  controller.rememberMe.value = value;
                },
                activeColor: Get.theme.primaryColor,
              ),
            ),
            const Text('Remember me'),
          ],
        ),
        TextButton(
          onPressed: () {
            // Get.toNamed(Routes.RESET_PASSWORD);
          },
          child: const Text('Forget password?'),
        ),
      ],
    );
  }

  Widget signUp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?"),
        TextButton(
          onPressed: () {
            // Get.toNamed(Routes.SIGN_UP);
          },
          child: const Text("Sign up"),
        ),
      ],
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
}
