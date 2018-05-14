//
//  addShiftDetailVC.swift
//  Roster
//
//  Created by Morris on 2018/5/6.
//  Copyright © 2018年 Morris. All rights reserved.
//

import Foundation
import RealmSwift

class addShiftDetailVC: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet weak var continueAddOutlet: UIButton!
    @IBOutlet weak var myPickerView: UIPickerView!
    
    var selectedIndex:Int = 0
    
    var selectedStaff:String = ""
    var selectedWorkPlace:String = ""
    var selectedPosition:String = ""
    var selectedShiftName:String = ""
    var selectedStartTime:String = ""
    var selectedEndTime:String = ""
    var selectedDuty:String = ""
    var breakHour:Int = 0
    var breakMin:Int = 0
    
    var staffArray:Results<EmployeeData>?
    var workPlaceArray:Results<WorkSpaceData>?
    var positionArray:Results<PositionData>?
    var shiftTemplateArray:Results<shiftTemplateData>?
    
    
    let realm_Data = try! Realm()
    
    
    func loadRealmData(){
        staffArray = realm_Data.objects(EmployeeData.self)
        workPlaceArray = realm_Data.objects(WorkSpaceData.self)
        positionArray = realm_Data.objects(PositionData.self)
        shiftTemplateArray = realm_Data.objects(shiftTemplateData.self)
        addShiftCollectionView.reloadData()
    }
    
    @IBOutlet weak var addShiftCollectionView: UICollectionView!
    
    var selectDateFromCalendar:String?
    var selectDateInDateType:Date?
    
    let addShiftOptions = ["Date","Staff","Work Place","Position","Shift Name","Shift Start","Shift End","Break Time","Total time","Duty"]
    
    
    @IBOutlet var selectView: UIView!
    
    @IBAction func donePressed(_ sender: Any) {
        displayPickerView(false)
    }

    func displayPickerView(_ show:Bool){
        
        for bottomContraints in view.constraints {
            if bottomContraints.identifier == "bottom" {
                bottomContraints.constant = (show) ? -10 : view.frame.height / 3
                break
            }
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    func displaySuccess(){
        for topContraints in view.constraints {
            if topContraints.identifier == "top" {
                topContraints.constant = 10
            }
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
    @IBAction func saveBtnPressed(_ sender: UIBarButtonItem) {
        saveDataToCal(goBack: true)
    }
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
            let gotItAction = UIAlertAction(title: "Got it", style: .default, handler: nil)
            emptyAlert.addAction(gotItAction)
            present(emptyAlert,animated: true, completion: nil)
        }
        
    }
    @IBAction func continueAdd(_ sender: UIButton) {
        saveDataToCal(goBack: false)
        if  selectedStaff != "" && selectedWorkPlace != "" && selectedPosition != "" && selectedShiftName != "" && selectedStartTime != "" && selectedEndTime != "" {
            let alert = UIAlertController(title: "Save Success", message: "", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "OK", style: .default) { (action) in

                
            }
            alert.addAction(action)
            present(alert,animated: true, completion: nil)
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add New Shift"
        loadRealmData()
        continueAddOutlet.layer.cornerRadius = 15
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToDismiss))
//        view.addGestureRecognizer(tapGesture)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.addSubview(selectView)

        let selectViewHeight = view.frame.height / 3
        selectView.translatesAutoresizingMaskIntoConstraints = false
        selectView.heightAnchor.constraint(equalToConstant: selectViewHeight).isActive = true
        selectView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        selectView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        let bottomContraints = selectView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: selectViewHeight)
        bottomContraints.isActive = true
        bottomContraints.identifier = "bottom"
        selectView.layer.cornerRadius = 10
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if selectedIndex == 7 {
            return 2
        }else{
            return 1
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            
            if selectedIndex == 1 {
                return staffArray?.count ?? 1
            }else if selectedIndex == 2 {
                return workPlaceArray?.count ?? 1
            }else if selectedIndex == 3 {
                return positionArray?.count ?? 1
            }else if selectedIndex == 4 {
                return shiftTemplateArray?.count ?? 1
            }else if selectedIndex == 7 {
                return 24
            }
            
        }
        if component == 1 {
            return 12
        }
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            if selectedIndex == 1 {
                return staffArray?[row].employeeName
            }else if selectedIndex == 2 {
                return workPlaceArray?[row].placename
            }else if selectedIndex == 3 {
                return positionArray?[row].positionName
            }else if selectedIndex == 4 {
                return shiftTemplateArray?[row].shiftTemplateName
            }else if selectedIndex == 7 {
                /////   need some code  /////
                return "\(row) Hour"
            }
        }
        if component == 1 {
            return "\(row * 5) Mins"
        }
        return nil
