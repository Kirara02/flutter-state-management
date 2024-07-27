import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management/api.dart';
import 'package:state_management/providerManagement/cart.dart';

class ProviderUI extends StatefulWidget {
  const ProviderUI({super.key});

  @override
  State<ProviderUI> createState() => _ProviderUIState();
}

class _ProviderUIState extends State<ProviderUI> {
  Future<List<Cart>> getCarts() async {
    List<Cart> carts = [];
    final result = await dio.get("products");
    for (var x in result.data) {
      carts.add(Cart.create(x));
    }

    return carts;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CartProvider>(
      create: (_) => CartProvider(),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Consumer<CartProvider>(
            builder: (context, value, _) => Text(value.carts.length.toString()),
          ),
        ),
        appBar: AppBar(title: const Text("Provider Management")),
        body: FutureBuilder(
          future: getCarts(),
          initialData: const [],
          builder: (context, snapshot) {
            if (snapshot.data!.isNotEmpty) {
              List<Cart> data = snapshot.data as List<Cart>;
              return ListView.builder(
                itemBuilder: (context, index) => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.red)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image(
                            image: NetworkImage(data[index].image),
                            width: 100,
                            fit: BoxFit.contain,
                          )),
                      const SizedBox(width: 20),
                      Column(
                        children: [
                          Text(
                            data[index].title,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                          Consumer<CartProvider>(
                            builder: (context, value, _) => Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      value.removeItem(data[index].id);
                                    },
                                    child: const Icon(Icons.remove)),
                                // const SizedBox(width: 10),
                                Text(value.carts.indexWhere((element) =>
                                            element.id == data[index].id) !=
                                        -1
                                    ? value.carts
                                        .firstWhere((element) =>
                                            element.id == data[index].id)
                                        .qty
                                        .toString()
                                    : '0'),
                                ElevatedButton(
                                    onPressed: () {
                                      value.addItem(data[index]);
                                    },
                                    child: const Icon(Icons.add)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                itemCount: snapshot.data!.length,
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

extension Currency on String {
  String get toDollar => '\$$this';
}
