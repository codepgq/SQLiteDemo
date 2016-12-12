//
//  SQL-Brige.h
//  SQLiteDemo
//
//  Created by Mac on 16/12/5.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <sqlite3.h>















/*
 参数一：c字符串，文件路径
 参数二：OpaquePointer 一个数据库对象的地址
 
 注意Open方法的特性：如果指定的文件路径已有对应的数据库文件会直接打开，如果没有则会创建在打开
 使用Sqlite_OK判断
 sqlite3_open(cPath, &dbBase)
 */
