import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:bethany/data/api.dart';
import 'package:bethany/screens/about_page.dart';
import 'package:bethany/theme/provider.dart';
import 'package:bethany/widget/custom_checkbox_tile.dart';
import 'package:bethany/widget/custom_snackbar.dart';
import 'package:bethany/widget/platform_builder.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Future<dynamic>? data;
  int? selectedDepIndex;
  bool isDepSelected = false;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  double? glowMultiplier;
  double? blurMultiplier;
  @override
  void initState() {
    super.initState();
    data = fetchDepartments();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context);
    glowMultiplier = provider.glowMultiplier;
    blurMultiplier = provider.blurMultiplier;
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
              padding: EdgeInsets.symmetric(
                  horizontal: getResponsiveSize(context,
                      mobileSize: 10,
                      dektopSize: MediaQuery.of(context).size.width * 0.1)),
              children: [
                Container(
                  padding: EdgeInsets.all(getResponsiveSize(context,
                      mobileSize: 10, dektopSize: 20)),
                  margin: EdgeInsets.all(getResponsiveSize(context,
                      mobileSize: 0, dektopSize: 20)),
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

  Widget _buildGlowingInput(
      BuildContext context, TextEditingController controller,
      {int maxLines = 1, required String label, required IconData icon}) {
    String? validator(String? value) {
      if (value == null || value.isEmpty) {
        return '$label is required';
      }
      if (label == "Email") {
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return 'Please enter a valid email address';
        }
      }
      return null;
    }

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(
                Theme.of(context).brightness == Brightness.dark ? 0.8 : 1),
            blurRadius: 10.0 * blurMultiplier!,
            spreadRadius: 2.0 * glowMultiplier!,
            offset: const Offset(-2.0, 0),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: IconButton(
              onPressed: () {},
              icon: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              )),
          fillColor: Theme.of(context).colorScheme.secondaryContainer,
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        maxLines: maxLines,
        validator: validator,
      ),
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
            child: Container(
              width: getResponsiveValue(context,
                  mobileValue: null, desktopValue: 500.0),
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
    dynamic deps,
  ) {
    bool validateFields() {
      if (fullNameController.text.isEmpty) {
        showToast(context, 'Full Name cannot be empty.');
        return false;
      }

      final email = emailController.text;
      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
      if (email.isEmpty) {
        showToast(context, 'Email cannot be empty.');
        return false;
      } else if (!emailRegex.hasMatch(email)) {
        showToast(context, 'Please enter a valid email address.');
        return false;
      }

      if (messageController.text.isEmpty) {
        showToast(context, 'Message cannot be empty.');
        return false;
      }

      if (!isDepSelected) {
        showToast(context, 'Please select a department.');
        return false;
      }

      return true;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildGlowingInput(context, fullNameController,
            label: "Full Name", icon: HugeIcons.strokeRoundedUser),
        const SizedBox(height: 15),
        _buildGlowingInput(context, emailController,
            label: "Email", icon: HugeIcons.strokeRoundedMail01),
        const SizedBox(height: 15),
        _buildGlowingInput(context, messageController,
            label: "Message",
            icon: HugeIcons.strokeRoundedMessage02,
            maxLines: 2),
        const SizedBox(height: 15),
        ListTileWithCheckMark(
          leading: const Icon(HugeIcons.strokeRoundedBuilding01),
          color: Colors.black,
          tileColor: Theme.of(context).colorScheme.primaryFixed,
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
              color: Theme.of(context).colorScheme.primaryFixed.withOpacity(
                  Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.8),
              blurRadius: 10.0 * blurMultiplier!,
              spreadRadius: 4.0 * glowMultiplier!,
              offset: const Offset(-2.0, 0),
            ),
          ]),
          child: ElevatedButton(
            onPressed: () {
              if (validateFields()) {
                sendAdmissionMail(
                  senderEmail: emailController.text,
                  senderName: fullNameController.text,
                  senderMessage: messageController.text,
                  recipientEmail: deps[selectedDepIndex]['email'] ??
                      'school@bethanyinstitutions.edu.in',
                );
                showToast(context, 'Message sent successfully!');
              }
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              fixedSize: const Size(double.maxFinite, 50),
              backgroundColor: Theme.of(context).colorScheme.primaryFixed,
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

Future<void> sendAdmissionMail({
  required String senderEmail,
  required String senderName,
  required String senderMessage,
  required String recipientEmail,
}) async {
  final subject = "Admission Inquiry from $senderName";
  final body = """
Dear Admissions Team,

My name is $senderName. I am reaching out to inquire about the admission process.

$senderMessage

Looking forward to hearing from you soon.

Best regards,
$senderName
$senderEmail
""";

  final Email email = Email(
    body: body,
    subject: subject,
    recipients: [recipientEmail],
    isHTML: false,
  );

  try {
    await FlutterEmailSender.send(email);
  } catch (e) {
    throw 'Could not send email: $e';
  }
}
