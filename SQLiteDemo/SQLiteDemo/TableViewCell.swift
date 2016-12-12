//
//  TableViewCell.swift
//  SQLiteDemo
//
//  Created by Mac on 16/12/9.
//  Copyright © 2016年 Mac. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    var p : Person?{
        didSet{
            idLabel.text = "\(p!.id)"
            nameLabel.text = p!.name
            ageLabel.text = "\(p!.age)"
            moneyLabel.text = "\(p!.money)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
