//
//  AlertController + Extension.swift
//  Roster
//
//  Created by Morris on 2018/5/25.
//  Copyright © 2018年 Morris. All rights reserved.
//

import UIKit
import RealmSwift


extension UIAlertController {
    
    static func showAlert(alertTitle:String,alertMessage:String,defaultActionTitle:String,cancelTitle:String,in viewController:UIViewController,textfieldPlaceHolder:String,object:AddDataToRealm){
        var textField = UITextField()
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: defaultActionTitle, style: .default) { (defaultAction) in
            let newObject = object
            newObject.add(textField.text!)
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        alert.addTextField { (newTextfield) in
            newTextfield.placeholder = textfieldPlaceHolder
            newTextfield.autocapitalizationType = .words
            textField = newTextfield
        }
        viewController.present(alert,animated: true, completion: nil)
    }
    
    //在指定视图控制器上弹出确认框
    static func showConfirm(message: String, in viewController: UIViewController,
                            confirm: ((UIAlertAction)->Void)?) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: confirm))
        viewController.present(alert, animated: true)
    }
    
    //在根视图控制器上弹出确认框
    static func showConfirm(message: String, confirm: ((UIAlertAction)->Void)?) {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            showConfirm(message: message, in: vc, confirm: confirm)
        }
    }
}
