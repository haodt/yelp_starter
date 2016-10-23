//
//  MapViewController.swift
//  Yelp
//
//  Created by Hao on 10/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    @IBOutlet weak var backButtonItem: UIBarButtonItem!
    
    var filter:Filter?
    var offset:Int = 0
    var businesses: [Business] = [Business]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: filter!.lat, longitude: filter!.long, zoom: 18.0)
        
        let map = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        view = map
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: filter!.lat, longitude: filter!.long)
        marker.title = "You"
        marker.snippet = "are here"
        marker.map = map
        
        fetch()
    }
    
    func fetch(){

        Business.search(with: filter!.keyword, sort: filter!.sortBy, categories: filter!.selected, deals: filter!.hasDeal,distance:filter!.distance,offset:offset,limit:filter!.limit) { (businesses: [Business]?, error: Error?) -> Void in
            
            if let businesses = businesses {
                self.businesses += businesses
                self.redraw()
            }
            
            
        }
    }
    
    func redraw(){
        for business in businesses {
            var marker:GMSMarker
 
            if business.lat != nil && business.long != nil {
                marker = GMSMarker()
                
                marker.position = CLLocationCoordinate2D(latitude: business.lat!, longitude: business.long!)
                
                marker.icon = GMSMarker.markerImage(with: UIColor.green)
                marker.title = business.name
                marker.snippet = business.snippet
                
                marker.map = view as? GMSMapView
            }
            
        
        }
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
