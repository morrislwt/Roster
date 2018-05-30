////
////  ViewController.swift
////  SlideOutMenu
////
////  Created by Morris on 2018/4/20.
////  Copyright © 2018年 Morris. All rights reserved.
////
//
//import UIKit
//
//class ViewController: UIViewController {
//
//
//
//    @IBOutlet weak var label: UILabel!
//    @IBOutlet weak var Open: UIBarButtonItem!
//    
//    var varView = Int()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        Open.target = self.revealViewController()
//        Open.action = #selector(SWRevealViewController.revealToggle(_:))
//        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//        
//        switch varView {
//        case 0:
//            label.text = "Home"
//        case 1:
//            label.text = "Setting"
//        case 2:
//            label.text = "Log Out"
//        default:
//            break
//        }
//        
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//
//}
//
