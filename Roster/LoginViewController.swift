//
//  LoginViewController.swift
//  Roster
//
//  Created by Morris on 2018/5/30.
//  Copyright © 2018年 Morris. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController:UIViewController,UITextFieldDelegate{
    @IBAction func backLogin(_ segue:UIStoryboardSegue){
        
    }
    
    @IBOutlet weak var emailTextfiled: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var loginWidth: NSLayoutConstraint!
    @IBOutlet weak var createWidth: NSLayoutConstraint!
    @IBOutlet weak var createOutlet: UIButton!
    @IBOutlet weak var loginOutlet: UIButton!
    @IBAction func loginBtn(_ sender: UIButton) {
        guard emailTextfiled.text != "" && passwordTextfield.text != "" else { return }
        Auth.auth().signIn(withEmail: emailTextfiled.text!, password: passwordTextfield.text!) { (user, error) in
            if error != nil {
                print(error!)
            }else{
                self.performSegue(withIdentifier: "loginOK", sender: self)
            }
        }
    }
    @IBAction func createBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "goCreate", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loginOutlet.layer.cornerRadius = 20
        createOutlet.layer.cornerRadius = 20
        self.hideKeyboardWhenTappedAround()
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextfiled.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1) {
            self.loginOutlet.backgroundColor = .white
            self.loginWidth.constant = self.view.frame.width * 0.8
            self.createOutlet.backgroundColor = .white
            self.createWidth.constant = self.view.frame.width * 0.8
            self.view.layoutIfNeeded()
        }

    }
    
}
