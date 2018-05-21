//
//  AddTodoViewController.swift
//  Roster
//
//  Created by Morris on 2018/5/21.
//  Copyright © 2018年 Morris. All rights reserved.
//

import Foundation
import RealmSwift

class AddTodoViewController:UIViewController {
    let realm = try! Realm()
    
    @IBOutlet weak var continueOutlet: UIButton!
    @IBOutlet weak var addOutlet: UIButton!
    @IBOutlet weak var titleTextfield: UITextField!
    
    @IBOutlet weak var subtitleTextfield: UITextField!
    
    @IBAction func addButton(_ sender: UIButton) {
        performSegue(withIdentifier: "backToAgenda", sender: self)
        addAgenda()
    }
    @IBAction func continueAdd(_ sender: UIButton) {
        addAgenda()
        titleTextfield.text = ""
        subtitleTextfield.text = ""
    }
    func addAgenda(){
        let date = Date()
        let newAgenda = TodoData()
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
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addOutlet.layer.cornerRadius = 10
        continueOutlet.layer.cornerRadius = 10
        
    }
}
