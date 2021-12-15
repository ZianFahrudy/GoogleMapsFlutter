import 'package:flutter/material.dart';

class ConfirmationAddress extends StatelessWidget {
  const ConfirmationAddress({
    Key? key,
    required this.addressLine,
    this.onConfirmation,
  }) : super(key: key);

  final String addressLine;
  final Function()? onConfirmation;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 224,
        child: Card(
          margin: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topRight: Radius.circular(8),
            topLeft: Radius.circular(8),
          )),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Address',
                      ),
                      const SizedBox(height: 5),
                      Text(
                        addressLine,
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: onConfirmation,
                  child: const Text('Konfirmasi Address'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
