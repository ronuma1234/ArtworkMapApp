//
//  transitionViewController.swift
//  Assignment 2
//
//  Created by Robert Onuma on 08/12/2021.
//

import UIKit

class transitionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var selectedRow = -1
    var retrievedArtworks = [Artwork]()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return retrievedArtworks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transCell = tableView.dequeueReusableCell(withIdentifier: "transitionCell", for: indexPath) as! TransitionTableViewCell
        
        transCell.titleLabelTrans.text = retrievedArtworks[indexPath.row].title
        
        transCell.artistLabelTrans.text = retrievedArtworks[indexPath.row].artist 
        
        transCell.imageViewTrans.load(url: (retrievedArtworks[indexPath.row].thumbnail)!)
        
        
        
        return transCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        performSegue(withIdentifier: "transToDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "transToDetail" {
            let detailsViewController = segue.destination as! detailsViewController
            detailsViewController.retrievedArtwork = retrievedArtworks[selectedRow]
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

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
