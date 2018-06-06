//
//  AddTodoViewController.swift
//  Roster
//
//  Created by Morris on 2018/5/21.
//  Copyright © 2018年 Morris. All rights reserved.
//

import Foundation
import RealmSwift

class AddTodoViewController:UIViewController,UITextFieldDelegate {
    let realm = try! Realm()
    
    @IBAction func backButton(_ sender: UIButton) {
        performSegue(withIdentifier: "backToAgenda", sender: self)
    }
    @IBOutlet weak var continueOutlet: UIButton!
    @IBOutlet weak var addOutlet: UIButton!
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var subtitleTextfield: UITextField!
    
    @IBAction func saveButton(_ sender: UIButton) {
        addAgenda()
        guard titleTextfield.text != "" else { return }
        performSegue(withIdentifier: "backToAgenda", sender: self)
    }
    
    
    @IBAction func continueAdd(_ sender: UIButton) {
        addAgenda()
        titleTextfield.text = ""
        subtitleTextfield.text = ""
    }
    func addAgenda(){
        let date = Date()
        let newAgenda = TodoData()
        if titleTextfield.text != "" {
            newAgenda.title = titleTextfield.text!
            newAgenda.subtitle = subtitleTextfield.text!
            newAgenda.isChecked = false
            newAgenda.createDate = date
            do{
                try realm.write {
                    realm.add(newAgenda)
                }
            }catch{
                print("Error saving agenda \(error)")
            }
        }else{
            let alert = UIAlertController(style: .actionSheet, title:"Please add something in title")
            alert.addAction(title: "OK")
            present(alert,animated: true,completion: nil)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        continueOutlet.layer.cornerRadius = 22
        addOutlet.layer.cornerRadius = 22
        titleTextfield.becomeFirstResponder()
        self.hideKeyboardWhenTappedAround()
        titleTextfield.delegate = self
        subtitleTextfield.delegate = self
    }
//    func hideKeyboardWhenTappedAround() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//    
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextfield.resignFirstResponder()
        subtitleTextfield.resignFirstResponder()
        return true
    }
}
