import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:school_app/data/api.dart';
import 'package:school_app/screens/about_page.dart';
import 'package:school_app/widget/custom_checkbox_tile.dart';
import 'package:school_app/widget/custom_snackbar.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Future<dynamic>? data;
  int? selectedDepIndex;
  bool isDepSelected = false;
  @override
  void initState() {
    super.initState();
    data = fetchDepartments();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController fullNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController messageController = TextEditingController();

    return FutureBuilder<dynamic>(
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final depData = snapshot.data;
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.surfaceContainer),
                  child: Column(
                    children: [
                      glowingLogo(context),
                      const SizedBox(height: 20),
                      _buildForm(context, fullNameController, emailController,
                          messageController, depData),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
      future: data,
    );
  }

  void onDepChange(int index) {
    setState(() {
      selectedDepIndex = index;
      isDepSelected = true;
    });
  }

  void showDepartmentSelectionDialog(dynamic data) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Dialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pick Department',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final itemData = data[index];
                        var isSelected = index == selectedDepIndex;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 7),
                          child: ListTileWithCheckMark(
                            title: itemData['name'],
                            active: isSelected,
                            subtitle: itemData['location'],
                            icon: HugeIcons.strokeRoundedBuilding01,
                            color: Theme.of(context).colorScheme.primary,
                            onTap: () {
                              setModalState(() {
                                onDepChange(index);
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainer,
                            ),
                            child: Text('Cancel',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 14,
                                    fontFamily: "LexendDeca",
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              backgroundColor:
                                  Theme.of(context).colorScheme.primaryFixed,
                            ),
                            child: const Text('Confirm',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "LexendDeca",
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildForm(
      BuildContext context,
      TextEditingController fullNameController,
      TextEditingController emailController,
      TextEditingController messageController,
      dynamic deps) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: fullNameController,
          decoration: InputDecoration(
            suffixIcon: IconButton(
                onPressed: () {},
                icon: Icon(
                  HugeIcons.strokeRoundedUser,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                )),
            fillColor: Theme.of(context).colorScheme.secondaryContainer,
            labelText: 'Full Name',
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            suffixIcon: IconButton(
                onPressed: () {},
                icon: Icon(
                  HugeIcons.strokeRoundedMail01,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                )),
            fillColor: Theme.of(context).colorScheme.secondaryContainer,
            labelText: 'Email',
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 15),
        TextField(
          controller: messageController,
          decoration: InputDecoration(
            suffixIcon: IconButton(
                onPressed: () {},
                icon: Icon(
                  HugeIcons.strokeRoundedMessage01,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                )),
            fillColor: Theme.of(context).colorScheme.secondaryContainer,
            labelText: 'Message',
            border: const OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 15),
        ListTileWithCheckMark(
          leading: const Icon(HugeIcons.strokeRoundedBuilding01),
          color: Colors.black,
          active: isDepSelected,
          title: isDepSelected
              ? deps[selectedDepIndex]['name']
              : "Choose Department",
          subtitle: isDepSelected
              ? deps[selectedDepIndex]['location']
              : "Choose which department to send gmail to",
          onTap: () {
            showDepartmentSelectionDialog(deps);
          },
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(
                  Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.7),
              blurRadius: 10.0,
              spreadRadius: 2.0,
              offset: const Offset(-2.0, 0),
            ),
          ]),
          child: ElevatedButton(
            onPressed: () {
              final fullName = fullNameController.text;
              final email = emailController.text;
              final message = messageController.text;

              if (fullName.isEmpty || email.isEmpty || message.isEmpty) {
                showToast(context, 'Please fill out all fields.');
              } else if (!isDepSelected) {
                showToast(
                    context, "Please select a department before proceeding");
              } else {
                showToast(context, 'Message sent successfully!');
              }
            },
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(double.maxFinite, 50),
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
            child: const Text(
              'Submit',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
