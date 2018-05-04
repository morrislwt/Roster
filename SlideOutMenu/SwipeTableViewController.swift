//
//  SwipeTableViewController.swift
//  SlideOutMenu
//
//  Created by Morris on 2018/4/29.
//  Copyright © 2018年 Morris. All rights reserved.
//

import Foundation
import RealmSwift
import SwipeCellKit

class SwipeTableViewController: UITableViewController,SwipeTableViewCellDelegate{
    let realm = try! Realm()
    
    var cell:UITableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.separatorStyle = .none
//        tableView.tableFooterView = UIView()
//        tableView.rowHeight = 80.0
//        tableView.backgroundColor = .lightGray
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable()
        
        
    }
    
    
    
    //MARK: - tableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .default, title: "delete") { action, indexPath in
            // handle action by updating model with deletion
            self.updateModel(at: indexPath)
        }
        let editAction = SwipeAction(style: .default, title: "edit") { action, indexPath in
            self.editModel(at: indexPath)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        deleteAction.backgroundColor = .clear
        deleteAction.transitionDelegate = ScaleTransition.default
        deleteAction.textColor = .gray
        
        editAction.transitionDelegate = ScaleTransition.default
        editAction.textColor = .gray
        editAction.image = UIImage(named: "edit")
        editAction.backgroundColor = .clear
        
        return [deleteAction,editAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        
        options.expansionStyle = .destructive
        options.expansionDelegate = ScaleAndAlphaExpansion.default
        return options
    }
    
    func updateModel(at indexPath: IndexPath){
        //update our data model
    }
    func editModel(at indexPath: IndexPath){
        
    }
    func deleteModel(itemForDelete:Object){
        do{
            try realm.write {
                realm.delete(itemForDelete)
            }
        }catch{
            print("Error deleting item, \(error)")
        }
    }
}
