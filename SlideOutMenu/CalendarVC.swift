//
//  ViewController.swift
//  Calendar
//
//  Created by Morris on 2018/4/30.
//  Copyright © 2018年 Morris. All rights reserved.
//

import UIKit
import CVCalendar
import RealmSwift
import SwipeCellKit


class CalendarVC: UIViewController {


    
    @IBOutlet weak var segmentOutlet: UIBarButtonItem!
    
    ///----------------------* Realm Methods *-----------------///
    let realm = try! Realm()
    func saveShift(object:ShiftDataToCalender){
        do{
            try realm.write {
                realm.add(object)
            }
        }catch{
            print("Error saving Shift Model \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    func loadShift(selectDate date:Date){
        //        selectStaff = realm.objects(ShiftModel.self).filter("date = '5/3'")
        selectStaff = realm.objects(ShiftDataToCalender.self).filter("shiftDate = %@", date)
        tableView.reloadData()
    }
    
    ///----------------------* Realm Methods *-----------------///
    
    
    
    @IBAction func todayButton(_ sender: Any) {
        let today = Date()
        self.calendarView.toggleViewWithDate(today)
    }
    
    @IBAction func segmentSwitch(_ sender: UISegmentedControl) {
        let width = view.frame.width
        let height = view.frame.height
        
        if sender.selectedSegmentIndex == 0 {
        
            calendarView.changeMode(.weekView)
            UIView.animate(withDuration: 0.3) {
                self.calendarView.frame = CGRect(x: 0, y: 59, width: width, height: 50)
                self.tableView.frame = CGRect(x: 0, y: 120, width: width, height: height)
            }
        }
        if sender.selectedSegmentIndex == 1 {
            
            calendarView.changeMode(.monthView)
            UIView.animate(withDuration: 0.3){
                self.calendarView.frame = CGRect(x: 0, y: 59, width: width, height: 350)
                self.tableView.frame = CGRect(x: 0, y: 360, width: width, height: height)
                
            }
        }
    }
    @IBAction func addButtonPressed(_ sender: Any) {

        let dateformatter = DateFormatter()
        dateformatter.dateFormat = " eee dd MMM YYYY"
        let dateToString = dateformatter.string(from: currentDate)
        let stringToDate = dateformatter.date(from: dateToString)
        
        
        var nameTextfield = UITextField()
        var workPlaceTextfield = UITextField()
        var positionTextfield = UITextField()
        var shiftStartTextfield = UITextField()
        var shiftEndTextfield = UITextField()
        var dutyTextfield = UITextField()
        
        let alert = UIAlertController(title: "Quick Add Shift", message: "Add Shift on \(dateToString)", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { (addAction) in
            if nameTextfield.text != "" && workPlaceTextfield.text != "" && positionTextfield.text != "" && shiftStartTextfield.text != "" && shiftEndTextfield.text != ""{
                let newShiftModel = ShiftDataToCalender()

                newShiftModel.shiftDate = self.currentDate
                newShiftModel.staff = nameTextfield.text!
                newShiftModel.workPlace = workPlaceTextfield.text!
                newShiftModel.position = positionTextfield.text!
                newShiftModel.shiftStart = shiftStartTextfield.text!
                newShiftModel.shiftEnd = shiftEndTextfield.text!
                newShiftModel.duty = dutyTextfield.text!
                
                self.saveShift(object: newShiftModel)
                
            }else{
                let blankAlert = UIAlertController(title: "⚠️", message: "Please complete all questions😎", preferredStyle: .actionSheet)
                let gotItAction = UIAlertAction(title: "Got it", style: .default, handler: { (gotItAction) in
                    self.present(alert,animated: true,completion: nil)
                })
                blankAlert.addAction(gotItAction)
                self.present(blankAlert,animated: true,completion: nil)
                
            }
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { (inputStaff) in
            inputStaff.placeholder = "Name of Staff"
            nameTextfield = inputStaff
        }
        alert.addTextField { (inputWorkplace) in
            inputWorkplace.placeholder = "Workplace Name"
            workPlaceTextfield = inputWorkplace
        }
        alert.addTextField { (inputPosition) in
            inputPosition.placeholder = "Position Name, such as Barista"
            positionTextfield = inputPosition
        }
        alert.addTextField { (inputShiftStart) in
            inputShiftStart.placeholder = "Ex: 1000"
            shiftStartTextfield = inputShiftStart
        }
        alert.addTextField { (inputShiftEnd) in
            inputShiftEnd.placeholder = "Ex: 2000"
            shiftEndTextfield = inputShiftEnd
        }
        alert.addTextField { (inputDuty) in
            inputDuty.placeholder = "Trainning First Day. (Optional)"
            dutyTextfield = inputDuty
        }
        
        present(alert,animated: true,completion: nil)
        
    }
    private var menuView: CVCalendarMenuView!
    
    private var calendarView: CVCalendarView!
    
    var tableView: UITableView!
    
    var currentCalendar: Calendar!
    
    var currentDate:Date = Date()
    
    var selectStaff:Results<ShiftDataToCalender>?
    
    var selectDateInString:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        print(Realm.Configuration.defaultConfiguration.fileURL)
        let width = view.frame.width
        let height = view.frame.height
        currentCalendar = Calendar.init(identifier: .gregorian)
        
        self.title = CVDate(date: Date(),calendar: currentCalendar).globalDescription
        
        self.menuView = CVCalendarMenuView(frame: CGRect(x: 0, y: 44, width: width, height: 15))
        self.calendarView = CVCalendarView(frame: CGRect(x: 0, y: 59, width: width, height: 50))
        tableView = UITableView(frame: CGRect(x: 0, y: 120, width: width, height: height ))
        
        //星期菜单栏代理
        self.menuView.menuViewDelegate = self
        
        //日历代理
        self.calendarView.calendarDelegate = self
        self.view.addSubview(menuView)
        self.view.addSubview(calendarView)
        
        self.view.addSubview(tableView)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: "cell")
        loadShift(selectDate: currentDate)
        
    }
    

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.menuView.commitMenuViewUpdate()
        self.calendarView.commitCalendarViewUpdate()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addVCbutton(_ sender: Any) {
         
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dateToAddShiftVC = segue.destination as? addShiftDetailVC{
        
            dateToAddShiftVC.selectDateFromCalendar = selectDateInString
        }
        
        
    }
}
extension CalendarVC: CVCalendarViewDelegate,CVCalendarMenuViewDelegate {
    //    shouldScrollOnOutDayViewSelection
    
    
    //视图模式
    func presentationMode() -> CalendarMode {
        //使用周视图
        //        isSelect ? .monthView : .weekView
        return .weekView
    }
    
    //每周的第一天
    func firstWeekday() -> Weekday {
        //从星期一开始
        return .monday
    }
    
    func presentedDateUpdated(_ date: CVDate) {
        //导航栏显示当前日历的年月
        self.title = date.globalDescription
    }
    
    //每个日期上面是否添加横线(连在一起就形成每行的分隔线)
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    //切换周的时候日历是否自动选择某一天（本周为今天，其它周为第一天）
    func shouldAutoSelectDayOnWeekChange() -> Bool {
        return true
    }
    
    //日期选择响应
    func didSelectDayView(_ dayView: CVCalendarDayView, animationDidFinish: Bool) {
        //        performSegue(withIdentifier: "addEvent", sender: self)
        //获取日期
        let date = dayView.date.convertedDate()!
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = "eee dd MMM YYYY"
        currentDate = date
        selectDateInString = "\(dformatter.string(from: date))"
        
        //将选择的日期弹出显示
        let alertController = UIAlertController(title: "", message: selectDateInString,
                                                preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        let addAction = UIAlertAction(title: "Add Shift", style:.default) { addAction in
//            self.performSegue(withIdentifier: "addEvent", sender: self)
        }
        alertController.addAction(addAction)
        //        self.present(alertController, animated: true, completion: nil)
        //        print("currentDate \(currentDate)")
        //        print("date \(date)")
        
        animateTable()
        loadShift(selectDate: currentDate)
    }
    //    func saveStaff(indexPath:Int,sortOf:String){
    //        if currentDate == staffDetail[indexPath][sortOf]{
    //            selectStaff.append(["name" : staffDetail[indexPath]["name"]!,
    //                                "shift": staffDetail[indexPath]["shift"]!,
    //                                "date":selectStaff[indexPath]["date"]!])
    //        }
    //    }
    func shouldShowWeekdaysOut() -> Bool {
        return false
    }
    func dayOfWeekTextColor(by weekday: Weekday) -> UIColor {
        return weekday == .sunday || weekday == .saturday ?
            .red : .black
    }
    
}

///--------------------* TableView Methods *----------------------///
extension CalendarVC:UITableViewDelegate,UITableViewDataSource,SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = SwipeTableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        
        ////not reUse cell
        
        cell.delegate = self
        
        guard let staff = selectStaff?[indexPath.row] else{ return cell }
        
        if currentDate == staff.shiftDate! {
            cell.textLabel?.text = "\(staff.staff), as a \(staff.position)"
            cell.detailTextLabel?.text = "\(staff.shiftStart) - \(staff.shiftEnd) @ \(staff.workPlace)"
        }else{
            cell.textLabel?.text = "No shift available today"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return selectStaff!.filter({ (shift) -> Bool in
        //
        //            return shift.date == self.currentDate
        //        }).count
        return selectStaff?.count ?? 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        
        return selectDateInString
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80/667 * view.frame.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        performSegue(withIdentifier: "addEvent", sender: self)
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "delete") { action, indexPath in
            // handle action by updating model with deletion
            if let staffForDeletion = self.selectStaff?[indexPath.row] {
                do{
                    try self.realm.write {
                        self.realm.delete(staffForDeletion)
                    }
                }catch{
                    print("Error deleting staff \(error)")
                }
            }
        }
        let editAction = SwipeAction(style: .default, title: "edit") { action, indexPath in
            
            if let shiftForEdit = self.selectStaff?[indexPath.row]{
                
                var editStaffName = UITextField()
                var editWorkPlace = UITextField()
                var editPosition = UITextField()
                var editShiftStart = UITextField()
                var editShiftEnd = UITextField()
                var editDuty = UITextField()
                
                
                let alert = UIAlertController(title: "Edit shift info.", message: "", preferredStyle: .alert)
                alert.addTextField { (inputStaffName) in
                    inputStaffName.text = shiftForEdit.staff
                    editStaffName = inputStaffName
                }
                alert.addTextField { (inputWorkPlace) in
                    inputWorkPlace.text = shiftForEdit.workPlace
                    editWorkPlace = inputWorkPlace
                }
                alert.addTextField { (inputPosition) in
                    inputPosition.text = shiftForEdit.position
                    editPosition = inputPosition
                }
                alert.addTextField { (inputShiftStart) in
                    inputShiftStart.text = shiftForEdit.shiftStart
                    editShiftStart = inputShiftStart
                }
                alert.addTextField { (inputShiftEnd) in
                    inputShiftEnd.text = shiftForEdit.shiftEnd
                    editShiftEnd = inputShiftEnd
                }
                alert.addTextField { (inputDuty) in
                    inputDuty.text = shiftForEdit.duty
                    editDuty = inputDuty
                }
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                let saveAction = UIAlertAction(title: "Save", style: .default) { (saveAction) in
                    
                    do{
                        try self.realm.write {
                            self.selectStaff?[indexPath.row].staff = editStaffName.text!
                            self.selectStaff?[indexPath.row].workPlace = editWorkPlace.text!
                            self.selectStaff?[indexPath.row].position = editPosition.text!
                            self.selectStaff?[indexPath.row].shiftStart = editShiftStart.text!
                            self.selectStaff?[indexPath.row].shiftEnd = editShiftEnd.text!
                            self.selectStaff?[indexPath.row].duty = editDuty.text!
                        }
                    }catch{
                        print("Error editing Category \(error)")
                    }
                    self.tableView.reloadData()
                }
                alert.addAction(saveAction)
                self.present(alert,animated: true, completion: nil)
            }
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        deleteAction.transitionDelegate = ScaleTransition.default
        deleteAction.backgroundColor = .clear
        deleteAction.textColor = .gray
        
        
        
        editAction.image = UIImage(named: "edit")
        editAction.transitionDelegate = ScaleTransition.default
        editAction.backgroundColor = .clear
        editAction.textColor = .gray
        
        return [deleteAction,editAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        
        options.expansionStyle = .destructive
        options.expansionDelegate = ScaleAndAlphaExpansion.default
        
        
        return options
    }
    
}
extension CalendarVC{
    func animateTable(){
        tableView.reloadData()
        let cells = tableView.visibleCells
        
        
        let tableViewWidth = tableView.bounds.size.width
        let tableviewHeight = tableView.bounds.size.height
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: tableViewWidth, y: 0)
        }
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 0.8, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
}




