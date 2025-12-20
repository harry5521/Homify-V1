import 'package:flutter/material.dart';
import '../screens/providers_list_screen.dart';


class ServiceCard extends StatelessWidget {
final String title;


const ServiceCard({super.key, required this.title});


@override
Widget build(BuildContext context) {
return Card(
child: InkWell(
onTap: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (_) => ProvidersListScreen(serviceName: title),
),
);
},
child: Center(child: Text(title)),
),
);
}
}