//
//  addShiftDetailVC.swift
//  Roster
//
//  Created by Morris on 2018/5/6.
//  Copyright © 2018年 Morris. All rights reserved.
//

import Foundation
import RealmSwift

class addShiftDetailVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBAction func timePickerDoneBtn(_ sender: UIButton) {
        displayPickerView(false, identifier: "pickerView",fromTop: true)
    }
    @IBOutlet var timeView: UIView!
    @IBOutlet weak var timePickerView: UIPickerView!
    @IBOutlet weak var popTableView: UITableView!
    @IBOutlet weak var saveBtnOutlet: UIButton!
    @IBOutlet weak var continueAddOutlet: UIButton!
    
    @IBOutlet weak var backBtnOutlet: UIButton!
    
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        saveDataToCal(goBack: true)
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "backToCal", sender: self)
        
    }
    var selectedIndex:Int = 0
    var selectedStaff:String = ""
    var selectedWorkPlace:String = ""
    var selectedPosition:String = ""
    var selectedShiftName:String = ""
    var selectedStartTime:String = ""
    var selectedEndTime:String = ""
    var selectedShiftMinutes:Int = 0
    var selectedDuty:String = ""
    var breakHour:Int = 0
    var breakMin:Int = 0
    var totalWorkMinutes:Int{
        get {
            return selectedShiftMinutes - breakHour * 60 - breakMin
        }
        set {
        }
    }
    var staffArray:Results<EmployeeData>?
    var workPlaceArray:Results<WorkSpaceData>?
    var positionArray:Results<PositionData>?
    var shiftTemplateArray:Results<shiftTemplateData>?
    
    let realm_Data = try! Realm()
    
    func loadRealmData(){
        staffArray = realm_Data.objects(EmployeeData.self)
        workPlaceArray = realm_Data.objects(WorkSpaceData.self)
        positionArray = realm_Data.objects(PositionData.self)
        shiftTemplateArray = realm_Data.objects(shiftTemplateData.self).sorted(byKeyPath: "shiftTimeStart", ascending: true)
    }
    
    @IBOutlet weak var addShiftCollectionView: UICollectionView!
    
    var selectDateFromCalendar:String?
    var selectDateInDateType:Date?
    
    let addShiftOptions = ["Date","Staff","Work Place","Position","Shift Name","Shift Start","Shift End","Break Time (optional)","Total time","Duty (optional)"]
    
    
    @IBOutlet var selectView: UIView!
    

    func displayPickerView(_ show:Bool,identifier:String,fromTop:Bool){
        
        for bottomContraints in view.constraints {
            if bottomContraints.identifier == identifier {
                if fromTop == false{
                    bottomContraints.constant = (show) ? -100 : view.frame.height / 3
                }else if fromTop == true {
                    bottomContraints.constant = (show) ? -300 : view.frame.height / 3
                }
                break
            }
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    //    @objc func tapToDismiss(){
//        for bottomContraints in view.constraints {
//            if bottomContraints.identifier == "bottom" {
//                bottomContraints.constant = view.frame.height / 3
//                break
//            }
//        }
//        UIView.animate(withDuration: 0.2) {
//            self.view.layoutIfNeeded()
//        }
//    }
    func saveDataToCal(goBack:Bool){
        let newShiftToCal = ShiftDataToCalender()
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "eee dd MMM YYYY"
        if  selectedStaff != "" && selectedWorkPlace != "" && selectedPosition != "" && selectedShiftName != "" && selectedStartTime != "" && selectedEndTime != "" {

            newShiftToCal.shiftDate = selectDateInDateType
            newShiftToCal.staff = selectedStaff
            newShiftToCal.workPlace = selectedWorkPlace
            newShiftToCal.position = selectedPosition
            newShiftToCal.shiftName = selectedShiftName
            newShiftToCal.shiftStart = selectedStartTime
            newShiftToCal.shiftEnd = selectedEndTime
            newShiftToCal.breakMinutes = (breakHour * 60) + breakMin
            newShiftToCal.totalWorkMinutes = totalWorkMinutes
            newShiftToCal.duty = selectedDuty

        do{
            try realm_Data.write {
                realm_Data.add(newShiftToCal)
            }
        }catch{
            print("saving shift data error \(error)")
        }
        goBack == true ? performSegue(withIdentifier: "backToCal", sender: self) : nil
        }else{
            let emptyAlert = UIAlertController(title: "Fill all the detail please", message: "👮🏻‍♂️", preferredStyle: .actionSheet)
            emptyAlert.setTitle(font:UIFont(name: "Avenir Next", size: 17)!, color: .darkGray)
            let gotItAction = UIAlertAction(title: "Got it", style: .default, handler: nil)
            emptyAlert.addAction(gotItAction)
            present(emptyAlert,animated: true, completion: nil)
        }
        
    }
    @IBAction func continueAdd(_ sender: UIButton) {
        saveDataToCal(goBack: false)
        if  selectedStaff != "" && selectedWorkPlace != "" && selectedPosition != "" && selectedShiftName != "" && selectedStartTime != "" && selectedEndTime != "" {
            let alert = UIAlertController(style: .actionSheet, title: "Save Success")
            alert.setTitle(font:UIFont(name: "Avenir Next", size: 17)!, color: .darkGray)
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
                self.selectedStaff = ""
                self.selectedWorkPlace = ""
                self.selectedPosition = ""
                self.selectedShiftName = ""
                self.breakMin = 0
                self.breakHour = 0
                self.selectedDuty = ""
                self.selectedStartTime = ""
                self.selectedEndTime = ""
                self.totalWorkMinutes = 0
                self.addShiftCollectionView.reloadData()
                
            }
            alert.addAction(action)
            present(alert,animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAlertView(chooseView: selectView, identifier: "tableView")
        showAlertView(chooseView: timeView, identifier: "pickerView")
        navigationItem.title = "Add New Shift"
        loadRealmData()
        continueAddOutlet.layer.cornerRadius = continueAddOutlet.frame.width / 2
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToDismiss))
//        view.addGestureRecognizer(tapGesture)
        saveBtnOutlet.layer.cornerRadius = saveBtnOutlet.frame.width / 2
        backBtnOutlet.layer.cornerRadius = 20
        addShiftCollectionView.backgroundColor = .clear
        popTableView.backgroundColor = .clear
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    func showAlertView(chooseView:UIView!,identifier:String){
        view.addSubview(chooseView)
        let selectViewHeight = view.frame.height / 4
        chooseView.translatesAutoresizingMaskIntoConstraints = false
        chooseView.heightAnchor.constraint(equalToConstant: selectViewHeight).isActive = true
        chooseView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        chooseView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        let bottomContraints = chooseView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: selectViewHeight)
        bottomContraints.isActive = true
        bottomContraints.identifier = identifier
        chooseView.layer.cornerRadius = 20
        chooseView.clipsToBounds = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 24
        case 1:
            return 12
        default:
            break
        }
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        switch component {
        case 0:
            return "\(row) Hour"
        case 1:
            return "\(row * 5) Mins"
        default:
            break
        }
        
        return ""
//        return [staffArray, workPlaceArray, positionArray, shiftTemplateArray]
//        guard let pickStaff = staffArray?[row].employeeName else { return "No staff available now"}


    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        ///don't use 因為當 row 有超過 array count 時，就會crash
//        guard let pickstaff = staffArray?[row].employeeName else {
//            return
//        }
        switch component {
        case 0:
            breakHour = row
        case 1:
            breakMin = row * 5
        default:
            break
        }
        addShiftCollectionView.reloadData()
    }
}

