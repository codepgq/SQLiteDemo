//
//  Controller+Cagetory.swift
//  SQLiteDemo
//
//  Created by Mac on 16/12/9.
//  Copyright © 2016年 Mac. All rights reserved.
//

import UIKit

extension UIViewController{
    func showErrorText(){
        let alertC = UIAlertController(title: "", message: "查找不到数据，请检测语句是否正确或者数据部存在", preferredStyle: UIAlertControllerStyle.alert)
        alertC.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel, handler: nil))
        present(alertC, animated: true, completion: nil)
    }
    func showSuccessText(){
        let alertC = UIAlertController(title: "", message: "执行SQL语句成功", preferredStyle: UIAlertControllerStyle.alert)
        alertC.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel, handler: nil))
        present(alertC, animated: true, completion: nil)
    }
    
    func showErrorText(message : String){
        let alertC = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertC.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel, handler: nil))
        present(alertC, animated: true, completion: nil)
    }
    
}
