//
//  addShiftDetailVC.swift
//  Roster
//
//  Created by Morris on 2018/5/6.
//  Copyright © 2018年 Morris. All rights reserved.
//

import Foundation
import RealmSwift
import Popover

class addShiftDetailVC: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet weak var myPickerView: UIPickerView!
    
    var selectedIndex:Int = 0
    
    var selectedStaff:String = ""
    var selectedWorkPlace:String = ""
    var selectedPosition:String = ""
    var selectedShiftName:String = ""
    
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
    
    let addShiftOptions = ["Date","Staff","Work Place","Position","Shift Name","Shift Start","Shift End","Break Time","Total time","Duty"]
    
    @IBOutlet var selectView: UIView!
    
    @IBAction func donePressed(_ sender: Any) {
        displayPickerView(false)
    }
    @IBAction func addButton(_ sender: Any) {
//        displayPickerView(true)
        
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
    @IBAction func saveButton(_ sender: Any) {

    }
    
    @IBOutlet weak var saveButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Add New Shift"
        saveButtonOutlet.layer.cornerRadius = 20
        saveButtonOutlet.clipsToBounds = true
        loadRealmData()

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
        return 1
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
            }
            
        }
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if selectedIndex == 1 {
            return staffArray?[row].employeeName
        }else if selectedIndex == 2 {
            return workPlaceArray?[row].placename
        }else if selectedIndex == 3 {
            return positionArray?[row].positionName
        }else if selectedIndex == 4 {
            return shiftTemplateArray?[row].shiftTemplateName
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
        if selectedIndex == 1 {
            selectedStaff = (staffArray?[row].employeeName)!
        }else if selectedIndex == 2 {
            selectedWorkPlace = (workPlaceArray?[row].placename)!
        }else if selectedIndex == 3 {
            selectedPosition = (positionArray?[row].positionName)!
        }else if selectedIndex == 4 {
            selectedShiftName = (shiftTemplateArray?[row].shiftTemplateName)!
        }
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

        }
        if indexPath.item == 6 {
            cell.addButtonOutlet.isHidden = true
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
        if indexPath.item == 4 {
            return CGSize(width: smallWidth, height: height)
        }
        if indexPath.item == 5 {
            return CGSize(width: smallWidth, height: height)
        }
        if indexPath.item == 6 {
            return CGSize(width: smallWidth, height: height)
        }
        if indexPath.item == 7 {
            return CGSize(width: halfWidth, height: height)
        }
        if indexPath.item == 8 {
            return CGSize(width: halfWidth, height: height)
        }
        return CGSize(width: width , height: height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedIndex = indexPath.item
        
        if indexPath.item == 0 {
            displayPickerView(true)
        }
        if indexPath.item == 1 {
            displayPickerView(true)
        }
        if indexPath.item == 2 {
            displayPickerView(true)
        }
        if indexPath.item == 3 {
            displayPickerView(true)
        }
        if indexPath.item == 4 {
            displayPickerView(true)
        }
        
    }
    
}
