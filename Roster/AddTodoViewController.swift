//
//  AddTodoViewController.swift
//  Roster
//
//  Created by Morris on 2018/5/21.
//  Copyright © 2018年 Morris. All rights reserved.
//

import Foundation
import RealmSwift
//import Firebase
//
//protocol PassAgendaKeyProtocol {
//    func passAgendaKey(key:DatabaseReference)
//}

class AddTodoViewController:UIViewController,UITextFieldDelegate {
    let realm = try! Realm()
    
    
    //eachAgendaKey
    var eachAgendaKey = ""
//    var delegate:PassAgendaKeyProtocol?
    
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
//        delegate?.passAgendaKey(key: self.eachAgendaKey!)
        performSegue(withIdentifier: "backToAgenda", sender: self)
    }
    
    
    @IBAction func continueAdd(_ sender: UIButton) {
        addAgenda()
        titleTextfield.text = ""
        subtitleTextfield.text = ""
    }
    func addAgenda(){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM YYYY"
        formatter.dateStyle = .medium
        let stringDate = formatter.string(from: date)
        let newAgenda = TodoData()
//        var ref: DatabaseReference!
//        let uid = Auth.auth().currentUser?.uid
//        ref = Database.database().reference()
        
//        let reference: DatabaseReference! = Database.database().reference().child("agenda").child("\(uid!)").childByAutoId()
//        var agenda : [String : AnyObject] = [String : AnyObject]()
        
        if titleTextfield.text != "" {
            newAgenda.title = titleTextfield.text!
            newAgenda.subtitle = subtitleTextfield.text!
            newAgenda.isChecked = false
            newAgenda.createDate = date
//            agenda["title"] = "\(titleTextfield.text!)" as AnyObject
//            agenda["subtitle"] = "\(subtitleTextfield.text!)" as AnyObject
//            agenda["isChecked"] = false as AnyObject
//            agenda["createDate"] = stringDate as AnyObject
//            eachAgendaKey = "\(ref.child("agenda").child(uid!).child("<#T##pathString: String##String#>").key)"
//            ref.child("agenda").child(uid!).childByAutoId().setValue(agenda)
            newAgenda.agendaKey = eachAgendaKey
            do{
                try realm.write {
                    realm.add(newAgenda)
                }
            }catch{
                print("Error saving agenda \(error)")
            }
        }else{
            let alert = UIAlertController(style: .actionSheet, title:"Please fill title box.")
            alert.setTitle(font: UIFont(name: "Avenir Next", size: 17)!, color: .darkGray)
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

    func saveDataToFirebase(){
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextfield.resignFirstResponder()
        subtitleTextfield.resignFirstResponder()
        return true
    }
}
