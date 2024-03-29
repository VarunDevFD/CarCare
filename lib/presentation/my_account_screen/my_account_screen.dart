import 'dart:io';
import 'package:car_maintanance/core/utils/image_constant.dart';
import 'package:car_maintanance/src/pages/my_account_from.dart';
import 'package:flutter/material.dart';
import 'package:car_maintanance/db/models/db_user_reg/user_db.dart';
import 'package:car_maintanance/db/db_functions/registor_from.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  // Image picker
  File? _image;

  // Database instance
  final UserRegisterApp userRegisterApp = UserRegisterApp();
  final UserFuel fuelApp = UserFuel();

  // Holds the currently displayed user data
  User? _user;
  User? _fuelD;

  // Load user data when the widget initializes
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // get image from ImagePicker
  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }

  // Method to load user data
  void _loadUserData() {
    final List<User> users = userRegisterApp.displayRegisterDetails();
    final List<User> fueluser = fuelApp.displayRegisterDetails();

    if (users.isNotEmpty) {
      setState(() {
        _user = users[0];
      });
    } else {
      setState(() {
        _user = null; // Set _user to null when no user data is available
      });
    }
    if (fueluser.isNotEmpty) {
      setState(() {
        _fuelD = fueluser[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // Background Image Rising on TextField click time
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            title: Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange, width: 2),
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 22,
                        color: Colors.orange,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  const Text(
                    'My Account',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
        ),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageConstant.imgMyAccount1),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // image Session
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.orange,
                        width: 2.5,
                      ),
                    ),
                    child: _image != null
                        ? ClipOval(
                            child: Image.file(
                              _image!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image:
                                    AssetImage(ImageConstant.imgRectangleAbout),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return SizedBox(
                            height: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                ListTile(
                                  leading: const Icon(Icons.camera_alt),
                                  title: const Text('Take a Photo'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _getImage(ImageSource.camera);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.photo_library),
                                  title: const Text('Choose from Gallery'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _getImage(ImageSource.gallery);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: const Icon(
                      Icons.add_a_photo_outlined,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // SideHead User
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'User',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  // Username
                  CustomInfoField(
                    icon: Icons.person,
                    labelText: _user?.userName ?? '',
                    trailingIcon: Icons.edit,
                    onTrailingIconPressed: () {
                      // Open dialog for editing username
                      openUsernameDialog(context);
                    },
                  ),
                  const SizedBox(height: 20),
                  // SideHead Vehicle
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Vehicle',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  // Car number
                  CustomInfoField(
                    icon: Icons.directions_car,
                    labelText: _user?.carName ?? '',
                    trailingIcon: Icons.edit,
                    onTrailingIconPressed: () {
                      // Open dialog for editing username
                      openCarDialog(context);
                    },
                  ),
                  const SizedBox(height: 20),
                  // Brand Name
                  CustomInfoField(
                    icon: Icons.business,
                    labelText: _user!.brandName ?? '',
                    trailingIcon: Icons.edit,
                    onTrailingIconPressed: () {
                      // Open dialog for editing username
                      openBrandDialog(context);
                    },
                  ),
                  const SizedBox(height: 20),
                  // Model Name
                  CustomInfoField(
                    icon: Icons.directions_car,
                    labelText: _user!.modelName ?? '',
                    trailingIcon: Icons.edit,
                    onTrailingIconPressed: () {
                      // Open dialog for editing username
                      openModelDialog(context);
                    },
                  ),
                  const SizedBox(height: 20),
                  // Fuel
                  CustomInfoField(
                    icon: Icons.local_gas_station,
                    // labelText: _user!.fuel ?? '',
                    labelText: _fuelD!.fuel ?? 'fuel',
                    trailingIcon: Icons.edit,
                    onTrailingIconPressed: () {
                      // Open dialog for editing fuel capacity
                      openDialogFuel(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to open dialog for editing username
  void openUsernameDialog(BuildContext context) {
    TextEditingController usernameController = TextEditingController(
        text: _user?.userName ??
            ''); // Controller for username text field with current username

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Username',
          style: TextStyle(
            color: Color.fromARGB(255, 253, 115, 73),
          ),
        ),
        content: TextField(
          keyboardType: TextInputType.name,
          controller: usernameController,
          style: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              // Update username when OK is pressed
              String newUsername = usernameController.text;
              // Add logic to update username in your database or wherever user data is stored
              setState(() {
                _user?.userName = newUsername;
              });
              Navigator.pop(context, 'OK');
            },
            child: const Text(
              'Ok',
              style: TextStyle(color: Color.fromARGB(236, 255, 0, 0)),
            ),
          ),
        ],
      ),
    );
  }

  // Method to open dialog for editing carName
  void openCarDialog(BuildContext context) {
    TextEditingController carNameController = TextEditingController(
        text: _user?.carName ??
            ''); // Controller for username text field with current username

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Username',
          style: TextStyle(
            color: Color.fromARGB(255, 253, 115, 73),
          ),
        ),
        content: TextField(
          controller: carNameController,
          style: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              // Update username when OK is pressed
              String newCarName = carNameController.text;
              // Add logic to update username in your database or wherever user data is stored
              setState(() {
                _user?.carName = newCarName;
              });
              Navigator.pop(context, 'OK');
            },
            child: const Text(
              'Ok',
              style: TextStyle(color: Color.fromARGB(236, 255, 0, 0)),
            ),
          ),
        ],
      ),
    );
  }

  // Method to open dialog for editing brandName
  void openBrandDialog(BuildContext context) {
    TextEditingController brandController = TextEditingController(
        text: _user?.brandName ??
            ''); // Controller for username text field with current username

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Username',
          style: TextStyle(
            color: Color.fromARGB(255, 253, 115, 73),
          ),
        ),
        content: TextField(
          controller: brandController,
          style: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              // Update username when OK is pressed
              String newBrandName = brandController.text;
              // Add logic to update username in your database or wherever user data is stored
              setState(() {
                _user?.brandName = newBrandName;
              });
              Navigator.pop(context, 'OK');
            },
            child: const Text(
              'Ok',
              style: TextStyle(color: Color.fromARGB(236, 255, 0, 0)),
            ),
          ),
        ],
      ),
    );
  }

  // Method to open dialog for editing username
  void openModelDialog(BuildContext context) {
    TextEditingController modelController = TextEditingController(
        text: _user?.modelName ??
            ''); // Controller for username text field with current username

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Username',
          style: TextStyle(
            color: Color.fromARGB(255, 253, 115, 73),
          ),
        ),
        content: TextField(
          controller: modelController,
          style: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              // Update username when OK is pressed
              String newModelName = modelController.text;
              // Add logic to update username in your database or wherever user data is stored
              setState(() {
                _user?.modelName = newModelName;
              });
              Navigator.pop(context, 'OK');
            },
            child: const Text(
              'Ok',
              style: TextStyle(color: Color.fromARGB(236, 255, 0, 0)),
            ),
          ),
        ],
      ),
    );
  }

  // Method to open dialog for editing fuel capacity
  void openDialogFuel(BuildContext context) {
    TextEditingController fuelController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Fuel Capacity',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        content: TextField(
          keyboardType: TextInputType.number,
          controller: fuelController,
          style: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () async {
              // Get the new fuel value entered by the user
              String newFuel = fuelController.text.trim();
              final UserFuel carFuel = UserFuel();

              if (newFuel.isNotEmpty) {
                setState(() {
                  _fuelD?.fuel = newFuel;
                  carFuel.userRegisterAddFuel(
                    fuel: newFuel,
                  );
                });
              }

              // Close the dialog
              Navigator.pop(context, 'OK');
            },
            child: const Text(
              'Ok',
              style: TextStyle(color: Color.fromARGB(236, 255, 0, 0)),
            ),
          ),
        ],
      ),
    );
  }
}
