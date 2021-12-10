//
//  detailsViewController.swift
//  Assignment 2
//
//  Created by Robert Onuma on 08/12/2021.
//

import UIKit

class detailsViewController: UIViewController {
    var retrievedArtwork: Artwork? = nil
    
    @IBOutlet weak var authorDetailLabel: UILabel!
    
    @IBOutlet weak var imageDetailView: UIImageView!
    
    @IBOutlet weak var titleDetailLabel: UILabel!
    
    @IBOutlet weak var yearDetailLabel: UILabel!
    
    @IBOutlet weak var informationDetailLabel: UILabel!
    
    @IBOutlet weak var locationNoteDetailLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authorDetailLabel.text = "By " + (retrievedArtwork?.artist ?? "N/A")
        
        titleDetailLabel.text = retrievedArtwork?.title ?? "no title"
        
        yearDetailLabel.text = "Year of Work: " + (retrievedArtwork?.yearOfWork ?? "N/A")
        
        informationDetailLabel.text = retrievedArtwork?.Information ?? "No information found."
        
        locationNoteDetailLabel.text = retrievedArtwork?.locationNotes
        
        let imageName = retrievedArtwork?.ImagefileName
        let imageNameConverted = imageName?.replacingOccurrences(of: " ", with: "%20")
        let imageURLStr = "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/artwork_images/" + imageNameConverted!
        
        
        if imageURLStr != nil {
            let imageURL = URL(string: imageURLStr)
            imageDetailView.load(url: imageURL!)
        }
        
        
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
