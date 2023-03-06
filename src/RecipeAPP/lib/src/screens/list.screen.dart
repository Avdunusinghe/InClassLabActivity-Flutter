import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:it20025526/src/models/recipe.item.model.dart';
import 'package:it20025526/src/screens/edit.screen.dart';
import 'package:it20025526/src/screens/save.screen.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  Query dbRef = FirebaseDatabase.instance.ref().child('recipe');
  DatabaseReference reference = FirebaseDatabase.instance.ref().child('recipe');

  Widget configureListOfRecipeContainer({required Map item}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.white,
        title: Text(
          item["title"],
          style: TextStyle(
            fontSize: 16,
            color: Color.fromARGB(255, 28, 29, 29),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              color: Colors.yellow,
              onPressed: () {
                RecipeItemModel itemModel = RecipeItemModel(
                  id: item['id'],
                  title: item['title'],
                  description: item['description'],
                  ingredients: item['ingredients'],
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EditScreen(recipeItemModel: itemModel)),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Edit pressed'),
                  ),
                );
              },
              icon: Icon(Icons.edit),
            ),
            IconButton(
              color: Colors.red,
              onPressed: () async {
                if (await confirm(
                  context,
                  title: const Text('Confirm'),
                  content: const Text('Are you Sure Delete Recipe?'),
                  textOK: const Text('Yes'),
                  textCancel: const Text('No'),
                )) {
                  reference.child(item['id']).remove();
                }
              },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
              margin: EdgeInsets.all(20),
              alignment: Alignment.topLeft,
              child: IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SaveScreen()));
                  },
                  icon: Icon(
                    Icons.add,
                    size: 50,
                    color: Color(0xff003F36),
                  ))),
          Expanded(
            child: FirebaseAnimatedList(
              query: dbRef,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                Map Item = snapshot.value as Map;
                Item['id'] = snapshot.key;

                return configureListOfRecipeContainer(item: Item);
              },
            ),
          ),
        ],
      ),
    );
  }
}
