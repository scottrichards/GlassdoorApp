//
//  Company.swift
//  GlassdoorApp
//
//  Created by Scott Richards on 11/19/16.
//  Copyright © 2016 Scott Richards. All rights reserved.
//

import UIKit

class Company: NSObject {
    var name : String?
    var rating : String?
    var logoURL : String?
    
    init(dict : NSDictionary) {
        if let nameStr = dict["name"] as? String {
            self.name = nameStr
        }
        if let ratingStr = dict["overallRating"] as? String {
            self.rating = ratingStr
        }
        if let logoURLStr = dict["squareLogo"] as? String {
            logoURL = logoURLStr
        }
    }
}
