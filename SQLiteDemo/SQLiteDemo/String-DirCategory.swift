
//
//  String-DirCategory.swift
//  PQWeiboDemo
//
//  Created by ios on 16/9/26.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

extension String{
    /**
     将当前字符串拼接到cache目录后面
     */
    func cacheDir() -> String{
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!  as NSString
        return path.appendingPathComponent((self as NSString).lastPathComponent)
    }
    /**
     将当前字符串拼接到document目录后面
     */
    func documentDir() -> String
    {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!  as NSString
        return path.appendingPathComponent((self as NSString).lastPathComponent)
    }
    /**
     将当前字符串拼接到temp目录后面
     */
    func tempDir() -> String
    {
        let path = NSTemporaryDirectory() as NSString
        return path.appendingPathComponent((self as NSString).lastPathComponent)
    }
    
    func isAllNum() -> Bool{
        
        do {
            //1、创建规则
            let pattern = "^\\+?[1-9][0-9]*$"
            
            //2、创建对象
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            
            //3、开始匹配
            let range = regex.rangeOfFirstMatch(in: self, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSRange(location: 0, length: self.characters.count))
            if range.location == 0 && range.length > 0 {
                return true
            }
        } catch{
            print(error)
        }
        
        return false
    }
    
    
    func isFloatValue() -> Bool{
        do {
            //1、创建规则
            let pattern = "^[+]?[0-9]*\\.?[0-9]+$"
            
            //2、创建对象
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            
            //3、开始匹配
            let range = regex.rangeOfFirstMatch(in: self, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSRange(location: 0, length: self.characters.count))
            if range.location == 0 && range.length > 0 {
                return true
            }
        } catch{
            print(error)
        }
        
        return false
    }
    
    func intValue() -> Int{
        return Int((self as NSString).intValue)
    }
    
    func floatValue() -> Float{
        return (self as NSString).floatValue
    }
    
    func doubleValue() -> Double{
        return (self as NSString).doubleValue
    }
    
}
