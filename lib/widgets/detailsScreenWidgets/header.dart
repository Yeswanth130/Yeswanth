import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:whether/helpers.dart';

class Header extends StatelessWidget {
  const Header({super.key, required this.callLog});

  final CallLogEntry callLog;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              getTitle(callLog),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
            )
          ]),
        ],
      ),
    );
  }
}