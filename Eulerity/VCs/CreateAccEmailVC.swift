//
//  CreateAccEmailVC.swift
//  Eulerity
//
//  Created by Rahul Pawar on 2/5/22.
//

import UIKit

class CreateAccEmailVC: UIViewController, UITextFieldDelegate {
    
    let userDefault = UserDefaults.standard
   

    @IBOutlet weak var emailTF: UITextField!
    
 
    
    @IBOutlet weak var nextBtn: UIButton!
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
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func nextBtnPressed(_ sender: UIButton) {
        
        guard let email = emailTF.text else {return}
        
        if (email != ""){
            performSegue(withIdentifier: "goToPassword", sender: self)
            userDefault.set(email, forKey: "createAccEmail")
        }
        
    }
    
}
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
