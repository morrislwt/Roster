//
//  addShiftDetailVC.swift
//  Roster
//
//  Created by Morris on 2018/5/6.
//  Copyright © 2018年 Morris. All rights reserved.
//

import Foundation

class addShiftDetailVC: UIViewController {
    
    
    @IBOutlet weak var addShiftCollectionView: UICollectionView!
    
    var selectDateFromCalendar:String?
    
    let addShiftOptions = ["Date","Staff","Work Place","Shift Start","Shift End","Break Time","Total time","Duty"]
    
    @IBAction func saveButton(_ sender: Any) {
    }
    
    @IBOutlet weak var saveButtonOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add New Shift"
        saveButtonOutlet.layer.cornerRadius = 20
        saveButtonOutlet.clipsToBounds = true

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
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AddShiftCollectionViewCell
        if indexPath.item == 0 {
            
            cell.datePicker.isHidden = false
            
        }
        collectionView.reloadData()
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
        if indexPath.item == 3 {
            return CGSize(width: smallWidth, height: height)
        }
        if indexPath.item == 4 {
            return CGSize(width: smallWidth, height: height)
        }
        if indexPath.item == 5 {
            return CGSize(width: smallWidth, height: height)
        }
        return CGSize(width: width , height: height)
    }
    
}