extension addShiftDetailVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addShiftOptions.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AddShiftCollectionViewCell

        
        cell.titleLabel.text = addShiftOptions[indexPath.row]
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.2
        cell.infoLabel.isHidden = true
        cell.addButtonOutlet.isHidden = true
        
        switch indexPath.item {
        case 1...4,7,9:
            cell.infoLabel.isHidden = false
            cell.addButtonOutlet.isHidden = false
        case 5...6,8:
            cell.infoLabel.isHidden = false
            cell.addButtonOutlet.isHidden = true
        default:
            break
        }
        if indexPath.item == 0 {
            cell.infoLabel.isHidden = false
            cell.infoLabel.text = selectDateFromCalendar
        }
        
        if indexPath.item == 1 {
            cell.infoLabel.text = selectedStaff
        }
        if indexPath.item == 2 {
            cell.infoLabel.text = selectedWorkPlace
        }
        if indexPath.item == 3 {
            cell.infoLabel.text = selectedPosition
        }
        if indexPath.item == 4 {
            cell.infoLabel.text = selectedShiftName
        }
        if indexPath.item == 5 {
            cell.infoLabel.text = selectedStartTime
        }
        if indexPath.item == 6 {
            cell.infoLabel.text = selectedEndTime
        }
        if indexPath.item == 7 {
            cell.infoLabel.text = "\(breakHour) Hour \(breakMin) mins."
        }
        if indexPath.item == 8 {
            cell.infoLabel.text = "\(totalWorkMinutes / 60) Hours \(totalWorkMinutes % 60) Minutes"
        }
        if indexPath.item == 9 {
            cell.infoLabel.text = selectedDuty
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = addShiftCollectionView.frame.width
        let height = (addShiftCollectionView.frame.height) / 8
        let smallWidth = (width-1) / 3
        let halfWidth = width / 2

        switch indexPath.item {
        case 4...6:
            return CGSize(width: smallWidth, height: height)
        case 7,8:
            return CGSize(width: halfWidth, height: height)
        default:
            return CGSize(width: width , height: height)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedIndex = indexPath.item
        popTableView.reloadData()
//        myPickerView.selectRow(0, inComponent: 0, animated: true)

        switch indexPath.item{
        case 1...4:
            displayPickerView(true, identifier: "tableView",fromTop: false)
            
        case 0,5...6,9:
            displayPickerView(false, identifier: "tableView", fromTop: false)
            displayPickerView(false, identifier: "pickerView", fromTop: true)

        default:
            break
        }
        if indexPath.item == 7 {
            displayPickerView(true, identifier: "pickerView",fromTop: true)
        }
        
        if indexPath.item == 9 {
            let dutyTextfield = UITextField()
            let alert = UIAlertController(style: .alert, title:"Duty Message")
            let image = UIImage(named: "speaker")
            let config: TextField.Config = { textField in
                textField.becomeFirstResponder()
                textField.textColor = .black
                textField.placeholder = "Write some message"
                textField.autocapitalizationType = .words
                textField.left(image: image,color: .gray)
                textField.leftViewPadding = 12
                textField.borderWidth = 1
                textField.cornerRadius = 8
                textField.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
                textField.backgroundColor = nil
                textField.returnKeyType = .done
                textField.action { textField in
                    dutyTextfield.text = textField.text
                }
            }
            let add = UIAlertAction(title: "Add", style: .default) { (add) in
                if let text = dutyTextfield.text {
                    self.selectedDuty = text
                    self.addShiftCollectionView.reloadData()
                }
            }
            alert.addAction(add)
            alert.addOneTextField(configuration: config)
            alert.addAction(title: "Cancel", style: .cancel)
            present(alert,animated: true, completion: nil)
        }
        
    }
}
extension addShiftDetailVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedIndex {
        case 1:
            guard staffArray?.count > 0 else { return 1}
            return staffArray?.count ?? 1
        case 2:
            guard workPlaceArray?.count > 0 else { return 1}
            return workPlaceArray?.count ?? 1
        case 3:
            guard positionArray?.count > 0 else { return 1}
            return positionArray?.count ?? 1
        case 4:
            guard shiftTemplateArray?.count > 0 else { return 1}
            return shiftTemplateArray?.count ?? 1
        default:
            break
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        switch selectedIndex {
        case 1:
            if staffArray?.count == 0 {
                cell.textLabel?.text = "Please add some data from Dashboard."
                cell.textLabel?.textColor = .gray
                cell.backgroundColor = .clear
            }
            guard staffArray?.count > 0 else { return cell}
            cell.textLabel?.text = staffArray?[indexPath.row].employeeName ?? "No Data"
            cell.backgroundColor = .clear
        case 2:
            if workPlaceArray?.count == 0 {
                cell.textLabel?.text = "Please add some data from Dashboard."
                cell.textLabel?.textColor = .gray
                cell.backgroundColor = .clear
            }
            guard workPlaceArray?.count > 0 else { return cell}
            cell.textLabel?.text = workPlaceArray?[indexPath.row].placename ?? "No Data"
            cell.backgroundColor = .clear
        case 3:
            if positionArray?.count == 0 {
                cell.textLabel?.text = "Please add some data from Dashboard."
                cell.textLabel?.textColor = .gray
                cell.backgroundColor = .clear
            }
            guard positionArray?.count > 0 else { return cell}
            cell.textLabel?.text = positionArray?[indexPath.row].positionName ?? "No Data"
            cell.backgroundColor = .clear
        case 4:
            if shiftTemplateArray?.count == 0 {
                cell.textLabel?.text = "Please add some data from Dashboard."
                cell.textLabel?.textColor = .gray
                cell.backgroundColor = .clear
            }
            guard shiftTemplateArray?.count > 0 else { return cell}
            cell.textLabel?.text = shiftTemplateArray?[indexPath.row].shiftTemplateName ?? "No Data"
            cell.backgroundColor = .clear
            if let text = shiftTemplateArray?[indexPath.row]{
                cell.detailTextLabel?.text = "\(text.shiftTimeStart) - \(text.shiftTimeEnd)"
                cell.backgroundColor = .clear
            }
        default:
            break
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return addShiftOptions[selectedIndex]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        displayPickerView(false, identifier: "tableView",fromTop: false)
        switch selectedIndex {
        case 1:
            guard staffArray?.count > 0 else { return }
            selectedStaff = staffArray?[indexPath.row].employeeName ?? "No Data"
        case 2:
            guard workPlaceArray?.count > 0 else { return }
            selectedWorkPlace = workPlaceArray?[indexPath.row].placename ?? "No Data"
        case 3:
            guard positionArray?.count > 0 else { return }
            selectedPosition = positionArray?[indexPath.row].positionName ?? "No Data"
        case 4:
            guard shiftTemplateArray?.count > 0 else { return }
            selectedShiftName = shiftTemplateArray?[indexPath.row].shiftTemplateName ?? "No Data"
            selectedStartTime = shiftTemplateArray?[indexPath.row].shiftTimeStart ?? "No Data"
            selectedEndTime = shiftTemplateArray?[indexPath.row].shiftTimeEnd ?? "No Data"
            
            selectedShiftMinutes = shiftTemplateArray?[indexPath.row].TotalMinutes ?? 0

        default:
            break
        }
        addShiftCollectionView.reloadData()
        
    }
}
