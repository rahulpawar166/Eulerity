//
//  SignInPasswordVC.swift
//  Eulerity
//
//  Created by Rahul Pawar on 2/5/22.
//

import UIKit
import Firebase
import FirebaseAuth
import NVActivityIndicatorView


class SignInPasswordVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    
    let userDefault = UserDefaults.standard
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .ballTrianglePath, color: UIColor(named: "darkBlueC"), padding: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        passwordTF.setLeftPaddingPoints(10.0)
        passwordTF.becomeFirstResponder()
        passwordTF.layer.cornerRadius = 10.0
        passwordTF.layer.borderWidth = 1.0
        passwordTF.layer.borderColor = UIColor.black.cgColor
        
        passwordTF.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        // Do any additional setup after loading the view.
    }
    

    @IBAction func nextBtnPressed(_ sender: UIButton) {
        startAnimation()
        let email = userDefault.string(forKey: "signInEmail")
        guard let password = passwordTF.text else {return}
        
        Auth.auth().signIn(withEmail: email!, password: password) { res, err in
            if (err != nil){
                self.loading.stopAnimating()
                let alert = UIAlertController(title: "Invalid credentials", message: "Please check your credential and try once again", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction.init(title: "Okay", style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            } else{
                self.loading.stopAnimating()
                self.userDefault.set(true, forKey:"userSignedIn")
                self.userDefault.synchronize()
                self.performSegue(withIdentifier: "goToGallaryVC", sender: self)
            }
        }
    }
    
    private func startAnimation(){
        
        loading.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 50),
            loading.heightAnchor.constraint(equalToConstant: 50),
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        loading.startAnimating()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            self.loading.stopAnimating()
//        }
    }
    
}
