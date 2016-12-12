//
//  UpdateViewController.swift
//  SQLiteDemo
//
//  Created by Mac on 16/12/8.
//  Copyright © 2016年 Mac. All rights reserved.
//

import UIKit

class UpdateViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let CellIdentifier = "CellIdentifier_ViewController"
    var datas :[Person] = Person.loadPersons()
        {
        didSet{
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: CellIdentifier)
    }

}

extension UpdateViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return datas.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as! TableViewCell
        
        cell.p = datas[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UpdateSet") as! UpdateSetViewController
        controller.indexPath = indexPath
        controller.personInfo = datas[indexPath.row]
        controller.reloadForIndexPath = {
            indexPath in
            self.tableView.reloadRows(at: [controller.indexPath!], with: UITableViewRowAnimation.automatic)
        }
        present(controller, animated: true, completion: nil)
    }
}
