import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:it20025526/src/models/recipe.item.model.dart';
import 'package:it20025526/src/screens/list.screen.dart';

class EditScreen extends StatefulWidget {
  EditScreen({Key? key, required this.recipeItemModel}) : super(key: key);

  final recipeItemTitleController = TextEditingController();
  final recipeItemDescriptionController = TextEditingController();
  final recipeIngredientsController = TextEditingController();
  final itemIdController = TextEditingController();

  final RecipeItemModel recipeItemModel;
  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  @override
  Widget build(BuildContext context) {
    widget.recipeItemTitleController.text = widget.recipeItemModel.title;
    widget.recipeItemDescriptionController.text =
        widget.recipeItemModel.description;
    widget.recipeIngredientsController.text =
        widget.recipeItemModel.ingredients;
    widget.itemIdController.text = widget.recipeItemModel.id;

    final _formKey = GlobalKey<FormState>();
    final _db = FirebaseDatabase.instance.ref().child('recipe');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Edit Recipe"),
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
                          return 'Title is required';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Title',
                          hintText: 'Title'),
                      controller: widget.recipeItemTitleController,
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
                          hintText: 'Description'),
                      maxLines: 4,
                      controller: widget.recipeItemDescriptionController,
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
                                id: widget.itemIdController.text,
                                title: widget.recipeItemTitleController.text,
                                description:
                                    widget.recipeItemDescriptionController.text,
                                ingredients:
                                    widget.recipeIngredientsController.text);
                            editRecipeItem(recipeItemModel);
                          }
                        },
                        child: Text(
                          'Edit Recipe',
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

  Future<void> editRecipeItem(RecipeItemModel recipeItemModel) async {
    try {
      final _db = FirebaseDatabase.instance.ref().child('recipe');

      _db.child(recipeItemModel.id).update({
        'title': recipeItemModel.title,
        'description': recipeItemModel.description,
        "ingredients": recipeItemModel.ingredients,
      });

      Fluttertoast.showToast(
          msg: "Recipe has beem updated Successfully",
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
