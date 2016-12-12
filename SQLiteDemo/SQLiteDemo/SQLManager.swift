//
//  SQLManager.swift
//  SQLiteDemo
//
//  Created by Mac on 16/12/5.
//  Copyright © 2016年 Mac. All rights reserved.
//

import UIKit

class SQLManager: NSObject {
    
    /// 单例
    static let manager : SQLManager = SQLManager()
    class func shareInstance() -> SQLManager{
        return manager
    }
    
    ///数据库对象
    private var dbBase : OpaquePointer? = nil
    
   
    
   
//    MARK - Child Thread
    /*
     1 一个唯一的对列名
     2 优先级
     3 队列类型
     4 
     */
    private let dbQueue = DispatchQueue(label: "com.codepgq.github", qos: DispatchQoS.default, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: nil)
    //DispatchQueue(label:"com.appcoda.queue2", qos:DispatchQoS.userInitiated)
    func execQueueSQL(action : @escaping (_ manager : SQLManager) ->()){
        //开一个子线程
        DispatchQueue.global().async { 
            action(self)
        }
    }
    
    
    
//     MARK -  Main Thread
    /// 预编译更新
    func prepareExec(sql : String) -> Bool{
        // 1、先把OC字符串转化为C字符串
        let cSQL = sql.cString(using: String.Encoding.utf8)
        
        var stmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(dbBase, cSQL, -1, &stmt, nil) != SQLITE_OK{
            print("请检查SQL语句")
            return false
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            print("执行更新失败")
            return false
        }
        
        //记得要释放句柄
        sqlite3_finalize(stmt)
        
        return true
    }
    
    
    // MARK: - 预编译
    @discardableResult func batchExecsql(_ sql:String, args: CVarArg...) -> Bool
    {
        
        // 1.将SQL语句转换为C语言
        let cSQL = sql.cString(using: String.Encoding.utf8)!
        
        // 2.预编译SQL语句
        var stmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(dbBase, cSQL, -1, &stmt, nil) != SQLITE_OK
        {
            print("预编译失败")
            sqlite3_finalize(stmt)
            return false
        }
        
        // 3.绑定数据
        var index:Int32 = 1
        for objc in args
        {
            if objc is Int
            {
                //                print("通过int方法绑定数据 \(objc)")
                // 第二个参数就是SQL中('?', ?)的位置, 注意: 从1开始
                sqlite3_bind_int64(stmt, index, sqlite3_int64(objc as! Int))
            }else if objc is Double
            {
                //                print("通过Double方法绑定数据 \(objc)")
                sqlite3_bind_double(stmt, index, objc as! Double)
            }else if objc is String
            {
                //                print("通过Text方法绑定数据 \(objc)")
                let text = objc as! String
                let cText = text.cString(using: String.Encoding.utf8)!
                // 第三个参数: 需要绑定的字符串, C语言
                // 第四个参数: 第三个参数的长度, 传入-1系统自动计算
                // 第五个参数: OC中直接传nil, 但是Swift传入nil会有大问题
                /*
                 typedef void (*sqlite3_destructor_type)(void*);
                 
                 #define SQLITE_STATIC      ((sqlite3_destructor_type)0)
                 #define SQLITE_TRANSIENT   ((sqlite3_destructor_type)-1)
                 
                 第五个参数如果传入SQLITE_STATIC/nil, 那么系统不会保存需要绑定的数据, 如果需要绑定的数据提前释放了, 那么系统就随便绑定一个值
                 第五个参数如果传入SQLITE_TRANSIENT, 那么系统会对需要绑定的值进行一次copy, 直到绑定成功之后再释放
                 */
                sqlite3_bind_text(stmt, index, cText, -1, SQLITE_TRANSIENT)
            }
            index += 1
        }
        
        // 4.执行SQL语句
        if sqlite3_step(stmt) != SQLITE_DONE
        {
            print("执行SQL语句失败")
            return false
        }
        
        // 5.重置STMT
        if sqlite3_reset(stmt) != SQLITE_OK
        {
            print("重置失败")
            return false
        }
        
        // 6.关闭STMT
        // 注意点: 只要用到了stmt, 一定要关闭
        sqlite3_finalize(stmt)
        
        return true
    }
    
