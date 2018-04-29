//
//  WorkSpaceVC.swift
//  SlideOutMenu
//
//  Created by Morris on 2018/4/20.
//  Copyright © 2018年 Morris. All rights reserved.
//


import UIKit
import RealmSwift

class WorkSpacesVC:UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet weak var workspaceCollectionView: UICollectionView!
    
    let realm = try! Realm()
    var workSpaces:Results<WorkSpaceData>?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        loadData()
        
    }
    
    func loadData(){
        workSpaces = realm.objects(WorkSpaceData.self)
        workspaceCollectionView.reloadData()
    }
    
    func saveData(dataFromWS: WorkSpaceData){
        do{
            try realm.write {
                realm.add(dataFromWS)
            }
        }catch{
            print("Error saving WorkSpace \(error)")
        }
        workspaceCollectionView.reloadData()
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
            textField = addNewTextField
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (UIAlertAction) in
            
            let newPlace = WorkSpaceData()
            newPlace.placename = textField.text!
            self.saveData(dataFromWS: newPlace)
        }))
        
        present(alert,animated: true, completion: nil)
        
        
        
        
        
        
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
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

}