//        return [staffArray, workPlaceArray, positionArray, shiftTemplateArray]
//        guard let pickStaff = staffArray?[row].employeeName else { return "No staff available now"}
//        guard let pickWorkplace = workPlaceArray?[row].placename else { return "No workplace available now"}
//        guard let pickPosition = positionArray?[row].positionName else { return "No position available now"}
//        guard let pickShift = shiftTemplateArray?[row].shiftTemplateName else { return "No shift available now"}
//        if selectedIndex == 1 {
////            return pickStaff
//        }else if selectedIndex == 2 {
////            return pickWorkplace
//        }else if selectedIndex == 3 {
////            return pickPosition
//        }else if selectedIndex == 4 {
//            return pickShift
//        }else{
//            return "No data available now"
//        }
//return "test"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        ///don't use 因為當 row 有超過 array count 時，就會crash
//        guard let pickstaff = staffArray?[row].employeeName {
//
//        }
        if component == 0 {
            if selectedIndex == 1 {
                selectedStaff = (staffArray?[row].employeeName)!
            }else if selectedIndex == 2 {
                selectedWorkPlace = (workPlaceArray?[row].placename)!
            }else if selectedIndex == 3 {
                selectedPosition = (positionArray?[row].positionName)!
            }else if selectedIndex == 4 {
                selectedShiftName = (shiftTemplateArray?[row].shiftTemplateName)!
                selectedStartTime = (shiftTemplateArray?[row].shiftTimeStart)!
                selectedEndTime = (shiftTemplateArray?[row].shiftTimeEnd)!
            }else if selectedIndex == 7 {
                breakHour = row
                
            }
        }
        if component == 1 {
            if selectedIndex == 7 {
                breakMin = row * 5
                
            }
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
        if indexPath.item == 0 {
            cell.infoLabel.isHidden = false
            cell.infoLabel.text = selectDateFromCalendar
        }
        
        if indexPath.item == 1 {
            cell.infoLabel.isHidden = false
            cell.infoLabel.text = selectedStaff
            cell.addButtonOutlet.isHidden = false
        }
        if indexPath.item == 2 {
            cell.addButtonOutlet.isHidden = false
            cell.infoLabel.isHidden = false
            cell.infoLabel.text = selectedWorkPlace
        }
        if indexPath.item == 3 {
            cell.addButtonOutlet.isHidden = false
            cell.infoLabel.isHidden = false
            cell.infoLabel.text = selectedPosition
        }
        if indexPath.item == 4 {
            cell.addButtonOutlet.isHidden = false
            cell.infoLabel.isHidden = false
            cell.infoLabel.text = selectedShiftName
        }
        if indexPath.item == 5 {
            cell.addButtonOutlet.isHidden = true
            cell.infoLabel.isHidden = false
            cell.infoLabel.text = selectedStartTime

        }
        if indexPath.item == 6 {
            cell.addButtonOutlet.isHidden = true
            cell.infoLabel.isHidden = false
            cell.infoLabel.text = selectedEndTime
        }
        if indexPath.item == 7 {
            cell.addButtonOutlet.isHidden = false
            cell.infoLabel.isHidden = false
            cell.infoLabel.text = "\(breakHour) Hour \(breakMin) mins."
        }
        if indexPath.item == 9 {
            cell.addButtonOutlet.isHidden = false
            cell.infoLabel.isHidden = false
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
        let width = view.frame.width
        let height = (view.frame.height - 44) / 8
        let smallWidth = view.frame.width / 3
        let halfWidth = view.frame.width / 2
        
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
        
        myPickerView.selectRow(0, inComponent: 0, animated: true)

        switch indexPath.item{
        case 1...4:
            displayPickerView(true)
        default:
            break
        }
        if indexPath.item == 7 {
            displayPickerView(true)
        }
        
        if indexPath.item == 9 {
            
            var dutyTextfield = UITextField()
            
            let alert = UIAlertController(title: "Duty Message", message: "", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addTextField { (inputDuty) in
                
                inputDuty.placeholder = "Input some task"
                inputDuty.autocorrectionType = .yes
                dutyTextfield = inputDuty
                
            }

            let add = UIAlertAction(title: "Add", style: .default) { (add) in
                if let text = dutyTextfield.text {
                    self.selectedDuty = text
                    self.addShiftCollectionView.reloadData()
                }
            }
            alert.addAction(cancel)
            alert.addAction(add)
            
            present(alert,animated: true, completion: nil)
        }
        
    }
    
}
