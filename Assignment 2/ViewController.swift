//
//  ViewController.swift
//  Assignment 2
//
//  Created by Robert Onuma on 07/12/2021.
//

import UIKit
import MapKit
import CoreLocation
import CoreData


let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

struct ArtSection{
    var building: String
    var artworks: [Artwork]?
}


extension UIImageView {
    func load(url:URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var reports:ArtOnCampus? = nil
    var sections = [ArtSection]()
    var locationManager = CLLocationManager()
    var firstRun = true
    var startTrackingTheUser = false
    var userCoord:CLLocation? = nil
    var placeCoord:CLLocation? = nil
    var imageArray = [UIImage]()
    var transmittedArtworks = [Artwork]()
    var imageDict = [String : UIImage]()
    var favoriteArt = [String : Bool]()
    var favArtManagedDict = [String : NSManagedObject]()
    var favArtIDArray = [String]()
    var latestModified:Date? = nil
    
    
    
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var myTable: UITableView!
    
    @IBAction func myUnwindAction (unwindSegue: UIStoryboardSegue) {
        
    }
        
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.sections[section]
        return section.artworks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! TableViewCell
        
        let section = self.sections[indexPath.section]
        let rowInSection = section.artworks?[indexPath.row]
        
        myCell.placeThumbNail.image = imageDict[rowInSection!.ImagefileName]
        
        myCell.titleLabel.text = rowInSection?.title ?? "no title"
        
        myCell.artistLabel.text = rowInSection?.artist ?? "no artist"
        
        
        if favoriteArt[rowInSection!.id] != nil {
            if favoriteArt[rowInSection!.id] == true {
                myCell.starImageView.image = UIImage(systemName: "star.fill")
            }
            else {
                myCell.starImageView.image = UIImage(systemName: "star")
                //print("dbfggwfwef")
            }
        }
        
        
        return myCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.sections[section]
        return section.building
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if favoriteArt[(sections[indexPath.section].artworks?[indexPath.row].id)!] == false {
            favoriteArt[(sections[indexPath.section].artworks?[indexPath.row].id)!] = true
            
            let insertFavArt = NSEntityDescription.insertNewObject(forEntityName: "FavouriteArtwork", into: context) as? FavouriteArtwork
            
            insertFavArt?.artID = sections[indexPath.section].artworks?[indexPath.row].id
            
            do {
                try context.save()
            } catch {
                print("Error saving FavArts")
            }
        }
        else {
            favoriteArt[(sections[indexPath.section].artworks?[indexPath.row].id)!] = false
            if favArtManagedDict[(sections[indexPath.section].artworks?[indexPath.row].id)!] != nil {
                
                context.delete(favArtManagedDict[(sections[indexPath.section].artworks?[indexPath.row].id)!]!)
                print(context.deletedObjects)
                do {
                    try context.save()
                } catch {
                    print("Error saving FavArts")
                }
            }
        }
            
        myTable.reloadData()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annnotation = view.annotation {
            for section in sections {
                if section.building == annnotation.title {
                    transmittedArtworks = section.artworks!
                    if section.artworks?.count == 1 {
                        performSegue(withIdentifier: "toDetailPrime", sender: nil)
                    }
                    else {
                        performSegue(withIdentifier: "toTransition", sender: nil)
                    }
                }
            }
        }
    }
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self as CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        map.showsUserLocation = true
        
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ArtworkData")
       
