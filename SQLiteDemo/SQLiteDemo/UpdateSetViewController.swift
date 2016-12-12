//
//  UpdateSetViewController.swift
//  SQLiteDemo
//
//  Created by Mac on 16/12/9.
//  Copyright © 2016年 Mac. All rights reserved.
//

import UIKit

class UpdateSetViewController: UIViewController {

    var indexPath : IndexPath?
    var personInfo : Person?
    var reloadForIndexPath : ((_ indexPath : IndexPath) -> Void )?
    
    @IBOutlet weak var moneyTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var statuLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let p = personInfo {
            infoLabel.text = "当前信息：\n" + "id = \(p.id)\n" + "name = \(p.name!)\n" + "age = \(p.age)\n" + "money = \(p.money)"
            nameTF.text = p.name!
            ageTF.text = "\(p.age)"
            moneyTF.text = "\(p.money)"
        }
    }
    @IBAction func close(_ sender: Any) {
        if let block = reloadForIndexPath {
            block(indexPath!)
        }
        dismiss(animated: true, completion: nil)
    }

    @IBAction func updateBtn(_ sender: UIButton) {
        
        let name = nameTF.text
        if name?.characters.count != 0 {
            personInfo?.name = name
        }
        
        let age = ageTF.text
        if age?.characters.count != 0 && age!.isAllNum() {
            personInfo?.age = age!.intValue()
        }
        
        let money = moneyTF.text
        if money?.characters.count != 0 && money!.isFloatValue() {
            personInfo?.money = money!.doubleValue()
        }
        let str = personInfo!.updateSQL() ? "更新成功" : "更新失败"
        statuLabel.text = statuText + str
    }
}
