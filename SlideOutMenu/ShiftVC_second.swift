//
//  ShiftVC2.swift
//  Roster
//
//  Created by Morris on 2018/5/11.
//  Copyright © 2018年 Morris. All rights reserved.
//

import Foundation
import RealmSwift



class ShiftVC_second:UIViewController{
    
    
    let realm = try! Realm()
    
    var textFieldSenderIndex:Int = 0
    var timeStart:Date?
    var timeEnd:Date?
    
    @IBOutlet var additionalView: UIView!
    
    @IBAction func doneBtnPressed(_ sender: UIButton) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateFormat = "HH:mm"
        if textFieldSenderIndex == 0 {
            timeStart = datePicker.date
            shiftStartTextfield.text = formatter.string(from: datePicker.date)
        }else if textFieldSenderIndex == 1 {
            timeEnd = datePicker.date
            shiftEndTextfield.text = formatter.string(from: datePicker.date)
        }
        
        displayPickerView(false)
        
        
    }
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var continueBtnOutlet: UIButton!
    @IBOutlet weak var saveBtnOutlet: UIButton!
    @IBOutlet weak var shiftNameTextfield: UITextField!
    
    @IBOutlet weak var shiftStartTextfield: UITextField!
    
    @IBOutlet weak var shiftEndTextfield: UITextField!
    
    @IBOutlet weak var backgroundFrame: UIView!
    
    @IBAction func saveButton(_ sender: UIButton) {
        let newShiftTemplate = shiftTemplateData()
        newShiftTemplate.shiftTemplateName = shiftNameTextfield.text!
        newShiftTemplate.shiftTimeStart = shiftStartTextfield.text!
        newShiftTemplate.shiftTimeEnd = shiftEndTextfield.text!
        self.saveData(to: newShiftTemplate)
    }
    
    @IBAction func continueBotton(_ sender: UIButton) {
    }
    
    @IBAction func addStartTime(_ sender: UITextField) {
        textFieldSenderIndex = sender.tag
        displayPickerView(true)
    }
    
    
    @IBAction func addEndTime(_ sender: UITextField) {
        textFieldSenderIndex = sender.tag
//        shiftTimeValueChange(sender: datePicker,textField: shiftEndTextfield)
        displayPickerView(true)
    }
    
    func displayPickerView(_ show:Bool){
        
        for bottomContraints in view.constraints {
            if bottomContraints.identifier == "bottom" {
                bottomContraints.constant = (show) ? -10 : view.frame.height / 3
                break
            }
        }
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundFrame.layer.cornerRadius = 15
        saveBtnOutlet.layer.cornerRadius = 10
        saveBtnOutlet.layer.borderColor = UIColor.black.cgColor
        saveBtnOutlet.layer.borderWidth = 0.2
        continueBtnOutlet.layer.cornerRadius = 10
        continueBtnOutlet.layer.borderColor = UIColor.black.cgColor
        continueBtnOutlet.layer.borderWidth = 0.2
        self.shiftStartTextfield.tag = 0
        self.shiftEndTextfield.tag = 1
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.addSubview(additionalView)
        let additionalViewHeight = view.frame.height / 3
        additionalView.translatesAutoresizingMaskIntoConstraints = false
         additionalView.heightAnchor.constraint(equalToConstant: additionalViewHeight).isActive = true
        additionalView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        additionalView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        let bottomContraints = additionalView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: additionalViewHeight)
        bottomContraints.isActive = true
        bottomContraints.identifier = "bottom"
        
        additionalView.layer.cornerRadius = 10
        
    }
    func saveData(to realmData:shiftTemplateData){
        do{
            try realm.write {
                realm.add(realmData)
            }
        }catch{
            print("error saving shiftTemplateData \(error)")
        }
    }
}

