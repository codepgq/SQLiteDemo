//
//  Person.swift
//  SQLiteDemo
//
//  Created by Mac on 16/12/5.
//  Copyright © 2016年 Mac. All rights reserved.
//

import UIKit

enum Person_Property : NSString {
    case id = "id"
    case name = "name"
    case age = "age"
    case money = "money"
}

class Person: NSObject {
    var id : Int = -1
    var name : String?
    var age : Int = -1
    var money : Double = -1
    
    
    override var description: String{
        return ""
    }

    
    /// 插入
    func insertSQL() -> Bool{
        
        //断言
        assert(name != nil, "姓名不能为空")
        
        //1、编写SQL语句
        //如果插入的是可选的，那么你会发现你插入的前面有一个Optional，这是很尴尬的事情，
        //可以通过 ！ 解决
        
        var sql : String = ""
        if id == -1 {
            sql = "INSERT INTO T_Person (name,age,money) VALUES('\(name!)',\(age == -1 ? 0 : age),\(money == -1 ? 100.0 : money));"
        }
        else{
            sql = "INSERT INTO T_Person (id,name,age,money) VALUES(\(id),'\(name!)',\(age == -1 ? 0 : age),\(money == -1 ? 100.0 : money));"
        }
        //3、执行语句
        return SQLManager.shareInstance().execSQL(sql: sql)
        
    }
    
    /// 更新
    func updateSQL() -> Bool{
        //断言
        assert(name != nil, "姓名不能为空")
        
        //1、编写SQL语句
        let sql = "UPDATE T_Person \n" +
                    "SET name='\(name!)',age=\(age),money=\(money) \n" +
                    "WHERE id=\(id);";
        
        //3、执行语句
        return SQLManager.shareInstance().execSQL(sql: sql)
    }
    
    /// 删除
    func deleteSQL() -> Bool{
        
        //1、编写SQL语句
        let sql = sqlWithType(sql: "DELETE FROM T_Person", contactStr: "AND")
        print("del - \(sql)")
        
        let count1 = SQLManager.shareInstance().selectSQL(sql: "SELECT * FROM T_Person")
        let flag = SQLManager.shareInstance().execSQL(sql: sql)
        let count2 = SQLManager.shareInstance().selectSQL(sql: "SELECT * FROM T_Person")
        
        if count1.count > count2.count && flag {
            return true
        }
        
        return false
    }
    
    
    class func queryLimitPerson(m : Int32, n : Int32) -> [Person]{
        if n == 0 {
            return loadPersons()
        }
        
        let sql = "SELECT * FROM T_Person LIMIT \(m),\(n)"
        
        return selectSQL(sql: sql)
    }
    
    
    /// 排序
    ///
    /// - Parameter sort: 字段
    /// - Returns: 数组
    class func querySortPersons(sort : String) -> [Person]{
        //如果输入的为空，就全部加载
        if sort == "" {
            return loadPersons()
        }
        
        //1、编写SQL语句
        let sql = "SELECT * FROM T_Person ORDER BY \(sort);"
        
        return selectSQL(sql: sql)
    }
    
    class func queryPersons(condition : String) -> [Person]{
        //如果输入的为空，就全部加载
        if condition == ""{
            return loadPersons()
        }
        
        //1、编写SQL语句
        let sql = "SELECT * FROM T_Person WHERE \(condition);"
        
       return selectSQL(sql: sql)
        
    }
    
    /// 查找
    class func loadPersons() -> [Person]{
        
        //1、编写SQL语句
        let sql = "SELECT * FROM T_Person;"
        
        return selectSQL(sql: sql)
    }
    
    
    class func selectSQL(sql : String) -> [Person]{
        //2、获取查询的数据
        let dicts = SQLManager.shareInstance().selectSQL(sql: sql)
        //3、创建一个数组用于保存模型
        var datas = [Person]()
        //4、遍历字典数组，生成模型数组
        for dict in dicts{
            datas.append(Person(dict: dict))
        }
        //5、返回模型数组
        return datas
    }
    
    //拼接语句
    func sqlWithType(sql : String,contactStr : String) -> String{
        var mSQL = sql
        var index = 0
        let count = sql.characters.count
        
        if id != -1 {
            mSQL += " id=\(id) "
            index += 1
        }
        
        if name != nil {
            if index >= 1 {
                mSQL += contactStr
            }
            mSQL += " name='\(name!)' "
            index += 1
        }
        
        if age != -1 {
            if index >= 1 {
                mSQL += contactStr
            }
            mSQL += " age=\(age)"
            index += 1
        }
        
        if money != -1 {
            if index >= 1 {
                mSQL += contactStr
            }
            mSQL += " money=\(money)"
            index += 1
        }
        
        if index > 0 {
            let mStr: NSMutableString = NSMutableString(string: mSQL)
            mStr.insert(" WHERE ", at: count)
            mSQL = (mStr as NSString) as String
        }
        
        
        mSQL += ";"
        
        return mSQL
    }
    
    init(myDict : [Person_Property : Any?]){
        super.init()
        
        var dict = [String : Any]()
        
        for (key,value) in myDict {
            if (value as! String).characters.count > 0 {
                if key.rawValue as String == "id" {
                    if (value as! String).isAllNum() { //并且全是数字
                        dict[key.rawValue as String] = Int((value as! NSString).intValue)
                    }
                }else if key.rawValue as String == "name" {
                    dict[key.rawValue as String] = value
                    
                }else if key.rawValue as String == "age" {
                    if (value as! String).isAllNum() { // 并且全是数字
                        dict[key.rawValue as String] = Int((value as! NSString).intValue)
                    }
                }else if key.rawValue as String == "money" { //
                    if (value as! String).isFloatValue() { //并且是浮点型
                        dict[key.rawValue as String] = (value as! NSString).doubleValue
                    }
                }
            }
        }
        
        setValuesForKeys(dict)
        
    }
    
    init(dict : [String : Any]){
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
}
