//
//  BusinessTableViewCell.swift
//  Yelp
//
//  Created by Hao on 10/18/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessTableViewCell: UITableViewCell {

    @IBOutlet weak var imageImageView: UIImageView!
    
    @IBOutlet weak var ratingImageView: UIImageView!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var reviewCountLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var categoriesLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    var business:Business! {
        didSet{
            if let imageUrl = business.imageURL {
                imageImageView.setImageWith(imageUrl)
            }
            ratingImageView.setImageWith(business.ratingImageURL!);
            
            distanceLabel.text = business.distance;
            reviewCountLabel.text = NSString.init(format: "%d reviews", business.reviewCount!) as String;
            nameLabel.text = business.name;
            addressLabel.text = business.address
            categoriesLabel.text = business.categories;
            
        
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
