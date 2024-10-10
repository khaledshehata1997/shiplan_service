import 'package:flutter/material.dart';

class CounteriesModel {
  final String id;
  final String name;
  final String image;
  final String price;
  final String priceWithExtra;
  CounteriesModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.priceWithExtra,
  });
}

List<CounteriesModel> counteriesList = [
  CounteriesModel(
    id: '1',
    name: 'الفلبين',
    image: 'https://s3.eu-west-2.amazonaws.com/qmasters/flags/svg/ph.svg',
    price: '14750',
    priceWithExtra: '',
  ),
  CounteriesModel(
    id: '2',
    name: 'اثيوبيا',
    image:
        'https://upload.wikimedia.org/wikipedia/commons/7/71/Flag_of_Ethiopia.svg',
    price: '4990',
    priceWithExtra: '5600',
  ),
  CounteriesModel(
    id: '3',
    name: 'كينيا',
    image:
        'https://upload.wikimedia.org/wikipedia/commons/4/49/Flag_of_Kenya.svg',
    price: '6800',
    priceWithExtra: '',
  ),
  CounteriesModel(
    id: '4',
    name: 'بنغلاديش',
    image:
        'https://upload.wikimedia.org/wikipedia/commons/f/f9/Flag_of_Bangladesh.svg',
    price: '9000',
    priceWithExtra: '',
  ),
  CounteriesModel(
    id: '5',
    name: 'اوغندا',
    image:
        'https://upload.wikimedia.org/wikipedia/commons/4/4e/Flag_of_Uganda.svg',
    price: '5500',
    priceWithExtra: '',
  ),
  CounteriesModel(
    id: '6',
    name: 'سيريلانكا',
    image:
        'https://upload.wikimedia.org/wikipedia/commons/1/11/Flag_of_Sri_Lanka.svg',
    price: '13833',
    priceWithExtra: '14200',
  ),
  CounteriesModel(
    id: '7',
    name: 'بروندي',
    image:
        'https://upload.wikimedia.org/wikipedia/commons/5/50/Flag_of_Burundi.svg',
    price: '6937',
    priceWithExtra: '',
  ),
];

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  CounteriesModel initialList = counteriesList.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<List<CounteriesModel>>(
      value: [initialList],
      onChanged: (value) {
        setState(() {
          initialList = value!.first;
        });
      },
      items: counteriesList
          .map<DropdownMenuItem<List<CounteriesModel>>>(
            (value) => DropdownMenuItem(
              value: [value],
              child: Text(value.name),
            ),
          )
          .toList(),
    );
  }
}

class DropDownList extends StatelessWidget {
  const DropDownList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