        request.returnsObjectsAsFaults = false
        
        
        do {
            var artWorkArray = [Artwork]()
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    guard let artist = result.value(forKey: "artist") as? String else {return}
                    
                    guard let id = result.value(forKey: "id") as? String else {return}
                    
                    guard let enabled = result.value(forKey: "enabled") as? String else {return}
                    
                    guard let imageFileName = result.value(forKey: "imageFileName") as? String else {return}
                    
                    
                    guard let information = result.value(forKey: "information") as? String else {return}
                    
                    guard let lastModified = result.value(forKey: "lastModified") as? String else {return}
                    
                    guard let lat = result.value(forKey: "lat") as? String else {return}
                    
                    guard let location = result.value(forKey: "location") as? String else {return}
                    
                    guard let locationNotes = result.value(forKey: "locationNotes") as? String else {return}
                    
                    guard let long = result.value(forKey: "long") as? String else {return}
                    
                    guard let thumbnail = result.value(forKey: "thumbnail") as? URL else {return}
                    
                    
                    guard let title = result.value(forKey: "title") as? String else {return}
                    
                    let type = result.value(forKey: "type") as? String ?? "no type"
                    
                    
                    guard let yearOfWork = result.value(forKey: "yearOfWork") as? String else {return}

                    guard let favArt = result.value(forKey: "favoriteArt") as? Bool else {return}
                                        
                    let art = Artwork(id: id, title: title, artist: artist, yearOfWork: yearOfWork, type: type, Information: information, lat: lat, long: long, location: location, locationNotes: locationNotes, ImagefileName: imageFileName, thumbnail: thumbnail, lastModified: lastModified, enabled: enabled)
                    
                    artWorkArray.append(art)
                    favoriteArt[art.id] = favArt
                    context.delete(result)
                    
                }
                let artOnCampus = ArtOnCampus(campusart: artWorkArray)
                reports = artOnCampus
                
                for result in results as! [NSManagedObject] {
                    context.delete(result)
                }
                do {
                    try context.save()
                } catch {
                    print("changes failed")
                }
                
