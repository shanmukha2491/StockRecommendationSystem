import "package:flutter/material.dart";

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: const TextField(
        decoration: InputDecoration(
          labelText: "Search",
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search)
        ),),
    );
  }
}