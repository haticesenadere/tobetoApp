import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tobetoapp/blocs/auth_bloc/auth_bloc.dart';
import 'package:tobetoapp/blocs/auth_bloc/auth_event.dart';
import 'package:tobetoapp/blocs/auth_bloc/auth_state.dart';
import 'package:tobetoapp/screen/homepage_screen.dart';
import 'package:tobetoapp/screen/registerpage.dart';
import 'package:tobetoapp/theme/app_color.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isAuth = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void _submit() async {
    //context.read<AuthBloc>().add(Login(email: _email, password: _email));
    /*if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
    }*/
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      final User? user = userCredential.user;
      if (user != null) {
        // Kullanıcı giriş yaptı, yapılacak işlemler buraya yazılabilir
        // Örneğin, anasayfaya yönlendirme yapılabilir
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomepageScreen()),
        );
      }
    } catch (e) {
      print('Error: $e');
      // Hata durumunda kullanıcıya bilgi verilebilir
    }
  }

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User? user = authResult.user;
      return user;
    } catch (error) {
      print('Error: $error');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Brightness currentBrightness = MediaQuery.of(context).platformBrightness;
    String imageName = currentBrightness == Brightness.light
        ? 'assets/images/tobeto_logo.png'
        : 'assets/images/tobeto_logo_d.png';
    String backgroundLogin = currentBrightness == Brightness.light
        ? "assets/images/deneme7.jpg"
        : 'assets/images/deneme7.jpg';
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 16),
        backgroundColor: (AppColorDark.elevatedButtonColor),
        minimumSize: const Size(160, 40));
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          // Kullanıcı oturum açtıysa anasayfaya yönlendir
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomepageScreen()),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(backgroundLogin),
            fit: BoxFit.cover,
          )),
          child: Center(
            child: SizedBox(
              child: SizedBox(
                width: 400,
                height: 485,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 60,
                        child: Image.asset(imageName),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: TextField(
                            onChanged: (value) => _email = value,
                            controller: _usernameController,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    Theme.of(context).colorScheme.background,
                                labelText: "Kullanıcı adı",
                                hintStyle:
                                    const TextStyle(fontFamily: "Poppins"),
                                prefixIcon: const Icon(Icons.person),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)))),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: SizedBox(
                            height: 50,
                            child: TextField(
                              onChanged: (value) => _password = value,
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor:
                                      Theme.of(context).colorScheme.background,
                                  labelText: "Parola giriniz",
                                  hintStyle:
                                      const TextStyle(fontFamily: "Poppins"),
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                    child: Icon(_isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  ),
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15)))),
                            ),
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 11.33,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              )),
                          const SizedBox(width: 24)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: buttonStyle,
                            onPressed: () {
                              print('giriş  tıklandı');
                              print(_email);
                              print(_password);
                              _submit();
                              /* Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const HomepageScreen()));*/
                            },
                            child: const Text(
                              "GİRİŞ YAP",
                              style: TextStyle(
                                  color: Colors.white, fontFamily: "Poppins"),
                            ),
                          ),
                          ElevatedButton(
                            style: buttonStyle,
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => const RegisterPage()));
                            },
                            child: const Text(
                              "KAYIT OL",
                              style: TextStyle(
                                  color: Colors.white, fontFamily: "Poppins"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // Çizgi
                          Container(
                            height: 2.0,
                            width: 90.0,
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              end: Alignment.topLeft,
                              colors: [
                                Colors.black26,
                                Colors.white,
                              ],
                            )),
                          ),

                          /*    const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('Or continue with',
                              style: TextStyle(
                                color: Color(0xFFB5B5B5),
                                fontSize: 11.25,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ))),
                      // Çizgi

                      Container(
                        height: 2.0,
                        width: 90.0,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.black26,
                            Colors.white,
                          ],
                        )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () async {
                           
                            final User? user = await _signInWithGoogle();
                            if (user != null) {
                              // Kullanıcı başarıyla giriş yaptı, burada istediğiniz işlemleri yapabilirsiniz.
                              print(
                                  'Signed in with Google: ${user.displayName}');
                            } else {
                              // Giriş başarısız oldu
                              print('Failed to sign in with Google');
                            }
                          },
                          child: Container(
                              width: 50,
                              height: 50,
                              decoration: ShapeDecoration(
                                image: const DecorationImage(
                                    image:
                                        AssetImage("assets/images/gologo.png")),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 0.30, color: Colors.white),
                                  borderRadius: BorderRadius.circular(8.85),
                                ),
                              )),
                        ),
                        InkWell(
                          onTap: () {
                            print('Failed to sign in with facebook');
                          },
                          child: Container(
                              width: 50,
                              height: 50,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                image: const DecorationImage(
                                  image: AssetImage("assets/images/flogo.png"),
                                ),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 0.30, color: Colors.white),
                                  borderRadius: BorderRadius.circular(8.85),
                                ),
                              )),
                        ),
                        Container(
                            width: 50,
                            height: 50,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              image: const DecorationImage(
                                  image:
                                      AssetImage("assets/images/aplogo.png")),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 0.30, color: Colors.white),
                                borderRadius: BorderRadius.circular(8.85),
                              ),
                            ))
                      ] )*/
                        ],
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
