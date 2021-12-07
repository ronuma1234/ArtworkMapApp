//
//  ViewController.swift
//  Assignment 2
//
//  Created by Robert Onuma on 07/12/2021.
//

import UIKit
import MapKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {
    var reports:ArtOnCampus? = nil
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var myTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reports?.campusart.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        myCell.textLabel?.text = reports?.campusart[indexPath.row].title ?? "no title"
        
        return myCell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let url = URL(string: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/artworksOnCampus/data.php?class=campusart") {
              let session = URLSession.shared
              session.dataTask(with: url) { (data, response, err) in
                  guard let jsonData = data else {
                      return
                  }
                  do {
                      let decoder = JSONDecoder()
                      let reportList = try decoder.decode(ArtOnCampus.self, from: jsonData)
                      self.reports = reportList
                      DispatchQueue.main.async {
                          self.updateTheTable()
                      }
                  } catch let jsonErr {
                      print("Error decoding JSON", jsonErr)
                  }
             }.resume()
            //print(reports)
          }
    }
    
    func updateTheTable() {
        myTable.reloadData()
    }


}