                DispatchQueue.main.async {
                    self.downLoadImage()
                    self.updateTheTable()
                }
            }
        } catch {
            print("couldn't fetch results")
        }
        
        if let url = URL(string: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/artworksOnCampus/data.php?class=campusart&lastModified=2017-12-01") {
            
            let urlString = url.absoluteString
            if urlString.contains("&lastModified=") {
                
                let urlStringArr = urlString.components(separatedBy: "&lastModified=")
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                if let dateFromURl = dateFormatter.date(from: urlStringArr[1]) {
                    latestModified = dateFromURl
                }
            }
              let session = URLSession.shared
              session.dataTask(with: url) { (data, response, err) in
                  guard let jsonData = data else {
                      return
                  }
                  do {
                      let decoder = JSONDecoder()
                      let reportList = try decoder.decode(ArtOnCampus.self, from: jsonData)
                      self.reports = reportList
                      self.downLoadImage()
                      DispatchQueue.main.async {
                            //self.updateCoreData()
                            self.updateTheTable()
                          
                      }
                  } catch let jsonErr {
                      print("Error decoding JSON", jsonErr)
                  }
             }.resume()
            
          }
        
        let request2 = NSFetchRequest<NSFetchRequestResult>(entityName: "FavouriteArtwork")
        
        request2.returnsObjectsAsFaults = false
        
        do {
            let results2 = try context.fetch(request2)
            
            if results2.count > 0 {
                for result in results2 as! [NSManagedObject] {
                    if let artID = result.value(forKey: "artID") {
                        favArtIDArray.append(artID as! String)
                        favArtManagedDict[artID as! String] = result
                    }
                }
            }
        } catch {
            print("couldn't fetch result2")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailPrime" {
            let detailsViewController = segue.destination as! detailsViewController
            detailsViewController.retrievedArtwork = transmittedArtworks[0]
        }
        
        if segue.identifier == "toTransition" {
            let transitionViewController = segue.destination as! transitionViewController
            transitionViewController.retrievedArtworks = transmittedArtworks
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationOfUser = locations[0]
        let latitude = locationOfUser.coordinate.latitude
        let longitude = locationOfUser.coordinate.longitude
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        userCoord = locationOfUser
                
        if firstRun {
            firstRun = false
            let latDelta: CLLocationDegrees = 0.0025
            let lonDelta: CLLocationDegrees = 0.0025
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta:
        lonDelta)
            let region = MKCoordinateRegion(center: location, span: span)
            self.map.setRegion(region, animated: true)
                    
            _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(startUserTracking), userInfo: nil, repeats: false)
            
            
        }
        if startTrackingTheUser == true {
            map.setCenter(location, animated: true)
            if sections.count > 0 {
                self.sortTheTable()
            }
        }
    }
    
    @objc func startUserTracking() {
        startTrackingTheUser = true
    }
    
    func checkCoordDistance(_ info : Artwork) -> Double {
        let latString = (info.lat)
        let lonString = (info.long)
        
        let lat = Double(latString)
        let lon = Double(lonString)
        
        let placeCoord = CLLocation(latitude: lat!, longitude: lon!)
        let distance = userCoord?.distance(from: placeCoord)
        
        return distance?.magnitude ?? 0
    }
    
    
    func updateCoreData() {
        var mutableArtworks = reports?.campusart
        
        var index = 0
        
        for artWork in (reports?.campusart)! {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let artDate = dateFormatter.date(from: artWork.lastModified) {
                if artDate < latestModified ?? artDate {
                    mutableArtworks?.remove(at: index)
                }

            }
            
            index += 1
        }
        var mutableArtworks2 = mutableArtworks
        
        for i in 0...(mutableArtworks!.count-1) {
            if mutableArtworks![i].enabled != "1" {
                mutableArtworks2?.remove(at: i)
            }
        }
        
        for chosenArt in (mutableArtworks2)! {
            let newArt = NSEntityDescription.insertNewObject(forEntityName: "ArtworkData", into: context) as! ArtworkData
                
            newArt.artist = chosenArt.artist
            newArt.id = chosenArt.id
            newArt.enabled = chosenArt.enabled
            newArt.imageFileName = chosenArt.ImagefileName
            newArt.information = chosenArt.Information
            newArt.lastModified = chosenArt.lastModified
            newArt.lat = chosenArt.lat
            newArt.location = chosenArt.location
            newArt.locationNotes = chosenArt.locationNotes
            newArt.long = chosenArt.long
            newArt.thumbnail = chosenArt.thumbnail
            newArt.title = chosenArt.title
            newArt.type = chosenArt.type
            newArt.yearOfWork = chosenArt.yearOfWork
            if favoriteArt[chosenArt.id] != nil {
                newArt.favoriteArt = favoriteArt[chosenArt.id]!
            }
            else {
                newArt.favoriteArt = false
            }
                
            do {
                try context.save()
            } catch {
                print("there was an error")
            }
            
        }
        
    }
    
    func updateTheTable() {
        //print(favoriteArt)
        
        var sortedArtworks = reports?.campusart
        var index = 0
        
        for artWork in (reports?.campusart)! {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let artDate = dateFormatter.date(from: artWork.lastModified) {
                if artDate < latestModified ?? artDate {
                    print(artDate)
                    sortedArtworks?.remove(at: index)
                }
            }
            
            let mutableArtworks = sortedArtworks
            
            for i in 0...(mutableArtworks!.count-1) {
                if mutableArtworks![i].enabled != "1" {
                    sortedArtworks?.remove(at: i)
                }
            }
            index += 1
        }
        
        sortedArtworks!.sort{ (first,second) in
            checkCoordDistance(first) < checkCoordDistance(second)
        }
        
        
        let groups = Dictionary(grouping: sortedArtworks!) {
            (building) -> String in
            return building.locationNotes
        }
        
                
        self.sections = groups.map { (key, values) in
            return ArtSection(building: key, artworks: values)
        }
        
        
        self.sections.sort { (first, second) in
            checkCoordDistance(first.artworks![0]) < checkCoordDistance(second.artworks![0])
        }
        
        for currentBuilding in 0...(sections.count-1) {
            for currentPlace in 0...(sections[currentBuilding].artworks!.count)-1 {
                guard let id = sections[currentBuilding].artworks?[currentPlace].id else { return }
                
                favoriteArt[id] = false
                for artID in favArtIDArray {
                    if id == artID {
                        favoriteArt[id] = true
                    }
                }
            
            }
            guard (sections.count) > currentBuilding else { return }
            guard let lat = sections[currentBuilding].artworks?[0].lat else { return }
            guard let lon = sections[currentBuilding].artworks?[0].long else { return }
            guard let latitude = Double(lat) else { return }
            guard let longitude = Double(lon) else { return }
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = sections[currentBuilding].building
            self.map.addAnnotation(annotation)
        
        }
        myTable.reloadData()
    }
    
    func sortTheTable() {
        self.sections.sort { (first, second) in
            checkCoordDistance(first.artworks![0]) < checkCoordDistance(second.artworks![0])
        }
        myTable.reloadData()
    }
    
    func downLoadImage() {
        for art in (self.reports?.campusart)! {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: art.thumbnail!) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            
                            self!.imageDict[art.ImagefileName] = image
                        }
                    }
                }
            }
        }
    }
}

