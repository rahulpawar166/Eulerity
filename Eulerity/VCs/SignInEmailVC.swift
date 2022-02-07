//
//  SignInEmailVC.swift
//  Eulerity
//
//  Created by Rahul Pawar on 2/5/22.
//

import UIKit

class SignInEmailVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    
    
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        emailTF.setLeftPaddingPoints(10.0)
        emailTF.becomeFirstResponder()
        emailTF.layer.cornerRadius = 10.0
        emailTF.layer.borderWidth = 1.0
        emailTF.layer.borderColor = UIColor.black.cgColor
        
        emailTF.attributedPlaceholder = NSAttributedString(
            string: "you@lorem.com",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func nextBtnPressed(_ sender: UIButton) {
        guard let email = emailTF.text else {return}
        
        if (email != ""){
            performSegue(withIdentifier: "goToSignInPassword", sender: self)
            userDefault.set(email, forKey: "signInEmail")
        }
        
    }
    
    
    
    
    
    
    
}

