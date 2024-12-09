import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:school_app/data/api.dart';
import 'package:school_app/widget/custom_checkbox_tile.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Future<dynamic>? data;
  int? selectedDepIndex;
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
                GridView.builder(
                    shrinkWrap: true,
                    itemCount: depData.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 70,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                    itemBuilder: (context, index) {
                      final itemData = depData[index];
                      return InkWell(
                        onTap: () {
                          showDepartmentSelectionDialog(context, snapshot.data);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainer),
                          child: Text(itemData['name']),
                        ),
                      );
                    })
                // Container(
                //   height: 300,
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //       color: Theme.of(context).colorScheme.surfaceContainer),
                //       child: ,
                // ),
                // _buildForm(
                //     context, fullNameController, emailController, messageController),
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
    });
  }

  void showDepartmentSelectionDialog(BuildContext context, dynamic data) {
    showDialog(
      context: context,
      builder: (context) {
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
                      final isSelected = index == (selectedDepIndex ?? 0);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 7),
                        child: ListTileWithCheckMark(
                          title: itemData['name'],
                          active: isSelected,
                          subtitle: itemData['location'],
                          icon: HugeIcons.strokeRoundedBuilding01,
                          color: Theme.of(context).colorScheme.primary,
                          onTap: () => onDepChange(index),
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
                            backgroundColor:
                                Theme.of(context).colorScheme.surfaceContainer,
                          ),
                          child: Text('Cancel',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
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
      },
    );
  }

  Container _buildForm(
      BuildContext context,
      TextEditingController fullNameController,
      TextEditingController emailController,
      TextEditingController messageController) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: fullNameController,
            decoration: InputDecoration(
              fillColor: Theme.of(context).colorScheme.secondaryContainer,
              labelText: 'Full Name',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
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
              fillColor: Theme.of(context).colorScheme.secondaryContainer,
              labelText: 'Message',
              border: const OutlineInputBorder(),
            ),
            maxLines: 5,
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                final fullName = fullNameController.text;
                final email = emailController.text;
                final message = messageController.text;

                if (fullName.isEmpty || email.isEmpty || message.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill out all fields.'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Message sent successfully!'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
