import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  Observable<GoogleSignInAccount> currentUser;
  PublishSubject loading = PublishSubject();

  AuthService() {
    currentUser = Observable(_googleSignIn.onCurrentUserChanged);
  }

  Future<GoogleSignInAccount> signIn() async {
    loading.add(true);
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    loading.add(false);
    return googleUser;
  }

  void signOut() {
    _googleSignIn.signOut();
  }

  void disconnect() {
    _googleSignIn.disconnect();
  }
}

final AuthService authService = AuthService();
