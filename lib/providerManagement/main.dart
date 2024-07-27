import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
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
    Logger().d(result);
    for (var x in result.data) {
      Logger().d(x.toString());
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
        body: FutureBuilder<List<Cart>>(
          future: getCarts(),
          builder: (context, snapshot) {
            Logger().d(snapshot.data);

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              List<Cart> data = snapshot.data!;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image(
                          image: NetworkImage(data[index].image),
                          width: 100,
                          height: 100,
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: SizedBox(
                          height: 120,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data[index].title,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                maxLines: 2,
                                style: TextStyle(fontSize: 18),
                              ),
                              const Spacer(),
                              Consumer<CartProvider>(
                                builder: (context, value, _) => Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        value.removeItem(data[index].id);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(4),
                                        child: const Icon(Icons.remove),
                                      ),
                                    ),
                                    Text(value.carts.indexWhere((element) => element.id == data[index].id) != -1
                                        ? value.carts
                                            .firstWhere((element) => element.id == data[index].id)
                                            .qty
                                            .toString()
                                        : '0'),
                                    InkWell(
                                      onTap: () {
                                        value.addItem(data[index]);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(4),
                                        child: const Icon(Icons.add),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: Text('No data available'));
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
