//
//  Artwork+CoreDataProperties.swift
//  Assignment 2
//
//  Created by Robert Onuma on 09/12/2021.
//
//

import Foundation
import CoreData


extension ArtworkData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArtworkData> {
        return NSFetchRequest<ArtworkData>(entityName: "ArtworkData")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var artist: String?
    @NSManaged public var yearOfWork: String?
    @NSManaged public var type: String?
    @NSManaged public var information: String?
    @NSManaged public var lat: String?
    @NSManaged public var long: String?
    @NSManaged public var location: String?
    @NSManaged public var locationNotes: String?
    @NSManaged public var imageFileName: String?
    @NSManaged public var thumbnail: URL?
    @NSManaged public var lastModified: String?
    @NSManaged public var favoriteArt: Bool
    @NSManaged public var enabled: String?

}

extension ArtworkData : Identifiable {

}
