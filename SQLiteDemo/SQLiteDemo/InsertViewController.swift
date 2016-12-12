//
//  InsertViewController.swift
//  SQLiteDemo
//
//  Created by Mac on 16/12/8.
//  Copyright © 2016年 Mac. All rights reserved.
//

import UIKit



class InsertViewController: UIViewController {
    @IBOutlet weak var idTextfield: UITextField!
    @IBOutlet weak var moneyTextfield: UITextField!
    @IBOutlet weak var ageTextfield: UITextField!
    @IBOutlet weak var nameTextfield: UITextField!
    
    @IBOutlet weak var status: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func insertDatas(_ sender: Any) {
        for index in 0..<10 {
            var dict = [String : Any]()
            dict["name"] = "rand\(index)"
            dict["age"] = Int(arc4random()%100 + 1)
            dict["money"] = Double(arc4random() % 100000)  +  Double(Double(arc4random() % 100) * 0.1)
            let p = Person(dict: dict)
            if !p.insertSQL(){
                print(p)
                status.text = statuText + "插入失败"
                return
            }
        }
        status.text = statuText + "成功插入10条数据"
    }
    
    @IBAction func insertData(_ sender: UIButton) {
        //名字为空 不能插入
        if nameTextfield.text?.characters.count == 0 {
            status.text = statuText + "姓名不能为空"
            return
        }

        //通过textField创建对象
        var dict = [String : Any]()
        //如果id输入了，就插入ID，否则自增长
        if idTextfield.text?.characters.count != 0{
            if idTextfield.text!.isAllNum() { //判断是不是纯数字
                dict["id"] = (idTextfield.text! as NSString).intValue
            }
        }
        
        //名字直接添加
        dict["name"] = nameTextfield.text!
        
        //如果输入了年龄并且是纯数字才添加
        if ageTextfield.text?.characters.count != 0 {
            if ageTextfield.text!.isAllNum() { //判断是不是纯数字
                dict["age"] = (ageTextfield.text! as NSString).intValue
            }
        }
        
        
        if moneyTextfield.text?.characters.count != 0 {
            let double : Double = (moneyTextfield.text! as NSString).doubleValue
            if double > 0{
                dict["money"] = double
            }
        }
        
        let p = Person(dict: dict)
        if !p.insertSQL() {
            status.text = statuText + "插入失败"
        }else{
            status.text = statuText + "插入成功"
        }
    }

}
