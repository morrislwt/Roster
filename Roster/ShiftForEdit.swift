//
//  ShiftForEdit.swift
//  SlideOutMenu
//
//  Created by Morris on 2018/5/26.
//  Copyright © 2018年 Morris. All rights reserved.
//

import Foundation
import RealmSwift

class ShiftForEdit:UIViewController,UITextFieldDelegate{
    
    var indexForEdit:Int = 0
    let realm = try! Realm()
    
    var textFieldSenderIndex:Int = 0
    var timeStart:Date?
    var timeEnd:Date?
    var totalMinutes:String = ""
    var shiftModel:Results<shiftTemplateData>?
    
    @IBOutlet var additionalView: UIView!
    
    @IBAction func backButton(_ sender: UIButton) {
        performSegue(withIdentifier: "backDashboard", sender: self)
    }
    @IBAction func doneBtnPressed(_ sender: UIButton) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateFormat = "HH:mm"
        if textFieldSenderIndex == 0 {
//            timeStart = datePicker.date
            shiftStartTextfield.text = formatter.string(from: datePicker.date)
        }else if textFieldSenderIndex == 1 {
//            timeEnd = datePicker.date
            shiftEndTextfield.text = formatter.string(from: datePicker.date)
        }
        displayPickerView(false)
    }
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveBtnOutlet: UIButton!
    
    @IBOutlet weak var backOutlet: UIButton!
    @IBOutlet weak var shiftNameTextfield: UITextField!
    @IBOutlet weak var shiftStartTextfield: UITextField!
    @IBOutlet weak var shiftEndTextfield: UITextField!
    @IBAction func saveButton(_ sender: UIButton) {
        saveShiftDetail()
        guard shiftNameTextfield.text != "",shiftStartTextfield.text != "", shiftEndTextfield.text != "" else {
            return
        }
        performSegue(withIdentifier: "backDashboard", sender: self)
    }
    
//
//    @IBAction func addStartTime(_ sender: UITextField) {
//
//
//
//    }
    
    
    @IBAction func showStartTime(_ sender: UITextField) {
        displayPickerView(true)
        textFieldSenderIndex = sender.tag
        shiftStartTextfield.resignFirstResponder()
    }
    
    
    @IBAction func showEndTime(_ sender: UITextField) {
        displayPickerView(true)
        textFieldSenderIndex = sender.tag
        shiftEndTextfield.resignFirstResponder()
    }

    
    func saveShiftDetail(){
        if shiftNameTextfield.text != "" &&  shiftStartTextfield.text != "" &&  shiftEndTextfield.text != "" {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let calendar = Calendar.current
            let unit:Set<Calendar.Component> = [.hour,.minute]
            timeStart = dateFormatter.date(from: shiftStartTextfield.text!)
            timeEnd = dateFormatter.date(from: shiftEndTextfield.text!)
            let commponent:DateComponents = calendar.dateComponents(unit, from: timeEnd!, to: timeStart!)
            do{
                try realm.write {
                    shiftModel?[indexForEdit].shiftTemplateName = shiftNameTextfield.text!
                    shiftModel?[indexForEdit].shiftTimeStart = shiftStartTextfield.text!
                    shiftModel?[indexForEdit].shiftTimeEnd = shiftEndTextfield.text!
                    shiftModel?[indexForEdit].TotalMinutes = abs(commponent.hour!*60) + abs(commponent.minute!)
                }
            }catch{
                print("error saving shiftTemplateData \(error)")
            }
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

        self.shiftStartTextfield.tag = 0
        self.shiftEndTextfield.tag = 1
        self.datePicker.setValue(UIColor.darkGray, forKey: "textColor")
        loadData()
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(forName: .indexForEdit, object: nil, queue: OperationQueue.main) { (notification) in
            let vc = notification.object as! DashboardViewController
            self.indexForEdit = vc.indexForEdit
            self.shiftNameTextfield.text = self.shiftModel?[self.indexForEdit].shiftTemplateName
            self.shiftStartTextfield.text = self.shiftModel?[self.indexForEdit].shiftTimeStart
            self.shiftEndTextfield.text = self.shiftModel?[self.indexForEdit].shiftTimeEnd
        }
        saveBtnOutlet.layer.cornerRadius = saveBtnOutlet.frame.width / 2
        backOutlet.layer.cornerRadius = backOutlet.frame.width / 2
        
        
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
        
        
        
    }
    func loadData(){
    shiftModel = realm.objects(shiftTemplateData.self)
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
}
