//
//  CategoryTableViewCell.swift
//  Yelp
//
//  Created by Hao on 10/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var chosenSwitch: UISwitch!
    @IBOutlet weak var nameLabel: UILabel!
    
    var filter:Filter!;
    
    var category:[String:String] = [:] {
        didSet {
            var isSelected = false;
            
            if filter.selected.count > 0 {
                isSelected = filter.selected.contains(category["code"]!)
            }
            
            self.nameLabel.text = category["name"];
            self.chosenSwitch.isOn = isSelected;
        }
    }
    
    @IBAction func onChosenSwitch(_ sender: AnyObject) {
        
        if chosenSwitch.isOn {
            filter.selected.append(category["code"]!)
            return;
        }
        
        if let index = filter.selected.index(of:category["code"]!){
            filter.selected.remove(at: index)
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
