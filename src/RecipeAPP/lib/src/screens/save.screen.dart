import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:it20025526/src/models/recipe.item.model.dart';
import 'package:it20025526/src/screens/list.screen.dart';
import 'package:it20025526/src/screens/login.screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class SaveScreen extends StatefulWidget {
  SaveScreen({Key? key}) : super(key: key);
  final recipeTitleController = TextEditingController();
  final recipeDescriptionController = TextEditingController();
  final recipeIngredientsController = TextEditingController();

  @override
  State<SaveScreen> createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  late DatabaseReference _itemRef;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Save Recipe"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    child: Icon(
                      Icons.food_bank_rounded,
                      size: 100,
                      color: Color.fromARGB(255, 91, 153, 205),
                    )),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name is required';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Name',
                          hintText: 'Enter Valid Name'),
                      controller: widget.recipeTitleController,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Description is required';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Description',
                          hintText: 'Enter Description'),
                      maxLines: 4,
                      controller: widget.recipeDescriptionController,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingredients is required';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Ingredients',
                          hintText: 'Ingredients'),
                      maxLines: 4,
                      controller: widget.recipeIngredientsController,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20)),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            RecipeItemModel recipeItemModel = RecipeItemModel(
                                id: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                title: widget.recipeTitleController.text,
                                description:
                                    widget.recipeDescriptionController.text,
                                ingredients:
                                    widget.recipeIngredientsController.text);
                            saveRecipe(recipeItemModel);
                          }
                        },
                        child: Text(
                          'Save Item',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 130,
                    ),
                  ]),
                )),
          ],
        ),
      ),
    );
  }

  Future<void> saveRecipe(RecipeItemModel recipeItemModel) async {
    try {
      final _db = FirebaseDatabase.instance.ref().child('recipe');

      _db.child(recipeItemModel.id).set({
        'id': recipeItemModel.id,
        'title': recipeItemModel.title,
        'description': recipeItemModel.description,
        "ingredients": recipeItemModel.ingredients
      });

      Fluttertoast.showToast(
          msg: "Recipe has been saved Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.push(context, MaterialPageRoute(builder: (_) => ListScreen()));
    } catch (exception) {
      Fluttertoast.showToast(
          msg: "Error has been Occured please try again",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
