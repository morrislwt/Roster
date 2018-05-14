//
//  PopViewController.swift
//  Roster
//
//  Created by Morris on 2018/5/13.
//  Copyright © 2018年 Morris. All rights reserved.
//

import UIKit

class PopViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,UIPopoverPresentationControllerDelegate{
    
    @IBOutlet weak var popOverTableView: UITableView!
    
    var selectedIndex = 2
    let options = ["Quick Add","Add Full Shift"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        if indexPath.row == 0 {
            selectedIndex = 0
            
        }
        if indexPath.row == 1 {
            selectedIndex = 1
        }
        NotificationCenter.default.post(name: .selectedIndex, object: self)
        
    }
    func dismiss(){
        self.dismiss(animated: true, completion: nil)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if let vc = segue.destination as? CalendarVC {
//            vc.selectedIndexFromPopOver = selectedIndex
//
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        popOverTableView.isScrollEnabled = false
        popOverTableView.separatorStyle = .none
    }


}
