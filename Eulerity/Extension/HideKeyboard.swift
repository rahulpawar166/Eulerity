//
//  HideKeyboard.swift
//  Eulerity
//
//  Created by Rahul Pawar on 2/6/22.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
}