    /// 自定义一个SQLITE_TRANSIENT, 覆盖系统的
    private let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    @discardableResult func batchExecSQL(sql : String , args: CVarArg...) -> Bool{
        //1转化为C字符串
        let cSql = sql.cString(using: String.Encoding.utf8)!
        
        //2、执行预编译
        var stmt : OpaquePointer? = nil
        if  sqlite3_prepare_v2(dbBase, cSql, -1, &stmt, nil) != SQLITE_OK {
            print("预编译失败")
            sqlite3_finalize(stmt)
            return false
        }
        
        //3、进行数据绑定
        /*
         这里要注意，下标从1开始。
         */
        var index : Int32 = 1
        /*
         sqlite3_bind_XX(句柄, 下标（从1开始）, 值)
         */
        for objc in args{
            if objc is Int{
                sqlite3_bind_int64(stmt, index, sqlite3_int64(objc as! Int))
            }else if objc is Double{
                sqlite3_bind_double(stmt, index, objc as! Double)
            }else if objc is String{
                //得到字符串
                let text = objc as! String
                //得到C字符串
                let cText = text.cString(using: String.Encoding.utf8)!
                /*
                 sqlite3_bind_text(句柄, 下标, 字符串, 字符串长度 -1 表示系统自己计算, OC传入nil，SWIFT不行)
                 1 句柄
                 2 下标
                 3 C字符串
                 4 C字符串长度 -1 自动计算
                 5 OC 传入nil 但是SWIFT不行，因为对象提前释放掉了，会导致插入的数据不对
                    typedef void (*sqlite3_destructor_type)(void*);
                 
                    #define SQLITE_STATIC      ((sqlite3_destructor_type)0)
                    #define SQLITE_TRANSIENT   ((sqlite3_destructor_type)-1)
                 
                    第五个参数如果传入SQLITE_STATIC/nil, 那么系统不会保存需要绑定的数据, 如果需要绑定的数据提前释放了, 那么系统就随便绑定一个值
                    第五个参数如果传入SQLITE_TRANSIENT, 那么系统会对需要绑定的值进行一次copy, 直到绑定成功之后再释放
                 
                 但是Swift中并不能直接写 SQLITE_TRANSIENT 或者 -1，需要自定义一个SQLITE_TRANSIENT，来覆盖系统的
                 在 124 行中
                 */
                sqlite3_bind_text(stmt, index, cText, -1, SQLITE_TRANSIENT)
            }
            index += 1
        }
        
        
        //4、执行SQL语句
        if sqlite3_step(stmt) != SQLITE_DONE {
            print("执行SQL语句失败")
            return false
        }
        
        //5、重置STMT
        if sqlite3_reset(stmt) != SQLITE_OK{
            print("重置句柄失败")
            return false
        }
        
        //6、关闭STMT
        sqlite3_finalize(stmt)
        
        return true
    }
    
    
    /// 执行更新
    @discardableResult func execSQL(sql : String) -> Bool {
        // 1、先把OC字符串转化为C字符串
        let cSQL = sql.cString(using: String.Encoding.utf8)!
        
        // 2、执行语句
        /// 在SQLite3中，除了查询以外（创建/删除/更新）都是用同一个函数
        /*
         1. 已经打开的数据库对象
         2. 需要执行的SQL语句，c字符串
         3. 执行SQL语句之后的回调，一般写nil
         4. 是第三个参数的第一个参数，一般传nil
         5. 错误信息，一般传nil
         
         SQLITE_API int SQLITE_STDCALL sqlite3_exec(
         sqlite3*,                                  /* An open database */
         const char *sql,                           /* SQL to be evaluated */
         int (*callback)(void*,int,char**,char**),  /* Callback function */
         void *,                                    /* 1st argument to callback */
         char **errmsg                              /* Error msg written here */
         );
         */
        
