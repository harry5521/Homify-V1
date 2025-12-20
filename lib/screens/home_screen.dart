import 'package:flutter/material.dart';
import '../widgets/service_card.dart';


class HomeScreen extends StatelessWidget {
const HomeScreen({super.key});


@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text('Services')),
body: GridView.count(
padding: const EdgeInsets.all(16),
crossAxisCount: 2,
children: const [
ServiceCard(title: 'Electrician'),
ServiceCard(title: 'Plumber'),
ServiceCard(title: 'Cleaning'),
ServiceCard(title: 'Painter'),
],
),
);
}
}