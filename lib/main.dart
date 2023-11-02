import 'package:flutter/material.dart';
import 'package:flutter_bear_animation_login/core/theme/app_color.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
          backgroundColor: Color(0xFFD6E2EA),
          body: SingleChildScrollView(
            child: HomeScreen(),
          )),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // email
  FocusNode emailFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();

  // password
  FocusNode passwordFocusNode = FocusNode();
  TextEditingController passwordController = TextEditingController();

  // rive animation input
  StateMachineController? controller;

  SMIInput<bool>? isChecking;
  SMIInput<double>? numLook;
  SMIInput<bool>? isHandsUp;

  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;

  @override
  void initState() {
    emailFocusNode.addListener(emailFocus);
    passwordFocusNode.addListener(passwordFocus);
  }

  @override
  void dispose() {
    emailFocusNode.removeListener(emailFocus);
    passwordFocusNode.removeListener(passwordFocus);
  }

  void emailFocus() {
    isChecking?.change(emailFocusNode.hasFocus);
  }

  void passwordFocus() {
    isHandsUp?.change(passwordFocusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          SizedBox(
              height: 250,
              width: 250,
              child: RiveAnimation.asset(
                "assets/login-teddy.riv",
                fit: BoxFit.fitHeight,
                stateMachines: const ["Login Machine"],
                onInit: (artboard) {
                  controller = StateMachineController.fromArtboard(artboard,
                      "Login Machine"); // Login Machine from rive editor when open this asset rive
                  if (controller == null) return;

                  artboard.addController(controller!);
                  isChecking = controller?.findInput("isChecking");
                  numLook = controller?.findInput("numLook");
                  isHandsUp = controller?.findInput("isHandsUp");
                  trigSuccess = controller?.findInput("trigSuccess");
                  trigFail = controller?.findInput("trigFail");
                },
              )),
          Container(
            decoration: BoxDecoration(
                color: AppColor.white, borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.all(16),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  focusNode: emailFocusNode,
                  controller: emailController,
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: "Email"),
                  style: Theme.of(context).textTheme.bodyMedium,
                  onChanged: (value) {
                    numLook?.change(value.length.toDouble());
                  },
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  focusNode: passwordFocusNode,
                  controller: passwordController,
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: "Password"),
                  obscureText: true,
                  style: Theme.of(context).textTheme.bodyMedium,
                  onChanged: (value) {},
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 64,
                child: ElevatedButton(
                    onPressed: () async {
                      emailFocusNode.unfocus();
                      passwordFocusNode.unfocus();

                      final email = emailController.text;
                      final password = passwordController.text;

                      showLoadingDialog(context);

                      await Future.delayed(const Duration(milliseconds: 2000));

                      if (mounted) Navigator.pop(context);

                      if (email == "mail@mail.com" && password == "1234") {
                        trigSuccess?.change(true);
                      } else {
                        trigFail?.change(true);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16))),
                    child: const Text("Login")),
              )
            ]),
          )
        ],
      ),
    );
  }
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      );
    },
  );
}
