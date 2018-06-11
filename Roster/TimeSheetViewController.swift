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
    
    @IBOutlet weak var nameTableView: UITableView!
    @IBAction func backTimeSheet(_ segue:UIStoryboardSegue){
        
    }
    
    @IBOutlet weak var dateStartOutlet: UIButton!
    
    @IBOutlet weak var dateEndOutlet: UIButton!
    @IBOutlet weak var nameOutlet: UIButton!
    @IBOutlet weak var backgroundLeading: NSLayoutConstraint!
    @IBOutlet weak var backgroundOutlet: UIView!
    
    let realm = try! Realm()
    var staff:Results<EmployeeData>?
    
    var dateFrom = Date()
    var dateTo = Date()
    var chooseStaff = ""
    
    var buttonPressedIndex = 0
    
    @IBAction func dateStartBtn(_ sender: UIButton) {
        buttonPressedIndex = sender.tag
        displayPickerView(true,identifier: "date")
        displayPickerView(false,identifier: "name")
    }
    @IBAction func dateEndBtn(_ sender: UIButton) {
        buttonPressedIndex = sender.tag
        displayPickerView(true,identifier: "date")
        displayPickerView(false,identifier: "name")
    }
    @IBAction func personBtn(_ sender: UIButton) {
        displayPickerView(false,identifier: "date")
        displayPickerView(true, identifier: "name")
    }
    @IBOutlet weak var dateStartTextView: UITextView!
    @IBOutlet weak var dateEndTextView: UITextView!
    @IBOutlet weak var personTextView: UITextView!
    @IBOutlet var showPickerView: UIView!
    
    @IBOutlet var showNameView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var goFilterOutlet: UIButton!
    @IBAction func goFilterButton(_ sender: UIButton) {
        if dateFrom > dateTo {
            let alert = UIAlertController(style: .alert, title: "Date range wrong.", message:"End date should greater than start date.")
            alert.addAction(title: "OK")
            present(alert,animated: true, completion: nil)
        }
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
        nameTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goFilterOutlet.layer.cornerRadius = 22
        backgroundOutlet.layer.cornerRadius = 20
        backgroundOutlet.clipsToBounds = true
        dateStartOutlet.layer.cornerRadius = 22
        dateEndOutlet.layer.cornerRadius = 22
        nameOutlet.layer.cornerRadius = 22
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM YYYY"
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let string = formatter.string(from: date)
        let dateWithoutTime = formatter.date(from: string)
        datePicker.date = dateWithoutTime!
        showNameView.clipsToBounds = true
        nameTableView.separatorStyle = .none
        nameTableView.backgroundColor = .clear
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1) {
            self.backgroundLeading.constant = -20
            self.view.layoutIfNeeded()
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.backgroundLeading.constant = -400
    }
    
    func setupConstraints(popUpView:UIView!,identifier:String){
        view.addSubview(popUpView)
        let height = view.frame.height / 4
        popUpView.translatesAutoresizingMaskIntoConstraints = false
        popUpView.heightAnchor.constraint(equalToConstant: height).isActive = true
        popUpView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        popUpView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        let bottomContraints = popUpView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: height)
        bottomContraints.isActive = true
        bottomContraints.identifier = identifier
        popUpView.layer.cornerRadius = 20
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStaff()
        setupConstraints(popUpView: showPickerView,identifier: "date")
        setupConstraints(popUpView: showNameView,identifier: "name")
        
    }
    @objc func displayPickerView(_ show:Bool,identifier:String){
        
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
        formatter.timeStyle = .none
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
}

extension TimeSheetViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard staff?.count > 0 else { return 1}
        return staff?.count ?? 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if staff?.count == 0 {
            cell.backgroundColor = .clear
            cell.textLabel?.text = "Oops! Please add some staff in Dashboard."
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = UIFont(name: "Avenir Next", size: 17)
        }
        guard staff?.count > 0 else { return cell}
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = staff?[indexPath.row].employeeName
        cell.textLabel?.font = UIFont(name: "Avenir Next", size: 25)
        cell.textLabel?.textAlignment = .center
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        displayPickerView(false, identifier: "name")
        guard staff?.count > 0 else { return }
        if let person = staff?[indexPath.row]{
            chooseStaff = person.employeeName
            personTextView.text = person.employeeName
        }
    }
}
