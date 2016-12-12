//
//  DeleteViewController.swift
//  SQLiteDemo
//
//  Created by Mac on 16/12/8.
//  Copyright © 2016年 Mac. All rights reserved.
//

import UIKit

class DeleteViewController: UIViewController {
    @IBOutlet weak var statuLabel: UILabel!
    @IBOutlet weak var idTextfield: UITextField!

    @IBOutlet weak var moneyTextfield: UITextField!
    @IBOutlet weak var ageTextfield: UITextField!
    @IBOutlet weak var nameTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func deleteData(_ sender: UIButton) {
        
        
        var dict = [Person_Property : Any?]()
        dict[.id] = idTextfield.text
        dict[.name] = nameTextfield.text
        dict[.age] = ageTextfield.text
        dict[.money] = moneyTextfield.text
        
        let p = Person(myDict : dict)
        
        if p.deleteSQL(){
            statuLabel.text = statuText + "删除成功"
        }
        else{
            statuLabel.text = statuText + "删除失败"
        }
        

    }

}
