//
//  ViewController.swift
//  SQLiteDemo
//
//  Created by Mac on 16/12/5.
//  Copyright © 2016年 Mac. All rights reserved.
//

import UIKit
let statuText = "当前状态："

class ViewController: UIViewController {

    let CellIdentifier = "CellIdentifier_ViewController"
    
    @IBOutlet weak var tableView: UITableView!
    var datas :[Person]?{
        didSet{
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: CellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        datas = Person.loadPersons()
    }
}


extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return datas?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as! TableViewCell
        
        cell.p = datas![indexPath.row]
        
        return cell
    }
}

/*
 override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
 
 //插入数据测试
 one()
 
 //取出数据测试
 two()
 }
 
 //取出
 func two(){
 let dicts = SQLManager.shareInstance().selectSQL(sql: "SELECT * FROM T_Person;")
 for dict in dicts {
 for (key,value) in dict {
 print(key)
 print(value)
 }
 }
 }
 
 //插入
 func one(){
 let p = Person(dict: ["name":"first",
 "age":15,
 "money":125.5])
 print(p.insertSQL())
 }
 */

