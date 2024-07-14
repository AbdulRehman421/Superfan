import 'dart:convert';
import 'dart:io';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:superfan/pages/HomeScreen.dart';
import 'package:superfan/pages/LoginScreen.dart';
import 'package:superfan/services/Api.dart';
import 'package:superfan/utils/color.dart';
import 'package:superfan/utils/routes.dart';
import 'package:superfan/utils/styles.dart';
import 'package:superfan/widgets/customTextField.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Add this import

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  XFile? _imageFile;
  final _formKey = GlobalKey<FormState>();
  late String _firstName = '';
  late String _lastName = '';
  late String _email = '';
  late String _bio = '';
  late String _phone = '';
  String _country = '';
  String _profileImageUrl = '';
  bool isFormEdited = false;
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController bio = TextEditingController();
  bool isLoading = true;
  final maskFormatter = MaskTextInputFormatter(
    mask: '###-###-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> signOut(BuildContext context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await googleSignIn.signOut();
      await _auth.signOut();
      print("User signed out");

      // Navigate to the login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  Future<void> _fetchProfileData() async {
    try {
      final response = await ApiClient().get(
        '${AppConstants.baseUrl}/api/v1/profile',
        headers: {'Authorization': 'Bearer ${await AppConstants.jwttoken}'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _firstName = data['first_name'] ?? '';
          _lastName = data['last_name'] ?? '';
          _email = data['email'] ?? '';
          _bio = data['bio'] ?? '';
          _phone = data['phone'] ?? '';
          _country = data['country'] ?? 'IN';
          _profileImageUrl = data['profile_image_url'] ?? '';

          phone.text = _phone;
          bio.text = _bio;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load profile data');
      }
    } catch (e) {
      print('Error fetching profile data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    try {
      final jwtToken = await AppConstants.jwttoken;
      var request = http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}/api/v1/profile/fu'));
      request.headers['Authorization'] = 'Bearer $jwtToken';
      request.fields['first_name'] = _firstName;
      request.fields['last_name'] = _lastName;
      request.fields['bio'] = _bio;
      request.fields['phone'] = _phone;
      request.fields['country'] = _country;

      if (_imageFile != null) {
        // Log the image file details
        print('Image path: ${_imageFile!.path}');
        print('Image mime type: ${_imageFile!.mimeType}');

        // Read the bytes from _imageFile
        List<int> imageBytes = await _imageFile!.readAsBytes();
        // Create a MultipartFile using the read bytes
        var file = http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: _imageFile!.path.split('/').last,
          contentType: MediaType('image', 'jpeg'), // You can change 'jpeg' to the correct type if needed
        );
        request.files.add(file);
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final data = jsonDecode(responseData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
        Navigator.pushNamed(context, Routes.home);
      } else {
        throw Exception('Failed to update profile: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
      // Handle error: show dialog, snackbar, or retry mechanism
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          isFormEdited = true;
          _imageFile = pickedFile;
          _profileImageUrl = _imageFile!.path;
        });
      } else {
        print('No image picked.');
      }
    } catch (e) {
      print('Error picking image: $e');
      // Handle error: show dialog or snackbar to inform the user
    }
  }
  @override
  Widget build(BuildContext context) {
    print('url $_profileImageUrl');
    print('country $_country');
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: isLoading ? Colors.white : primaryClr,
          actions: [
            IconButton(
              onPressed: () async {
                await signOut(context);
              },
              icon: Icon(CupertinoIcons.power, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: isLoading ? Colors.white : primaryClr,
        body: isLoading
            ? Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/loader.gif',height: 200,alignment: Alignment.center,),
            Text('loading...',style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color:primaryClr,
            ),)
          ],
        ))
            : SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          _imageFile != null
                              ? CircleAvatar(
                            backgroundImage: FileImage(File(_imageFile!.path)),
                            radius: 70,
                          )
                              : _profileImageUrl.isNotEmpty
                              ? CircleAvatar(
                            backgroundImage: NetworkImage(_profileImageUrl),
                            radius: 70,
                          )
                              : Image.asset(
                            'assets/profile6.png',
                            width: 140,
                            height: 140,
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Choose Image Source'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            _pickImage(ImageSource.camera);
                                          },
                                          child: Text('Camera'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            _pickImage(ImageSource.gallery);
                                          },
                                          child: Text('Gallery'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Image.asset(
                                'assets/editIcon.png',
                                width: 31,
                                height: 31,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 9),
                    Center(
                      child: Text(
                        '$_firstName $_lastName',
                        style: Styles.poppinsTitle(),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Center(
                      child: Text(
                        'UI/UX', // Replace with actual profession or title
                        style: Styles.poppinsSubTxtStyle(
                          color: greyTxtClr,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 46.0),
                    Text('Your Email', style: Styles.poppinsSubTxtStyle()),
                    SizedBox(height: 20.0),
                    customTextField(
                      containerColor: greyTxtClr.withOpacity(0.5),
                      enable: false,
                      controller: email,
                      onChanged: (value) {
                        setState(() {
                          _email = value;
                          isFormEdited = true;
                        });
                      },
                      borderColor: borderClr,
                      hintText: _email,
                      prefixIcon: Icon(Icons.email_outlined, color: Colors.black),
                    ),
                    SizedBox(height: 20.0),
                    Text('Phone Number', style: Styles.poppinsSubTxtStyle()),
                    SizedBox(height: 20.0),
                    customTextField(
                      keyboard: TextInputType.phone,
                      enable: true,
                      controller: phone,
                      onChanged: (value) {
                        setState(() {
                          _phone = value;
                          isFormEdited = true;
                        });
                      },
                      borderColor: borderClr,
                      hintText: _phone,
                      prefixIcon: Icon(Icons.phone_outlined, color: Colors.black),
                      inputFormatters: [
                        maskFormatter
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Text('Country', style: Styles.poppinsSubTxtStyle()),
                    SizedBox(height: 20.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderClr),
                      ),
                      child: CountryListPick(
                        appBar: AppBar(
                          title: Text('Pick a Country'),
                        ),
                        theme: CountryTheme(
                          isShowFlag: true,
                          isShowTitle: true,
                          isShowCode: true,
                          isDownIcon: true,
                          showEnglishName: true,
                        ),
                        initialSelection: _country,
                        onChanged: (CountryCode? code) {
                          if (code != null) {
                            setState(() {
                              _country = code.code ?? '';
                              isFormEdited = true;
                            });
                          }
                        },
                        useUiOverlay: true,
                        useSafeArea: false,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text('Bio', style: Styles.poppinsSubTxtStyle()),
                    SizedBox(height: 12.0),
                    Container(
                      padding: EdgeInsets.only(top: 12.0, left: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderClr),
                      ),
                      child: TextFormField(
                        controller: bio,
                        decoration: InputDecoration(
                          hintText: _bio,
                          hintStyle: Styles.poppinsSubTxtStyle(
                            fontWeight: FontWeight.w500,
                            color: greyTxtClr,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.zero,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 5.0,
                          ),
                        ),
                        maxLines: 4,
                        onChanged: (value) {
                          setState(() {
                            _bio = value;
                            isFormEdited = true;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 28),
                    Container(
                      decoration: BoxDecoration(
                        color: orangeClr,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: orangeClr),
                      ),
                      child: Center(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: orangeClr,
                            padding: EdgeInsets.symmetric(
                              horizontal: 80,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            side: BorderSide(color: orangeClr, width: 1.0),
                          ),
                          onPressed: isFormEdited
                              ? () {
                            if (_formKey.currentState!.validate()) {
                              _updateProfile();
                            }
                          }
                              : null,
                          child: Text(
                            'Update Profile',
                            style: Styles.poppinsTitle(
                              fontSize: 16,
                              height: 19.2 / 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
