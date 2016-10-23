//
//  Business.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class Business: NSObject {
    let name: String?
    let address: String?
    let imageURL: URL?
    let categories: String?
    let distance: String?
    let ratingImageURL: URL?
    let reviewCount: NSNumber?
    let long:Double?
    let lat:Double?
    let snippet:String?
    
    static var total:Int = 0;
    
    init(dictionary: NSDictionary) {

        name = dictionary["name"] as? String
        
        let imageURLString = dictionary["image_url"] as? String
        if imageURLString != nil {
            imageURL = URL(string: imageURLString!)!
        } else {
            imageURL = nil
        }
        
        let location = dictionary["location"] as? NSDictionary
        var address = ""
        
        var long:Double?
        var lat:Double?
        
        if location != nil {
            let addressArray = location!["address"] as? NSArray
            if addressArray != nil && addressArray!.count > 0 {
                address = addressArray![0] as! String
            }
            
            let neighborhoods = location!["neighborhoods"] as? NSArray
            if neighborhoods != nil && neighborhoods!.count > 0 {
                if !address.isEmpty {
                    address += ", "
                }
                address += neighborhoods![0] as! String
            }

            if let coordinate = location!["coordinate"] as? NSDictionary{
                print(coordinate)
                if let lg = coordinate["longitude"] as? Double{
                    long = lg
                }
                if let lt = coordinate["latitude"] as? Double{
                    lat = lt
                }
            }
        }

        self.long = long!
        self.lat = lat!
        self.address = address
        
        let categoriesArray = dictionary["categories"] as? [[String]]
        if categoriesArray != nil {
            var categoryNames = [String]()
            for category in categoriesArray! {
                let categoryName = category[0]
                categoryNames.append(categoryName)
            }
            categories = categoryNames.joined(separator: ", ")
        } else {
            categories = nil
        }
        
        let distanceMeters = dictionary["distance"] as? NSNumber
        if distanceMeters != nil {
            let milesPerMeter = 0.000621371
            distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
        } else {
            distance = nil
        }
        
        let ratingImageURLString = dictionary["rating_img_url_large"] as? String
        if ratingImageURLString != nil {
            ratingImageURL = URL(string: ratingImageURLString!)
        } else {
            ratingImageURL = nil
        }
        
        reviewCount = dictionary["review_count"] as? NSNumber
        
        
        
        self.snippet = dictionary["snippet_text"] as? String;
    }
    
    class func businesses(array: [NSDictionary]) -> [Business] {
        var businesses = [Business]()
        for dictionary in array {
            let business = Business(dictionary: dictionary)
            businesses.append(business)
        }
        return businesses
    }
    
    class func search(with term: String, completion: @escaping ([Business]?, Error?) -> Void) {
        YelpClient.shared().search(with: term, completion: completion)
    }
    
    class func search(with term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, distance: Int?,offset:Int?,limit:Int?,completion: @escaping ([Business]?, Error?) -> Void) -> Void {
        YelpClient.shared().search(with: term, sort: sort, categories: categories, deals: deals, distance:distance,offset:offset,limit:limit,completion: completion)
    }
}
