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

class CalendarVC: UIViewController,UIPopoverPresentationControllerDelegate{
    var weekBtnTap:Bool = true
    @IBOutlet weak var yellowOutlet: UIView!
    @IBOutlet weak var yellowLeading: NSLayoutConstraint!
    @IBOutlet weak var scheduleOutlet: UILabel!
    @IBOutlet weak var weekOutlet: UIButton!
    @IBOutlet weak var monthOutlet: UIButton!
    @IBAction func toWeek(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.monthOutlet.backgroundColor = .clear
            self.weekOutlet.backgroundColor = .gray
            
            self.weekOutlet.setTitleColor(.lightText, for: .normal)
            self.monthOutlet.setTitleColor(.gray, for: .normal)
        }
        
        let width = view.frame.width
        let height = view.frame.height
        let weekTableViewFrame = CGRect(x: width/2 - width*0.9/2, y: 150, width: width * 0.9, height: height - 135)
        calendarView.changeMode(.weekView)
        UIView.animate(withDuration: 0.3) {
            self.calendarView.frame = CGRect(x: 0, y: 85, width: width, height: 50)
            self.tableView.frame = weekTableViewFrame
            self.tableView.layer.cornerRadius = 20
        }
        
    }
    @IBAction func toMonth(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.monthOutlet.backgroundColor = .gray
            self.weekOutlet.backgroundColor = .clear
            self.monthOutlet.setTitleColor(.lightText, for: .normal)
            self.weekOutlet.setTitleColor(.gray, for: .normal)
        }
        
        let width = view.frame.width
        let height = view.frame.height
        let monthTableViewFrame = CGRect(x: width/2 - width*0.9/2, y: 380, width: width * 0.9, height: height - 400)
        calendarView.changeMode(.monthView)
        UIView.animate(withDuration: 0.3){
            self.calendarView.frame = CGRect(x: 0, y: 85, width: width, height: 350)
            self.tableView.frame = monthTableViewFrame
            self.tableView.layer.cornerRadius = 50
            
        }
    }
    
    @IBOutlet weak var todayOutlet: UIButton!
    
    @IBAction func todayBtnTap(_ sender: UIButton) {
        let today = Date()
        self.calendarView.toggleViewWithDate(today)
    }
    var selectedIndexFromPopOver = 2
    var selectedIndexPath:Int?
    
    @IBAction func backToCalSegue(_ segue:UIStoryboardSegue){
        
    }
    @IBOutlet weak var moreBtnOutlet: UIButton!
    
    @IBAction func moreBtnTap(_ sender: UIButton) {
        performSegue(withIdentifier: "popOver", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dateToAddShiftVC = segue.destination as? addShiftDetailVC{
            
            dateToAddShiftVC.selectDateFromCalendar = selectDateInString
            dateToAddShiftVC.selectDateInDateType = currentDate
        }
        if segue.identifier == "popOver" {
            if let vc = segue.destination as? UIViewController {
                vc.preferredContentSize = CGSize(width: (view.frame.width) * 200/view.frame.width, height: (view.frame.height) * 100/view.frame.height)
                let controller = vc.popoverPresentationController
                if controller != nil {
                    controller?.delegate = self
                }
            }
        }
        if segue.identifier == "showShiftDetail" {
            if let vc = segue.destination as? ShowShiftDetailVC {
                vc.selectIndexFromCal = selectedIndexPath
                vc.selectDateInString = selectDateInString
                vc.currentDate = currentDate
            }
        }
        
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    
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
    
    //MARK: Realm method
    
    
    private var menuView: CVCalendarMenuView!
    
    private var calendarView: CVCalendarView!
    
    var tableView: UITableView!
    
    var currentCalendar: Calendar!
    
    var currentDate:Date = Date()
    
    var selectStaff:Results<ShiftDataToCalender>?
    
    var selectDateInString:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yellowOutlet.layer.cornerRadius = 20
        yellowOutlet.clipsToBounds = true
        monthOutlet.cornerRadius = 10
        weekOutlet.cornerRadius = 10
        let width = view.frame.width
        let height = view.frame.height
        currentCalendar = Calendar.init(identifier: .gregorian)
        
        self.title = CVDate(date: Date(),calendar: currentCalendar).globalDescription
        
        self.menuView = CVCalendarMenuView(frame: CGRect(x: 0, y: 65, width: width, height: 15))
        self.calendarView = CVCalendarView(frame: CGRect(x: 0, y: 85, width: width, height: 50))
        
        let frame = CGRect(x: width/2 - width*0.9/2, y: 150, width: width * 0.9, height: height - 135)
        tableView = UITableView.init(frame: frame, style: .grouped)
        tableView.layer.cornerRadius = 20
        tableView.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 241/255, alpha: 0.9)
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
        //        tableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        loadShift(selectDate: currentDate)
        
        NotificationCenter.default.addObserver(forName: .selectedIndex, object: nil, queue: OperationQueue.main) { (notification) in
            let popVC = notification.object as! PopViewController
            self.selectedIndexFromPopOver = popVC.selectedIndex
            if self.selectedIndexFromPopOver == 0 {
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = " eee dd MMM YYYY"
                
                let dateToString = dateformatter.string(from: self.currentDate)
                //        let stringToDate = formatter.date(from: dateToString)
                
                
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
                        let timeFormatter = DateFormatter()
                        timeFormatter.dateFormat = "HH:mm"
                        let calendar = Calendar.current
                        let unit:Set<Calendar.Component> = [.hour,.minute]
                        let startTime = timeFormatter.date(from: shiftStartTextfield.text!)
                        let endTime = timeFormatter.date(from: shiftEndTextfield.text!)
                        let commponent:DateComponents = calendar.dateComponents(unit, from: endTime!, to: startTime!)
                        newShiftModel.totalWorkMinutes = abs(commponent.hour!*60) + abs(commponent.minute!)
                        
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
                alert.view.tintColor = .gray
                alert.addTextField { (inputStaff) in
                    inputStaff.placeholder = "Name of Staff"
                    inputStaff.autocorrectionType = .yes
                    nameTextfield = inputStaff
                }
                alert.addTextField { (inputWorkplace) in
                    inputWorkplace.placeholder = "Workplace Name"
                    inputWorkplace.autocorrectionType = .yes
                    workPlaceTextfield = inputWorkplace
                }
                alert.addTextField { (inputPosition) in
                    inputPosition.placeholder = "EX: Barista"
                    inputPosition.autocorrectionType = .yes
                    positionTextfield = inputPosition
                }
                alert.addTextField { (inputShiftStart) in
                    inputShiftStart.placeholder = "Ex: 10:00"
                    inputShiftStart.keyboardType = .numberPad
                    shiftStartTextfield = inputShiftStart
                }
                alert.addTextField { (inputShiftEnd) in
                    inputShiftEnd.placeholder = "Ex: 20:00"
                    inputShiftEnd.keyboardType = .numberPad
                    shiftEndTextfield = inputShiftEnd
                }
                alert.addTextField { (inputDuty) in
                    inputDuty.placeholder = "Trainning First Day. (Optional)"
                    inputDuty.autocorrectionType = .yes
                    dutyTextfield = inputDuty
                }
                
                self.present(alert,animated: true,completion: nil)
            }
            if self.selectedIndexFromPopOver == 1 {
                self.performSegue(withIdentifier: "addFullShift", sender: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1) {
            self.yellowLeading.constant = -20
            self.view.layoutIfNeeded()
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.yellowLeading.constant = -400
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.menuView.commitMenuViewUpdate()
        self.calendarView.commitCalendarViewUpdate()
        //
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addVCbutton(_ sender: Any) {
        
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
        }
        alertController.addAction(addAction)
        
        
        animateTable()
        loadShift(selectDate: currentDate)
    }
    
    func shouldShowWeekdaysOut() -> Bool {
        return false
    }
    func dayOfWeekTextColor(by weekday: Weekday) -> UIColor {
        return weekday == .sunday || weekday == .saturday ?
            .red : .black
    }
    
}

///--------------------* TableView Methods *----------------------///
extension CalendarVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        ////not reuse cell
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        if selectStaff?.count == 0 {
            tableView.separatorStyle = .none
            cell.textLabel?.text = "Looks like no shift today 🤔"
            cell.textLabel?.textColor = .darkGray
            cell.backgroundColor = .clear
        }
        if (selectStaff?.count)! > 0 {
            guard let staff = selectStaff?[indexPath.row] else{ return cell }
            
            if currentDate == staff.shiftDate! {
                cell.textLabel?.text = "\(staff.staff)"
                cell.backgroundColor = .clear
                cell.detailTextLabel?.text = "\(staff.shiftStart) - \(staff.shiftEnd) @ \(staff.workPlace)"
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return selectStaff!.filter({ (shift) -> Bool in
        //
        //            return shift.date == self.currentDate
        //        }).count
        if selectStaff?.count == 0 {
            return 1
        }
        return selectStaff?.count ?? 1
    }
    
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        let title: UILabel = UILabel()
    //        title.text = selectDateInString
    //        title.backgroundColor = .clear
    //        title.textAlignment = .center
    //        title.textColor = UIColor(red: 0/255, green: 100/255, blue: 159/255, alpha: 1)
    //        title.font = UIFont.boldSystemFont(ofSize: 18)
    //
    //        return title
    //    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return selectDateInString
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80/667 * view.frame.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndexPath = indexPath.row
        guard let numbersOfStaff = selectStaff?.count else { return }
        guard numbersOfStaff > 0 else { return }
        performSegue(withIdentifier: "showShiftDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if selectStaff?.count == 0{
            return false
        }else{
            return true
        }
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            tableView.reloadRows(at: [indexPath], with: .middle)
            self.updateModel(at: indexPath)
//            tableView.deleteRows(at: [indexPath], with: .right)
        }
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            self.editModel(at: indexPath)
        }
        edit.backgroundColor = .lightGray
        return [delete,edit]
     
    }
    
    
    func updateModel(at indexPath: IndexPath){
        if let calendarData = self.selectStaff?[indexPath.row] {
            deleteModel(itemForDelete: calendarData)
        }
    }
    func deleteModel(itemForDelete:Object){
        do{
            try realm.write {
                realm.delete(itemForDelete)
            }
        }catch{
            print("Error deleting item, \(error)")
        }
        loadShift(selectDate: currentDate)
        tableView.reloadData()
        
    }
    func editModel(at indexPath: IndexPath){
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