        if sqlite3_exec(dbBase, cSQL, nil, nil, nil) != SQLITE_OK {
            return false
        }
        return true
    }
    
    func selectSQL(sql : String) -> [[String : Any]]{
        // 0.先创建一个字典数组
        var dicts = [[String: Any]]()
        
        // 1、把sql转化为c字符串
        let cSQL = sql.cString(using: String.Encoding.utf8)
        
        //2.2、创建一个对象保存预编译STMT
        var stmt :OpaquePointer? = nil
        // 2.2、执行预编译
        /**
         1、已经打开的数据库对象
         2、需要执行的SQL语句
         3、需要执行的SQL语句的长度、传入 -1 系统自动计算
         4、预编译之后的句柄，以及要想取出数据，就需要这个句柄
         5、一般传nil
         
         SQLITE_API int SQLITE_STDCALL sqlite3_prepare_v2(
         sqlite3 *db,            /* Database handle */
         const char *zSql,       /* SQL statement, UTF-8 encoded */
         int nByte,              /* Maximum length of zSql in bytes. */
         sqlite3_stmt **ppStmt,  /* OUT: Statement handle */
         const char **pzTail     /* OUT: Pointer to unused portion of zSql */
         );
         */
        if sqlite3_prepare_v2(dbBase, cSQL, -1, &stmt, nil) != SQLITE_OK{
            print("预编译失败，请检查SQL语句")
            return dicts
        }
        
        //3、如果预编译成功，那么久可以取出数据了
        //sqlite3_setp表示取出一行数据，如果返回值SQLITE_ROW标示取到了
        while sqlite3_step(stmt) == SQLITE_ROW {
            // 3.1得到每一列的数据
            let dict = recodeWithStmt(stmt!)
            // 3.2添加到数组中
            dicts.append(dict)
        }
        
        //4、一定要释放句柄
        sqlite3_finalize(stmt)
        
        //5、返回字典数组
        return dicts
        
        
    }
    
    
    /// 拿到每一列的数据
    ///
    /// - Parameter stmt: 句柄
    /// - Returns: 字典返回
    private func recodeWithStmt(_ stmt : OpaquePointer) -> [String : Any]{
        
        //1、获取当前的所有列的列数，遍历取值
        let count = sqlite3_column_count(stmt)
        
        //2、定义一个字典保存数据
        var dict = [String : Any]()
        
        //3、遍历这一行的每一列
        for index in 0..<count {
            //3.1、拿到每一列的名称
            /*
             1、句柄
             2、下标
             */
            let cName = sqlite3_column_name(stmt, index)
            let name = String(cString: cName!, encoding: String.Encoding.utf8)!
            
            // 3.2、拿到每列的类型
            let type = sqlite3_column_type(stmt, index)
//            print("name - \(name) type - \(type)")
            
            /*
             当你看到一推1 2 3的时候懵逼了，我的直觉告诉我，你需要这个
             #define SQLITE_INTEGER  1
             #define SQLITE_FLOAT    2
             #define SQLITE_BLOB     4
             #define SQLITE_NULL     5
             #ifdef SQLITE_TEXT
             # undef SQLITE_TEXT
             #else
             # define SQLITE_TEXT     3
             #endif
             #define SQLITE3_TEXT     3
             */
            
            //3.3、根据类型取值
            switch type {
            case SQLITE_INTEGER: //整形
                let num = sqlite3_column_int64(stmt, index)
                dict[name] = Int(num)
                
            case SQLITE_FLOAT: //浮点型
                let double = sqlite3_column_double(stmt, index)
                dict[name] = Double(double)
                
            case SQLITE3_TEXT: //text 文本类型
                let cText = String.init(cString: sqlite3_column_text(stmt, index))
                let text = String(cString: cText, encoding: String.Encoding.utf8)!
                dict[name] = text
                
            case SQLITE_NULL: //NULL
                dict[name] = NSNull()
                
            default: //二进制类型
                print("二进制数据")
                
            }
        }
        
        // 4、返回数据
        return dict
        
    }
    
    
    /// 打开数据库
    func openDB(DBName: String){
        
        //1、拿到数据库路径
        let path = DBName.documentDir()
        //打印路径，以便拿到数据文件
        print(path)
        
        //2、转化为c字符串
        let cPath = path.cString(using: String.Encoding.utf8)
        /*
         参数一：c字符串，文件路径
         参数二：OpaquePointer 一个数据库对象的地址
         
         注意Open方法的特性：如果指定的文件路径已有对应的数据库文件会直接打开，如果没有则会创建在打开
         使用Sqlite_OK判断
         sqlite3_open(cPath, &dbBase)
         */
        /*
         #define SQLITE_OK           0   /* Successful result */
         */
        if sqlite3_open(cPath, &dbBase) != SQLITE_OK{
            print("数据库打开失败")
            return
        }
        
        createTab()
    }
    
    @discardableResult func createTab() -> Bool{
        
        //1、编写SQL语句
        let sql = "CREATE TABLE IF NOT EXISTS T_Person\n" +
            "(\n" +
            "id INTEGER PRIMARY KEY AUTOINCREMENT,\n" +
            "name TEXT NOT NULL,\n" +
            "age INTEGER, \n" +
            "money REAL DEFAULT 100.0\n" +
        ");"
        print(sql)
        
        let flag = execSQL(sql: sql)
        if !flag {
            print("创建表失败")
        }
        return flag
    }
    
    /// 开启事务
    func beginTransaction(){
        execSQL(sql: "BEGIN TRANSACTION")
    }
    
    /// 提交事务
    func commitTransaction(){
        execSQL(sql: "COMMIT TRANSACTION")
    }
    
    /// 回滚
    func rollbackTransaction(){
        execSQL(sql: "ROLLBACK TRANSACTION")
    }
    
}

