//
//  ForgotPasswordVC.swift
//  Eulerity
//
//  Created by Rahul Pawar on 2/6/22.
//

import UIKit
import FirebaseAuth

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        Auth.auth().sendPasswordReset(withEmail: email) { err in
            if err != nil {
                let alert = UIAlertController(title: "Error", message: err?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "Try again", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else{
                let alert = UIAlertController(title: "Link sent", message: "Password reset link successfully send to \(email).", preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "Great", style: .default, handler: { action in
                    let destVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInEmailVC") as! SignInEmailVC
                    self.navigationController?.pushViewController(destVC, animated: true)
                }))
            }
        }
        
        
    }
    
}
