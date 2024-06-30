import "package:flutter/material.dart";

Widget _buildTextField(String label, TextEditingController controller) {
    return Container(
      width: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16),
     
      child: TextField(
        
        controller: controller,
        decoration: InputDecoration(
          
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      ),
    );
  }