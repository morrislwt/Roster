//
//  WorkSpaceVC.swift
//  SlideOutMenu
//
//  Created by Morris on 2018/4/20.
//  Copyright © 2018年 Morris. All rights reserved.
//


import UIKit
import RealmSwift
import SwipeCellKit

class WorkSpacesVC:UIViewController,UITableViewDelegate,UITableViewDataSource,SwipeTableViewCellDelegate{
    
    
    
    @IBOutlet weak var workSpaceTableView: UITableView!
    let realm = try! Realm()
    var workSpaces:Results<WorkSpaceData>?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        loadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable()
    }
    
    func loadData(){
        workSpaces = realm.objects(WorkSpaceData.self)
        workSpaceTableView.reloadData()
    }
    
    func saveData(dataFromWS: WorkSpaceData){
        do{
            try realm.write {
                realm.add(dataFromWS)
            }
        }catch{
            print("Error saving WorkSpace \(error)")
        }
        workSpaceTableView.reloadData()
    }
    
    
    @IBAction func addWorkSpace(_ sender: Any) {
//        let imagePicker = UIImagePickerController()
//        imagePicker.sourceType = .photoLibrary
//        imagePicker.delegate = self
//        //按下 + 跳出imagePicker
//        self.present(imagePicker, animated: true, completion: nil)
        var textField = UITextField()
        
        let alert = UIAlertController(title: "New WorkSpace", message: "Enter a new space", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField { (addNewTextField) in
            addNewTextField.placeholder = "a place name"
            addNewTextField.autocapitalizationType = .words
            addNewTextField.autocorrectionType = .yes
            textField = addNewTextField
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (UIAlertAction) in
            
            let newPlace = WorkSpaceData()
            newPlace.placename = textField.text!
            self.saveData(dataFromWS: newPlace)
        }))
        
        present(alert,animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        cell.textLabel?.text = workSpaces?[indexPath.row].placename ?? "No place add yet"
        cell.textLabel?.font = UIFont(name: "Courier", size: 20)
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workSpaces?.count ?? 1
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "delete") { action, indexPath in
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func updateModel(at indexPath: IndexPath){
        if let workSpaceForDeletion = self.workSpaces?[indexPath.row] {
            deleteModel(itemForDelete: workSpaceForDeletion)
        }
        //update our data model
    }
    func editModel(at indexPath: IndexPath){
        if let workSpaceForEdit = workSpaces?[indexPath.row].placename{
            var editText = UITextField()
            
            let alert = UIAlertController(title: "Edit", message: "Change the name of this Place", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.text = workSpaceForEdit
                editText = textField
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            let saveAction = UIAlertAction(title: "Save", style: .default) { (saveAction) in
                
                do{
                    try self.realm.write {
                        self.workSpaces?[indexPath.row].placename = editText.text!
                    }
                }catch{
                    print("Error editing Category \(error)")
                }
                self.workSpaceTableView.reloadData()
            }
            alert.addAction(saveAction)
            present(alert,animated: true, completion: nil)
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
    }
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//
//        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
//            picker.dismiss(animated: true, completion: {
//                self.createPresentItem(with: image)
//            })
//        }
//    }
    
    
//    func createPresentItem(with image:UIImage){
//        let workspaceItem = WorkSpaceData()
//        workspaceItem.image = NSData(data: UIImageJPEGRepresentation(image, 0.3)!)
//
//
//        let inputAlert = UIAlertController(title: "New Workspace", message: "Enter a space name.", preferredStyle: .alert)
//        inputAlert.addTextField { (textfield:UITextField) in
//            textfield.placeholder = "Worspace name"
//        }
//
//        inputAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: {(
//            action:UIAlertAction) in
//
//
//            let spaceTextField = inputAlert.textFields?.first
//
//            if spaceTextField?.text != "" {
//                workspaceItem.placename = spaceTextField?.text
//                do{
//                   try self.managedObjectContext.save()
//                    self.loadData()
//                }catch{
//                    print("Could not save data \(error.localizedDescription)")
//                }
//            }
//        }))
//        inputAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//        self.present(inputAlert, animated: true, completion: nil)
//    }
    
    func animateTable(){
        workSpaceTableView.reloadData()
        let cells = workSpaceTableView.visibleCells
        
        
        
        let tableViewHeight = workSpaceTableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 1.5, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }

}

