//
//  TimeSheetViewController.swift
//  Roster
//
//  Created by Morris on 2018/5/22.
//  Copyright © 2018年 Morris. All rights reserved.
//

import UIKit
import RealmSwift

class TimeSheetViewController: UIViewController {
    
    let realm = try! Realm()
    var staff:Results<EmployeeData>?
    
    var dateFrom = Date()
    var dateTo = Date()
    var chooseStaff = ""
    
    var buttonPressedIndex = 0
    @IBAction func dateStartBtn(_ sender: UIButton) {
        buttonPressedIndex = sender.tag
        displayPickerView(true,identifier: "date")
    }
    @IBAction func dateEndBtn(_ sender: UIButton) {
        buttonPressedIndex = sender.tag
        displayPickerView(true,identifier: "date")
    }
    @IBAction func personBtn(_ sender: UIButton) {
        displayPickerView(true, identifier: "name")
    }
    @IBOutlet weak var dateStartTextView: UITextView!
    @IBOutlet weak var dateEndTextView: UITextView!
    @IBOutlet weak var personTextView: UITextView!
    @IBOutlet var showPickerView: UIView!
    
    @IBOutlet var showNameView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var namePicker: UIPickerView!
    @IBOutlet weak var goFilterOutlet: UIButton!
    @IBAction func goFilterButton(_ sender: UIButton) {
        if dateStartTextView.text == "" || dateEndTextView.text == "" || personTextView.text == "" {
            let alert = UIAlertController(title: "Please choose date range", message: "", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert,animated: true,completion: nil)
        }
        performSegue(withIdentifier: "goFilter", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TimeSheetResultViewController {
            vc.dateFrom = dateFrom
            vc.dateTo = dateTo
            vc.choosePerson = chooseStaff
        }
    }
    func loadStaff(){
        staff = realm.objects(EmployeeData.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goFilterOutlet.layer.cornerRadius = 22
        loadStaff()
        
    }
    
    func setupConstraints(popUpView:UIView!,identifier:String){
        view.addSubview(popUpView)
        let height = view.frame.height / 3
        popUpView.translatesAutoresizingMaskIntoConstraints = false
        popUpView.heightAnchor.constraint(equalToConstant: height).isActive = true
        popUpView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        popUpView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        let bottomContraints = popUpView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: height)
        bottomContraints.isActive = true
        bottomContraints.identifier = identifier
        popUpView.layer.cornerRadius = 10
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupConstraints(popUpView: showPickerView,identifier: "date")
        setupConstraints(popUpView: showNameView,identifier: "name")
        
    }
    func displayPickerView(_ show:Bool,identifier:String){
        
        for bottomContraints in view.constraints {
            if bottomContraints.identifier == identifier {
                bottomContraints.constant = (show) ? -10 : view.frame.height / 3
                break
            }
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    func dateFormatter(date:Date)->String{
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "dd MMM YYYY"
        let dateInString = formatter.string(from: date)
        return dateInString
    }
    @IBAction func saveDateBtn(_ sender: UIButton) {
        displayPickerView(false, identifier: "date")
        switch buttonPressedIndex {
        case 1:
            dateStartTextView.text = dateFormatter(date: datePicker.date)
            dateFrom = datePicker.date
        case 2:
            dateEndTextView.text = dateFormatter(date: datePicker.date)
            dateTo = datePicker.date
        default:
            break
        }
    }
    
    @IBAction func saveNameBtn(_ sender: UIButton) {
        displayPickerView(false, identifier: "name")
    }
}

extension TimeSheetViewController:UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return staff?[row].employeeName ?? "No data"
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return staff?.count ?? 1
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let person = staff?[row]{
            chooseStaff = person.employeeName
            personTextView.text = person.employeeName
        }
    }
}
