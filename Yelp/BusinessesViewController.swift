//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MBProgressHUD

class BusinessesViewController: UIViewController,FilterViewControllerDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var businesses: [Business] = [Business]()
    
    var filter:Filter = Filter()
    var offset:Int = 0
    var total:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100;

        fetch();
    }
    
    @IBAction func onSearch(_ sender: AnyObject) {
        filter.keyword = searchTextField.text!
        businesses = [];
        fetch();
    }
    
    func doUpdate(filter:Filter){
        
        self.filter = filter;
        self.offset = 0;
        self.businesses = [Business]()
        fetch()
    
    }
    
    func fetch(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Business.search(with: filter.keyword, sort: filter.sortBy, categories: filter.selected, deals: filter.hasDeal,distance:filter.distance,offset:offset,limit:filter.limit) { (businesses: [Business]?, error: Error?) -> Void in
            if let businesses = businesses {
                self.businesses += businesses
                self.tableView.reloadData()
            }
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "viewFilter" {
            let nav = segue.destination as! UINavigationController
            let filter = nav.topViewController as! FilterViewController
            
            filter.previous = self.filter.copy() as? Filter;
            filter.delegate = self;
        }
        
        if segue.identifier == "viewMap" {
        
            let mapNav = segue.destination as! UINavigationController
            let map = mapNav.topViewController as! MapViewController
            
            map.filter = self.filter;
            
        }
        
    }

}

extension BusinessesViewController:UITableViewDataSource,UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if(indexPath.row == businesses.count - 1){
            
            if Business.total > offset {
                offset += filter.limit
                fetch();
            }
        
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessTableViewCell", for: indexPath) as! BusinessTableViewCell;
        
        cell.business = businesses[indexPath.row]
        
        return cell;
        
    }
    
}
