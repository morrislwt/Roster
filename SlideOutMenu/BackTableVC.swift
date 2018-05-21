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
    var sideMenuIcons = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable()
    }
    override func viewDidLoad() {
        sideMenuOptions = ["Home",
                           "Work Place",
                           "Employees",
                           "Positions",
                           "Shift Template",
                           "Setting",
                           "Log Out"]
        
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
extension UITableViewController{
    func animateTable(){
        tableView.reloadData()
        let cells = tableView.visibleCells
        
        
        let tableViewWidth = tableView.bounds.size.width
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: -tableViewWidth, y: 0)
        }
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 0.8, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }

}

