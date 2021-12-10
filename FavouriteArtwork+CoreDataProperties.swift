//
//  FavouriteArtwork+CoreDataProperties.swift
//  Assignment 2
//
//  Created by Robert Onuma on 10/12/2021.
//
//

import Foundation
import CoreData


extension FavouriteArtwork {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteArtwork> {
        return NSFetchRequest<FavouriteArtwork>(entityName: "FavouriteArtwork")
    }

    @NSManaged public var artID: String?

}

extension FavouriteArtwork : Identifiable {

}
