//
//  CreateAccPasswordVC.swift
//  Eulerity
//
//  Created by Rahul Pawar on 2/5/22.
//

import UIKit
import Firebase
import FirebaseAuth
import NVActivityIndicatorView

class CreateAccPasswordVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var paswordTF: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    
    let userDefault = UserDefaults.standard
    let loading = NVActivityIndicatorView(frame: .zero, type: .ballTrianglePath, color: UIColor(named: "darkBlueC"), padding: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        paswordTF.setLeftPaddingPoints(10.0)
        paswordTF.becomeFirstResponder()
        paswordTF.layer.cornerRadius = 10.0
        paswordTF.layer.borderWidth = 1.0
        paswordTF.layer.borderColor = UIColor.black.cgColor
        
        paswordTF.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )

        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextBtnPressed(_ sender: UIButton) {
        startAnimation()
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        
        let email = userDefault.string(forKey: "createAccEmail")
        guard let password = paswordTF.text else {return}
        if passwordPred.evaluate(with: password) == true{
        Auth.auth().createUser(withEmail: email!, password: password) { res, error in
            if error != nil{
                self.loading.stopAnimating()
                let alert = UIAlertController(title: "Error", message: "Your account maybe already exist or you have entered incorrect email address.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction.init(title: "Try again!", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.loading.stopAnimating()
                let alert = UIAlertController(title: "Welcome to Eulerity", message: "Your account is successfully created", preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "Okay", style: .default, handler: { act in
                    print("User created successfully")
                    
                    self.performSegue(withIdentifier: "goToGallaryVC", sender: self)
                    self.userDefault.set(true, forKey:"userSignedIn")
                    self.userDefault.synchronize()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        }
        else{
            let alert = UIAlertController(title: "Incorrect credentials", message: "Make sure you have provided correct username, and password satisfying all the conditions. Please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Try Again", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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

