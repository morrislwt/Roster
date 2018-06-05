//
//  CreateViewController.swift
//  Roster
//
//  Created by Morris on 2018/6/4.
//  Copyright © 2018年 Morris. All rights reserved.
//

import UIKit

class CreateViewController:UIViewController,UITextFieldDelegate{
    @IBAction func backButton(_ sender: UIButton) {
        performSegue(withIdentifier: "backLogin", sender: self)
    }
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var confirmPWTextfield: UITextField!
    @IBAction func createBtnPressed(_ sender: UIButton) {
    }
    
    @IBOutlet weak var createBtnOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        createBtnOutlet.layer.cornerRadius = 20
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextfield.resignFirstResponder()
        nameTextfield.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
        confirmPWTextfield.resignFirstResponder()
        return true
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}
