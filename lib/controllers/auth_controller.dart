import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moo/UI/pages/login_page.dart';
import 'package:moo/UI/widgets/navigation_bar.dart';
import 'package:moo/models/user.dart' as userModel;
import 'package:moo/services/firebase_service_Farm.dart';

class AuthenticationController extends GetxController {
  static AuthenticationController authController = Get.find();


  late Rx<User?> firebaseCurrentUser;

  late Rx<File?> pickedFile;
  File? get profileImage => pickedFile.value;
  XFile? imageFile;

  pickImageFileFromGallery() async {
    imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      Get.snackbar(
          'Profile Image', 'you have successfully picked your profile image');
    }
    pickedFile = Rx<File?>(File(imageFile!.path));
  }

  pickImageFileFromCamera() async {
    imageFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if (imageFile != null) {
      Get.snackbar(
          'Profile Image', 'you have successfully picked your profile image');
    }
    pickedFile = Rx<File?>(File(imageFile!.path));
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    Reference referenceStorage = FirebaseStorage.instance
        .ref()
        .child('imageProfile')
        .child(FirebaseAuth.instance.currentUser!.uid);
    UploadTask task = referenceStorage.putFile(imageFile);
    TaskSnapshot snapshot = await task;

    String downloadUrlImage = await snapshot.ref.getDownloadURL();
    return downloadUrlImage;
  }

  void crearFinca(String userId, String farmName, int farmExpansion) async {
    await addFarm(farmName, farmExpansion, userId);
  }

  createNewUserAccountAndFarm(
      String name,
      String lastName,
      String? gender,
      DateTime? birthDate,
      String phone,
      String email,
      String password,
      File? img,
      String farmName,
      int farmExpansion) async {
    try {
      //auth user with email and password
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final currentUser = FirebaseAuth.instance.currentUser!;

      String userId = currentUser.uid;

      crearFinca(userId, farmName, farmExpansion);

      //upload image to storage
      String imageUrl = await uploadImageToStorage(img!);
      String? formattedDate;
      birthDate == null
          ? formattedDate = null
          : formattedDate =
              "${birthDate.year}-${birthDate.month}-${birthDate.day}";
      //Save user info to firestore
      userModel.User userInstance = userModel.User(
          name: name,
          lastName: lastName,
          gender: gender,
          birthDate: formattedDate,
          phone: phone,
          email: email,
          idJefe: userId,
          img: imageUrl,
          state: true);

      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(userInstance.toJson());

      Get.snackbar('Account Cration Succesfully', 'Congratulations');
      FirebaseAuth.instance.signOut();
      Get.to(const LoginPage());
    } catch (e) {
      Get.snackbar('Account Cration Unsuccesfull', 'Error ocurred $e');
    }
  }

  loginUser(String emailUser, String passwordUser) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailUser, password: passwordUser);
      Get.snackbar('Logged-in successful', "you're logged-in successfully");
      Get.to(() => const NavBar());
    } catch (e) {
      Get.snackbar('Login Unsuccessful', 'Error ocurred: $e');
    }
  }

  checkIfUserIsLoggedIn(User? currentUser) async {
    if (currentUser == null) {
      Get.to(() => const LoginPage());
    } else {
      Get.to(() => const NavBar());
    }
  }

  @override
  void onReady(){

    super.onReady();


    firebaseCurrentUser = Rx<User?>(FirebaseAuth.instance.currentUser);
    firebaseCurrentUser.bindStream(FirebaseAuth.instance.authStateChanges());

    ever(firebaseCurrentUser, checkIfUserIsLoggedIn);
  }
}
