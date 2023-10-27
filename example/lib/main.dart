import 'package:example/models/cart.dart';
import 'package:example/models/catelog.dart';
import 'package:example/providers/cart_provider.dart';
import 'package:miladtech_shopping_cart/miladtech_shopping_cart.dart';
import 'package:provider/provider.dart';

import 'cart_screen.dart';
import 'catalog_screen.dart';

void main() async {
  /// if you are using await in main function then add this line
  WidgetsFlutterBinding.ensureInitialized();
  await ShoppingCart().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Using MultiProvider is convenient when providing multiple objects.
    return MultiProvider(
      providers: [
        // In this sample app, CatalogModel never changes, so a simple Provider
        // is sufficient.
        Provider(create: (context) => CatalogModel()),

        /// CartModel is implemented as a ChangeNotifier, which calls for the use
        /// of ChangeNotifierProvider. Moreover, CartModel depends
        /// on CatalogModel, so a ProxyProvider is needed.
        ChangeNotifierProxyProvider<CatalogModel, CartModel>(
          create: (context) => CartModel(),
          update: (context, catalog, cart) {
            if (cart == null) throw ArgumentError.notNull('cart');
            cart.catalog = catalog;
            return cart;
          },
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProviderShoppingCart(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Shopping Cart',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const MyCatalog(),
        initialRoute: '/catalog',
        routes: {
          // '/': (context) => MyLogin(),
          '/catalog': (context) => const MyCatalog(),
          '/cart': (context) => const MyCart(),
        },
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  const MyForm({Key? key}) : super(key: key);
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Flutter Shopping Cart'),
        ),
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                children: const [],
              )
            ],
          ),
        ));
  }
}
