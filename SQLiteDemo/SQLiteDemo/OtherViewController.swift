//
//  OtherViewController.swift
//  SQLiteDemo
//
//  Created by Mac on 16/12/10.
//  Copyright © 2016年 Mac. All rights reserved.
//

import UIKit

var insertCount : Int = 10000

class OtherViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var openTrans: UISwitch!
    @IBOutlet weak var openThread: UISwitch!
    @IBOutlet weak var openPrepare: UISwitch!
    
    var isSerting : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func startInsert(_ sender: Any) {
        
        if isSerting {
            showErrorText(message : "正在插入")
            return
        }
        isSerting = true
        
        //计算值
        let value : Int8 = isOnValue(sw: openTrans) * 100 + 10 * isOnValue(sw: openThread) + isOnValue(sw: openPrepare)
        
        print(NSString.init(format: "value - %03d", value))
        /*
         001 010 100 110 101 011 000 111
         */
        switch value {
        case 001:
            //开启了预编译
            insertDatas(true)
        case 010:
            //开启了子线程
            openChildThread()
        case 100:
            //开启了事务
            openTransaction()
        case 011:
            //开启了子线程 预编译
            openTheadAndPrepare()
        case 110:
            //开启了事务 子线程
            openTransAndTheard()
        case 101:
            //开启了事务 预编译
            openTransAndPrepare()
        case 111:
            //开启了事务 子线程 预编译
            openAll()
        default:
            //啥都没开
            insertDatas(false)
        }
        
    }
    
    /// 开启事务和预编译
    func openTransAndPrepare(){
        SQLManager.shareInstance().beginTransaction()
        insertDatas(true)
        SQLManager.shareInstance().commitTransaction()
    }
    
    /// 开启事务和线程
    func openTransAndTheard(){
        SQLManager.shareInstance().execQueueSQL { (manager) in
            self.insertDatas(false)
        }
    }
    
    //开启线程和预编译
    func openTheadAndPrepare(){
        SQLManager.shareInstance().execQueueSQL { (manager) in
            self.insertDatas(true)
        }
    }
    
    //全部打开
    func openAll(){
        SQLManager.shareInstance().execQueueSQL { (manager) in
            manager.beginTransaction()
            self.insertDatas(true)
            manager.commitTransaction()
        }
    }
    
    //开启子线程
    func openChildThread(){
        SQLManager.shareInstance().execQueueSQL { (manager) in
            self.insertDatas(false)
        }
    }
    
    //开启事务
    func openTransaction(){
        //获取数据库对象
        let manager = SQLManager.shareInstance()
        //开始事务
        manager.beginTransaction()
        //插入数据
        insertDatas(false)
        //提交事务
        manager.commitTransaction()
    }
    
    //插入数据
    private func insertDatas(_ prepare : Bool) {
        //得到开始时间
        let start = CFAbsoluteTimeGetCurrent()
        startLabel.text = "开始时间：\(start)"
        
        print(#function,"\(prepare ? "预编译" : "未开启预编译" )")
        
        //开始插入
        
        for index in 0..<insertCount {
            let name = "rand\(index)"
            let age = Int(arc4random() % 100 + 1)
            let money = Double(arc4random() % 10000) + Double(arc4random() % 100) * 0.01
            if prepare {
                //预编译
                let sql = "INSERT INTO T_Person (name,age,money) VALUES(?,?,?);"
                SQLManager.shareInstance().batchExecsql(sql, args: name,age,money)
            }
            else{
                //直接插入
                let sql = "INSERT INTO T_Person (name,age,money) VALUES('\(name)',\(age),\(money));"
                SQLManager.shareInstance().execSQL(sql: sql)
            }
            
        }
        
        
        //得到结束时间
        let end = CFAbsoluteTimeGetCurrent()
        endLabel.text = "结束时间：\(end)"
        
        //得出耗时
        timeLabel.text = "耗时：\(end - start)"
        
        isSerting = false
        
    }
    
    //计算当前是不是开启状态
    private func isOnValue(sw : UISwitch) -> Int8{
        return sw.isOn ? 1 : 0
    }
    
}
