//
//  LimitViewController.swift
//  SQLiteDemo
//
//  Created by Mac on 16/12/8.
//  Copyright © 2016年 Mac. All rights reserved.
//

import UIKit

class LimitViewController: UIViewController {
    
    var datas :[Person]?{
        didSet{
            tableView.reloadData()
        }
    }
    let CellIdentifier = "CellIdentifier_LimitViewController"
    var index = 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: CellIdentifier)
    }
    
    private func limitDatas(m : Int32, n:Int32){
        let pdatas = Person.queryLimitPerson(m : m , n: n)
        if pdatas.count == 0{
            showErrorText()
            return
        }
        
        datas = pdatas
    }
    
    @IBAction func startLimitBtn(_ sender: UIButton) {
        index = 0
        limitDatas(m: Int32(index) * (textField.text! as NSString).intValue, n: (textField.text! as NSString).intValue)
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        index += 1
        limitDatas(m: Int32(index) * (textField.text! as NSString).intValue, n: (textField.text! as NSString).intValue)
    }
    
    @IBAction func preBtn(_ sender: Any) {
        index = (index - 1) < 0 ? 0 : (index - 1)
        limitDatas(m: Int32(index) * (textField.text! as NSString).intValue, n: (textField.text! as NSString).intValue)
    }
}

extension LimitViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return datas?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as! TableViewCell
        
        cell.p = datas![indexPath.row]
        
        return cell
    }
}
