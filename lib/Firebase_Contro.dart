import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AmisCall {

  uploadUserInfo(userMap,id){
    print("cccccccccccccccccccc");
    Firestore.instance.collection("usersData").document(id)
        .setData(userMap).catchError((e){print("eeeeeeeeeeeeeeeeeeeeeeee : "+e.toString());
    });
  }

  getUserInfo() async {
    return await Firestore.instance.collection("usersData")
        .snapshots();
  }

  deleteUser(doc) async {
    return await Firestore.instance
        .collection('usersData')
        .document(doc)
        .delete();
  }

   imageadding(filee) async {
    try {
      String imageTimeStamp = DateTime.now().millisecondsSinceEpoch.toString();
      String filePath = 'usersData/$imageTimeStamp';
      final StorageReference storageReference = FirebaseStorage( storageBucket:'gs://amiis-fb.appspot.com').ref().child(filePath);
      final StorageUploadTask uploadTask = storageReference.putFile(filee);
      StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
      String result = await storageTaskSnapshot.ref.getDownloadURL();
      return result;
    }catch(e) {
      print(e);
    }
  }


}