//
//  ShiftVC2.swift
//  Roster
//
//  Created by Morris on 2018/5/11.
//  Copyright © 2018年 Morris. All rights reserved.
//

import Foundation
import RealmSwift

class ShiftVC_second:UIViewController,UITextFieldDelegate{
    var infoFromEdit:String?
    
    let realm = try! Realm()
    
    var textFieldSenderIndex:Int = 0
    var timeStart:Date?
    var timeEnd:Date?
    var totalMinutes:String = ""
    
    @IBOutlet var additionalView: UIView!
    
    @IBAction func backButton(_ sender: UIButton) {
        performSegue(withIdentifier: "goBack", sender: self)
    }
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
    @IBAction func saveButton(_ sender: UIButton) {
        saveShiftDetail(true)
    }
    
    @IBAction func continueBotton(_ sender: UIButton) {
        saveShiftDetail(false)
        let alert = UIAlertController(title: "✅", message: "Save Successful", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Got it", style: .default) { (action) in
            self.shiftNameTextfield.text = ""
            self.shiftStartTextfield.text = ""
            self.shiftEndTextfield.text = ""
        }
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
    }
    
    @IBAction func addStartTime(_ sender: UITextField) {
        textFieldSenderIndex = sender.tag
        shiftStartTextfield.resignFirstResponder()
        displayPickerView(true)
        
    }
    
    
    @IBAction func addEndTime(_ sender: UITextField) {
        shiftEndTextfield.resignFirstResponder()
        textFieldSenderIndex = sender.tag
        
        
        //        shiftTimeValueChange(sender: datePicker,textField: shiftEndTextfield)
        displayPickerView(true)
    }
    
    func saveShiftDetail(_ goBack:Bool){
        if shiftNameTextfield.text != "" &&  shiftStartTextfield.text != "" &&  shiftEndTextfield.text != "" {
            let newShiftTemplate = shiftTemplateData()
            newShiftTemplate.shiftTemplateName = shiftNameTextfield.text!
            newShiftTemplate.shiftTimeStart = shiftStartTextfield.text!
            newShiftTemplate.shiftTimeEnd = shiftEndTextfield.text!
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let calendar = Calendar.current
            let unit:Set<Calendar.Component> = [.hour,.minute]
            //        let startTime = dateFormatter.date(from: selectedStartTime)
            //        let endTime = dateFormatter.date(from: selectedEndTime)
            let commponent:DateComponents = calendar.dateComponents(unit, from: timeEnd!, to: timeStart!)
            newShiftTemplate.TotalMinutes = abs(commponent.hour!*60) + abs(commponent.minute!)
            
            self.saveData(to: newShiftTemplate)
            goBack == true ? performSegue(withIdentifier: "goBack", sender: self) : nil
            
            

            
        }else{
            let alert = UIAlertController(title: "Please fill all detail😎", message: "", preferredStyle: .actionSheet)
            let gotItAction = UIAlertAction(title: "Got it", style: .default, handler: nil)
            alert.addAction(gotItAction)
            present(alert,animated: true, completion: nil)
        }
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        shiftNameTextfield.resignFirstResponder()
        return true
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        saveBtnOutlet.layer.cornerRadius = 22
//        saveBtnOutlet.layer.borderColor = UIColor.black.cgColor
//        saveBtnOutlet.layer.borderWidth = 0.2
        continueBtnOutlet.layer.cornerRadius = 10
        continueBtnOutlet.layer.borderColor = UIColor.black.cgColor
        continueBtnOutlet.layer.borderWidth = 0.2
        self.shiftStartTextfield.tag = 0
        self.shiftEndTextfield.tag = 1
        self.datePicker.setValue(UIColor.white, forKey: "textColor")
        
        
        self.hideKeyboardWhenTappedAround()
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
        self.shiftNameTextfield.delegate = self
        self.shiftStartTextfield.delegate = self
        self.shiftEndTextfield.delegate = self
        
        shiftNameTextfield.becomeFirstResponder()
        
        
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
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

