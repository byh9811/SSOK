import 'package:flutter/material.dart';
import 'package:ssok/widgets/pockets/all_registered_pocket.dart';
import 'package:ssok/widgets/pockets/not_registered_pocket.dart';
import 'package:ssok/widgets/pockets/registered_pocket.dart';

class PocketPage extends StatefulWidget {
  const PocketPage({super.key});

  @override
  State<PocketPage> createState() => _PocketPageState();
}

class _PocketPageState extends State<PocketPage> {
  @override
  Widget build(BuildContext context) {
    // return NotRegisteredPocket();
    // return RegisteredPocket();
    return AllRegisteredPocket();
  }
}
