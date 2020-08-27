import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart' as path;

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {

  File _image;

  final ImageLabeler labeler = FirebaseVision.instance.imageLabeler();

  List<ImageLabel> detectedLabels;
  List<String> labelsInString = [];

  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  bool _isUploading = false;
  bool _isCompletedUploading = false;

  @override
  void dispose() {
    labeler.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: _loadImage,
                child: _image != null ? Image.file(_image) : Image(
                  image: AssetImage("assets/placeholder.jpg"),
                ),
              ),
              Text("Click on image to upload image product"),

              SizedBox(height: 20,),

              detectedLabels!=null?Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 10,
                  children: labelsInString.map((label){
                   
                    return Chip(
                      label: Text(label),
                    );
                  }).toList(),
                ),
              ):Container(),

              SizedBox(height: 40,),

              if(_isUploading) ... [
                Text("Uploading Product...")
              ],

              if(_isCompletedUploading) ... [
                Text("Upload Completed")
              ],

              SizedBox(height: 40,),

              RaisedButton(
                onPressed: _uploadProduct,
                child: Text("Upload Product"),
              ),

            ],
          ),
        ),
      ),
    );
  }

  void _loadImage() async {
    var image = await ImagePicker.pickImage(source:ImageSource.gallery, imageQuality: 30);
    
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(image);
    
    
    List<ImageLabel> labels = await labeler.processImage(visionImage);
    
    labelsInString =[];
    for(var l in labels){
      labelsInString.add(l.text);
    }
   setState(() {
     detectedLabels = labels;
     _image = image;
   });

  }

  void _uploadProduct() async {

    if(_image != null){ // upload image

      String fileName = path.basename(_image.path);
      print(fileName);

      FirebaseUser user = await _auth.currentUser(); 
      String uid = user.uid;

      StorageUploadTask task = _storage.ref().child("products").child(uid).child(fileName).putFile(_image);

      task.events.listen((e) {
        if(e.type == StorageTaskEventType.progress){
          setState(() {
            _isUploading = true;
          });
        }
        if(e.type == StorageTaskEventType.success){

          setState(() {
            _isCompletedUploading = true;
            _isUploading = true;
          });

          e.snapshot.ref.getDownloadURL().then((url){

            _db.collection("products").add({
              "url": url,
              "date": DateTime.now(),
              "uploaded_by": uid,
              "tags": labelsInString
            });

            Navigator.of(context).pop();

          });

        }
      });

    }else{ // show the dialog

      showDialog(
        context: context,
        builder: (ctx){
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            title: Text("Error"),
            content: Text("Select image to upload..."),
            actions: <Widget>[
              RaisedButton(
                onPressed: (){
                  Navigator.of(ctx).pop();
                },
                child: Text("Ok"),
              ),
            ],
          );

        }
      );
    }

  }
}