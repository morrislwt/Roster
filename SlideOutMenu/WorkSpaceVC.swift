//
//  WorkSpaceVC.swift
//  SlideOutMenu
//
//  Created by Morris on 2018/4/20.
//  Copyright © 2018年 Morris. All rights reserved.
//

import UIKit
import CoreData



class WorkSpacesVC:UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet weak var workspaceCollectionView: UICollectionView!
    var workSpaces = [WorkSpace]()
    var managedObjectContext:NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        loadData()
    }
    func loadData(){
        let workSpaceRequest:NSFetchRequest<WorkSpace> = WorkSpace.fetchRequest()
        
        do{
           workSpaces = try managedObjectContext.fetch(workSpaceRequest)
            self.workspaceCollectionView.reloadData()

        }catch{
            print("Could not load data from Database \(error.localizedDescription)")
        }
    }
    
    
    @IBAction func addWorkSpace(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        //按下 + 跳出imagePicker
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            picker.dismiss(animated: true, completion: {
                self.createPresentItem(with: image)
            })
        }
    }
    
    
    func createPresentItem(with image:UIImage){
        let workspaceItem = WorkSpace(context: managedObjectContext)
        workspaceItem.image = NSData(data: UIImageJPEGRepresentation(image, 0.3)!) as Data
        
        
        let inputAlert = UIAlertController(title: "New Workspace", message: "Enter a space name.", preferredStyle: .alert)
        inputAlert.addTextField { (textfield:UITextField) in
            textfield.placeholder = "Worspace name"
        }
        
        inputAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: {(
            action:UIAlertAction) in
            ////last 是只有一個input的時候
    
            let spaceTextField = inputAlert.textFields?.last
            
            if spaceTextField?.text != "" {
                workspaceItem.placename = spaceTextField?.text
                do{
                   try self.managedObjectContext.save()
                    self.loadData()
                }catch{
                    print("Could not save data \(error.localizedDescription)")
                }
            }
        }))
        inputAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(inputAlert, animated: true, completion: nil)
    }
    
}
