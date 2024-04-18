import 'package:flutter/material.dart';
import 'package:kplayer/theme/index.dart';
import 'package:kplayer/widgets/fileList/index.dart';
import 'package:media_kit/media_kit.dart';
// import 'package:fm/widgets/fileList/item.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(title: 'Flutter Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: FileList(path: '', dirIndex: -1),
      // body: ListView(children: <Widget>[
      //   for (var i = 0; i < 100; i++)
      //     GestureDetector(
      //       onTap: () {
      //         Navigator.of(context).push(MaterialPageRoute(
      //             builder: (context) => ItemDetail(title: 'Item $i')));
      //       },
      //       child: ListTile(
      //         title: Text('Item $i'),
      //       ),
      //     )
      // ]),
      // body: CustomScrollView(
      //   slivers: [
      //     const SliverAppBar(
      //       title: Text('SliverAppBar'),
      //       floating: false,
      //       expandedHeight: 200,
      //       flexibleSpace: FlexibleSpaceBar(),
      //     ),
      //     SliverList(
      //       delegate: SliverChildBuilderDelegate(
      //         (context, index) {
      //           return ListTile(
      //             title: Text('Item $index'),
      //             onTap: () {
      //               Navigator.of(context).push(MaterialPageRoute(
      //                   builder: (context) =>
      //                       ItemDetail(title: 'Item $index')));
      //             },
      //           );
      //         },
      //         childCount: 1000,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}

class ItemDetail extends StatelessWidget {
  final String title;

  const ItemDetail({super.key, required this.title});

  @override
  build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Item Detail ' + title),
      // ),
      body: Center(
        child: Text(title),
      ),
    );
  }
}
