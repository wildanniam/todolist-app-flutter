import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todolist/models/data_user.dart';
import 'package:todolist/services/database_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _imagePicker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: StreamBuilder(
      stream: DatabaseService().dataUser,
      builder: (context, AsyncSnapshot<DataUser> dataUserSnapshot) {
        if (dataUserSnapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );

        if (dataUserSnapshot.hasError)
          return Center(child: Text(dataUserSnapshot.error!.toString()));

        final dataUser = dataUserSnapshot.data as DataUser;

        return Container(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 150,
              color: Colors.blueAccent,
              child: Row(children: [
                GestureDetector(
                  onTap: () async {
                    XFile? xFile = await _imagePicker.pickImage(
                        source: ImageSource.camera, imageQuality: 30);
                    if (xFile != null) {
                      DatabaseService().uploadImageUrl(File(xFile.path));
                    }
                  },
                  child: CircleAvatar(
                    child: dataUser.userImageUrl == ''
                        ? Icon(
                            Icons.person,
                            size: 30,
                          )
                        : null,
                    backgroundImage: dataUser.userImageUrl != ''
                        ? NetworkImage(dataUser.userImageUrl)
                        : null,
                    minRadius: 48,
                    backgroundColor: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  dataUser.username,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                IconButton(
                    onPressed: () async {
                      String tempUsername = '';
                      bool? isEditUsername = await showDialog(
                          context: context,
                          builder: (builder) {
                            return AlertDialog(
                              title: Text('Edit Username'),
                              content: TextFormField(
                                initialValue: dataUser.username,
                                onChanged: (value) {
                                  tempUsername = value;
                                },
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: Text('Batal')),
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: Text('Simpan'))
                              ],
                            );
                          });
                      if (isEditUsername != null && isEditUsername) {
                        DatabaseService().updateUsername(tempUsername);
                      }
                    },
                    icon: Icon(Icons.edit))
              ]),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Data User',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              child: Text('Email'),
                              width: 100,
                            ),
                            Text(': '),
                            Text(dataUser.email)
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Container(
                              child: Text('Phone'),
                              width: 100,
                            ),
                            Text(': '),
                            Text(dataUser.phone)
                          ],
                        )
                      ],
                    )),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.logout), Text('Keluar')],
                  )),
            )
          ]),
        );
      },
    ));
  }
}
