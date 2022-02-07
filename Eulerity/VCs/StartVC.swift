//
//  StartVC.swift
//  Eulerity
//
//  Created by Rahul Pawar on 2/5/22.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices
import CryptoKit


class StartVC: UIViewController {
    
    let userDefault = UserDefaults.standard
    
    // Unhashed nonce.
    fileprivate var currentNonce: String?

    override func viewDidLoad() {
        
        hideKeyboardWhenTappedAround()
        
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        if self.userDefault.bool(forKey: "userSignedIn") {
            self.performSegue(withIdentifier: "goToGallaryVC", sender: self)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func googleSignInPressed(_ sender: UIButton) {
        let signInConfig = GIDConfiguration.init(clientID: "953612364837-cobu7gtsvbj5eq9hi2tumsuh57qduelj.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            if error != nil{
                let alert = UIAlertController(title: "Error", message: "Error occured while signing in with Google, try again or use different sign in method.", preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "Okay", style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            } else{
                print("Success in google signin")
                self.userDefault.set(true, forKey:"userSignedIn")
                self.userDefault.synchronize()
                self.performSegue(withIdentifier: "goToGallaryVC", sender: self)
            }
        }
    }
    
    @IBAction func skipBtnPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Skip", message: "You want to skip login?", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Yes", style: .default, handler: { action in
            self.performSegue(withIdentifier: "goToGallaryVC", sender: self)
        }))
        alert.addAction(UIAlertAction.init(title: "No", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func appleSignInPressed(_ sender: UIButton) {
       startSignInWithAppleFlow()
    }
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError(
              "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }

        
    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
     // authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }
}

@available(iOS 13.0, *)
extension StartVC: ASAuthorizationControllerDelegate {

  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let nonce = currentNonce else {
        fatalError("Invalid state: A login callback was received, but no login request was sent.")
      }
      guard let appleIDToken = appleIDCredential.identityToken else {
        print("Unable to fetch identity token")
        return
      }
      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
        return
      }
      // Initialize a Firebase credential.
      let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                idToken: idTokenString,
                                                rawNonce: nonce)
      // Sign in with Firebase.
      Auth.auth().signIn(with: credential) { (authResult, error) in
          if (error != nil) {
          // Error. If error.code == .MissingOrInvalidNonce, make sure
          // you're sending the SHA256-hashed nonce as a hex string with
          // your request to Apple.
              print(error?.localizedDescription)
          return
        }
        // User is signed in to Firebase with Apple.
        // ...
          print("Apple sign in successful")
          self.performSegue(withIdentifier: "goToGallaryVC", sender: self)
          self.userDefault.set(true, forKey:"userSignedIn")
          self.userDefault.synchronize()
      }
    }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    print("Sign in with Apple errored: \(error)")
      
  }

}
