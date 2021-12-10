//
//  assignmentDataModel.swift
//  Assignment 2
//
//  Created by Robert Onuma on 07/12/2021.
//

import Foundation

struct Artwork : Decodable {
    let id : String
    let title : String
    let artist : String
    let yearOfWork : String
    let type : String?
    let Information : String
    let lat : String
    let long : String
    let location : String
    let locationNotes : String
    let ImagefileName : String
    let thumbnail : URL?
    let lastModified : String
    let enabled : String
}

struct ArtOnCampus: Decodable {
    let campusart: [Artwork]
}

