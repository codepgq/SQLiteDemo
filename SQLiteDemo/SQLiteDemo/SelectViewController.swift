//
//  SelectViewController.swift
//  SQLiteDemo
//
//  Created by Mac on 16/12/8.
//  Copyright © 2016年 Mac. All rights reserved.
//

import UIKit

class SelectViewController: UIViewController {

    var datas :[Person]?{
        didSet{
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    let CellIdentifier = "CellIdentifier_SelectViewController"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: CellIdentifier)
    }
    
    @IBAction func selectDatas(_ sender: Any) {
        let persons = Person.queryPersons(condition: textView.text)
        if persons.count == 0 {
            showErrorText()
        }
        datas = persons
    }
}

extension SelectViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return datas?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as! TableViewCell
        
        cell.p = datas![indexPath.row]
        
        return cell
    }
}
