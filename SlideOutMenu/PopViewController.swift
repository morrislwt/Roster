//
//  PopViewController.swift
//  Roster
//
//  Created by Morris on 2018/5/13.
//  Copyright © 2018年 Morris. All rights reserved.
//

import UIKit

class PopViewController: UIViewController, UITableViewDataSource,UITableViewDelegate{
    
    let options = ["Quick Add","Add Full Shift"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}
