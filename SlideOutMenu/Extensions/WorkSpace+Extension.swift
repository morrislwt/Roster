//
//  WorkSpace+Extension.swift
//  SlideOutMenu
//
//  Created by Morris on 2018/4/21.
//  Copyright © 2018年 Morris. All rights reserved.
//

import UIKit
extension WorkSpacesVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workSpaces.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WorkSpaceCollectionViewCell
        
        let workspaceItem = workSpaces[indexPath.item]
        
        if let workspaceImage = UIImage(data: workspaceItem.image as! Data){
            cell.backgoundImage.image = workspaceImage
            
        }
        cell.workSpaceNameLabel.text = workspaceItem.placename
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 10, height: view.frame.height/5)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}
