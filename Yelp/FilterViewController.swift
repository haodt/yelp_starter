//
//  FilterViewController.swift
//  Yelp
//
//  Created by Hao on 10/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import Darwin

class Filter:NSObject,NSCopying{
    
    var keyword:String
    var selected:[String]
    var hasDeal:Bool
    var sortBy:YelpSortMode
    var distance:Int
    var long:Double
    var lat:Double
    
    let limit = 20
    
    init(keyword:String = "",selected:[String] = [],hasDeal:Bool = false,sortBy:YelpSortMode = YelpSortMode.bestMatched,distance:Int = 0){
        
        self.keyword = keyword
        self.selected = selected
        self.hasDeal = hasDeal
        self.sortBy = sortBy
        self.distance = distance
        self.long = -122.406165
        self.lat = 37.785771
    
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return Filter(keyword:keyword,selected:selected,hasDeal:hasDeal,sortBy:sortBy,distance:distance)
    }
    
}

@objc protocol FilterViewControllerDelegate {
    
    @objc optional func doUpdate(filter:Filter)
    
}

class FilterViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var categoryTextField: UITextField!
    
    @IBOutlet weak var hasDealSwitch: UISwitch!
    
    @IBOutlet weak var sortBySegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var distanceSlider: UISlider!
    
    var categories:[Dictionary<String,String>] = YelpClient.categories
    
    var filter:Filter?
    
    var previous:Filter?
    
    var delegate:FilterViewControllerDelegate?
    
    
    @IBAction func onDistanceSliderValueChange(_ sender: AnyObject) {
        showDistanceIndicator(updateFilter:true)
    }
    
    func showDistanceIndicator(updateFilter:Bool = false){
        let meters = Darwin.round(distanceSlider.value)
        let miles = Darwin.round(meters * 0.000621371192)
        
        if(updateFilter){
            filter?.distance = Int(meters);
        }
        print(filter?.distance);
        if (meters == 0){
            distanceLabel.text = "-- meters / -- miles"
            return
        }
        distanceLabel.text = NSString.init(format: "%d meters / %d miles", Int(meters),Int(miles)) as String;
    }
    
    @IBAction func onSortByChange(_ sender: AnyObject) {
        filter!.sortBy = YelpSortMode(rawValue: sortBySegmentedControl.selectedSegmentIndex)!
    }
    
    @IBAction func onCategoryTexFieldEditingChanged(_ sender: AnyObject) {
        let cates = YelpClient.categories.filter({
            $0["name"]?.range(of:self.categoryTextField.text!, options: .caseInsensitive) != nil
        })
        var filtered = [Dictionary<String,String>]()
        
        for item in cates {
            filtered.append(item);
        }
        
        categories = filtered;
        tableView.reloadData();
    }
    
    @IBAction func onHasDealSwitch(_ sender: AnyObject) {
        filter!.hasDeal = hasDealSwitch.isOn
    }
    
    @IBAction func onSearchButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        if let delegate = delegate {
            delegate.doUpdate!(filter:filter!)
        }
    }
    
    @IBAction func onCancelButton(_ sender: AnyObject) {
        filter = previous;
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        
        if previous == nil {
            previous = Filter();
        }
        filter = previous
        
        sortBySegmentedControl.selectedSegmentIndex = filter!.sortBy.rawValue
        hasDealSwitch.isOn = filter!.hasDeal
        distanceSlider.value = Float((filter?.distance)!)
        
        showDistanceIndicator();
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FilterViewController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell;
        
        cell.filter = filter
        cell.category = categories[indexPath.row]
        
        return cell;
        
    }
    
}
