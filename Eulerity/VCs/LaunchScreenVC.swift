//
//  LaunchScreenVC.swift
//  Eulerity
//
//  Created by Rahul Pawar on 2/5/22.
//

import UIKit

class LaunchScreenVC: UIViewController {
    
    let userDefault = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.userDefault.bool(forKey: "userSignedIn") {
                self.performSegue(withIdentifier: "goToGallaryVC", sender: self)
            }else{
                self.performSegue(withIdentifier: "goToStartVC", sender: self)
            }
           
       }
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
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

}
