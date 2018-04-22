//
//  WorkSpaceVC.swift
//  SlideOutMenu
//
//  Created by Morris on 2018/4/20.
//  Copyright © 2018年 Morris. All rights reserved.
//

import UIKit
import CoreData



class WorkSpacesVC:UIViewController{
    @IBAction func addWorkSpace(_ sender: Any) {
    }
    @IBOutlet weak var workSpaceCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
}
