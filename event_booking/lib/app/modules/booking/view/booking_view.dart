import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/booking_controller.dart';

class BookingView extends GetView<BookingController> {
  const BookingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Event", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.bookingFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Contact Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              _buildTextField(
                controller.fullNameController,
                "Full Name",
                Icons.person,
              ),
              _buildTextField(
                controller.nicknameController,
                "Nickname",
                Icons.badge,
              ),

              // Gender Dropdown
              Obx(
                () => _buildDropdown("Gender", [
                  "Male",
                  "Female",
                  "Other",
                ], controller.selectedGender),
              ),

              // DOB Field with Picker
              _buildTextField(
                controller.dobController,
                "Date of Birth",
                Icons.calendar_month,
                onTap: () => controller.selectDate(context),
                readOnly: true,
              ),

              _buildTextField(controller.emailController, "Email", Icons.email),
              _buildTextField(
                controller.phoneController,
                "Phone Number",
                Icons.phone,
              ),

              // Country Dropdown
              Obx(
                () => _buildDropdown("Country", [
                  "United States",
                  "Ethiopia",
                  "UK",
                ], controller.selectedCountry),
              ),

              const SizedBox(height: 20),

              // Terms and Conditions Row
              Obx(
                () => Row(
                  children: [
                    Checkbox(
                      value: controller.isTermsAccepted.value,
                      onChanged: (val) =>
                          controller.isTermsAccepted.value = val!,
                      activeColor: Colors.blue,
                    ),
                    const Expanded(
                      child: Text(
                        "I accept the Evento Terms of Service and Privacy Policy",
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: Obx(
                  () => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff5669FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.startBookingProcess(),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Continue",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController ctrl,
    String hint,
    IconData icon, {
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: ctrl,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) => value!.isEmpty ? "Field required" : null,
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    RxString selectedValue,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedValue.value,
            isExpanded: true,
            items: items.map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (newValue) => selectedValue.value = newValue!,
          ),
        ),
      ),
    );
  }
}
