//
//  BackTableVC.swift
//  SlideOutMenu
//
//  Created by Morris on 2018/4/20.
//  Copyright © 2018年 Morris. All rights reserved.
//

import Foundation
class BackTableVC:UITableViewController{
    var sideMenuOptions = [String]()
    override func viewDidLoad() {
        sideMenuOptions = ["Home","Setting","Log Out"]
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideMenuOptions.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:sideMenuOptions[indexPath.row], for: indexPath) as UITableViewCell
        cell.textLabel?.text = sideMenuOptions[indexPath.row]
        
        
        
        return cell
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        var destVC = segue.destination as! ViewController
//
//        var indexPath : IndexPath = self.tableView.indexPathForSelectedRow!
//
//        destVC.varView = indexPath.row
//    }
    
}

