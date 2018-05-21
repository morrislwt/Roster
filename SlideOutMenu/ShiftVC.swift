//
//  File.swift
//  Roster
//
//  Created by Morris on 2018/5/6.
//  Copyright © 2018年 Morris. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit


class ShiftVC:UIViewController,UITableViewDataSource,UITableViewDelegate{

    @IBAction func backSegue(_ segue:UIStoryboardSegue){
        
    }

    @IBOutlet weak var shiftTemplateTableView: UITableView!
    var shiftTemplate:Results<shiftTemplateData>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        loadData()
        
        shiftTemplateTableView.tableFooterView = UIView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable()
    }
    func loadData(){
        shiftTemplate = realm.objects(shiftTemplateData.self)
        shiftTemplateTableView.reloadData()
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    


}
extension ShiftVC{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shiftTemplate?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        

        if let shiftData = shiftTemplate{
            cell.textLabel?.text = shiftData[indexPath.row].shiftTemplateName
            cell.detailTextLabel?.text = "\(shiftData[indexPath.row].shiftTimeStart) - \(shiftData[indexPath.row].shiftTimeEnd)"
            cell.textLabel?.font = UIFont(name: "Courier", size: 20)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            self.updateModel(indexPath: indexPath)
            tableView.deleteRows(at: [indexPath], with: .right)
        }
        
//        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
//            // share item at indexPath
//            print("edit")
//        }
//        edit.backgroundColor = UIColor.lightGray
//        delete.backgroundColor = UIColor(patternImage: UIImage(named: "delete")!)
        
        
        return [delete]
        
    }
    
    func updateModel(indexPath:IndexPath){
        if let shiftForDeletion = shiftTemplate?[indexPath.row]{
            deleteModel(itemForDelete: shiftForDeletion)
        }
    }
    func deleteModel(itemForDelete:Object){
            do{
                try realm.write {
                    realm.delete(itemForDelete)
                }
            }catch{
                print("Error deleting shift, \(error)")
        }
    }

    func animateTable(){
        shiftTemplateTableView.reloadData()
        let cells = shiftTemplateTableView.visibleCells
        
        
        let tableViewHeight = shiftTemplateTableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
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
