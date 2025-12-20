import 'package:flutter/material.dart';


class ProviderCard extends StatelessWidget {
final String name;
final String phone;


const ProviderCard({super.key, required this.name, required this.phone});


@override
Widget build(BuildContext context) {
return Card(
margin: const EdgeInsets.all(10),
child: ListTile(
title: Text(name),
subtitle: Text(phone),
trailing: const Icon(Icons.call),
),
);
}
}