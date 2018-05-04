//
//  SettingVC.swift
//  SlideOutMenu
//
//  Created by Morris on 2018/4/30.
//  Copyright © 2018年 Morris. All rights reserved.
//

import UIKit

class SettingVC:UIViewController,UITableViewDelegate,UITableViewDataSource {
    let settingOption = ["Backgound Color","Time Format","Language"]
    @IBOutlet weak var settingTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTableView.tableFooterView = UIView()
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingOption.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = settingOption[indexPath.row]
        
        
        return cell
    }
    
}
