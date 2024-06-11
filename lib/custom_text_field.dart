import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final TextEditingController? controller;
  bool obscureText;
  final IconData? suffixIcon;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;

  CustomTextField({
    super.key,
    required this.labelText,
    this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.onChanged,
    this.keyboardType,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        obscureText: widget.obscureText,
        style: const TextStyle(fontWeight: FontWeight.bold),
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: const TextStyle(color: Colors.black, fontSize: 18),
          border: InputBorder.none,
          suffixIcon: widget.suffixIcon != null
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      widget.obscureText = !widget.obscureText;
                    });
                  },
                  icon: Icon(widget.suffixIcon),
                )
              : null,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
