import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hive/boxes/box.dart';
import 'package:flutter_hive/models/notes_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hive database")),
      body: ValueListenableBuilder<Box<NotesModel>>(
          valueListenable: Boxes.getData().listenable(),
          builder: (context,box,_){
            final data=box.values.toList().cast<NotesModel>();
            return ListView.builder(
              itemCount: box.length,
                itemBuilder: (context,index){
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(data[index].tittle.toString()),
                              Spacer(),
                              InkWell(
                                  onTap: (){
                                    delete(data[index]);
                                  },
                                  child: Icon(Icons.delete,color: Colors.red,)),
                              SizedBox(width: 15,),
                              InkWell(
                                  onTap: (){
                                    _editDialog(data[index], data[index].tittle.toString(), data[index].description.toString());
                                  },
                                  child: Icon(Icons.edit)),

                            ],
                          ),
                          Text(data[index].tittle.toString()),
                        ],
                      ),
                    )
                  );
                }
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> _showMyDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Notes"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hint: Text("Enter title"),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: descController,
                  decoration: InputDecoration(
                    hint: Text("Enter description"),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
                onPressed: () {
                  final data = NotesModel(tittle: titleController.text,
                      description: descController.text);
                  final box=Boxes.getData();
                  box.add(data);
                 data.save();
                 titleController.clear();
                 descController.clear();
                },
                child: Text("Add")),
          ],
        );
      },
    );
  }
  Future<void> _editDialog(NotesModel notesModel, String title,String description) {
    titleController.text=title;
    descController.text=description;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Notes"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hint: Text("Enter title"),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: descController,
                  decoration: InputDecoration(
                    hint: Text("Enter description"),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
                onPressed: () {
                  notesModel.tittle=titleController.text.toString();
                  notesModel.description=descController.text.toString();
                  notesModel.save();

                 titleController.clear();
                 descController.clear();
                },
                child: Text("Edit")),
          ],
        );
      },
    );
  }
  void delete(NotesModel notesModel)async{
    await notesModel.delete();
  }
}
