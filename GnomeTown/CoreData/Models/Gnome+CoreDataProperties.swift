//
//  Gnome+CoreDataProperties.swift
//  GnomeTown
//
//  Created by 837676 on 15/07/20.
//  Copyright © 2020 Syed Developers. All rights reserved.
//
//

import Foundation
import CoreData


extension Gnome {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Gnome> {
        return NSFetchRequest<Gnome>(entityName: "Gnome")
    }

    @NSManaged public var hairColor: String?
    @NSManaged public var weight: Double
    @NSManaged public var height: Double
    @NSManaged public var name: String?
    @NSManaged public var age: Int16
    @NSManaged public var identifier: Int16
    @NSManaged public var thumbnail: String?
    @NSManaged public var friends: [String]?
    @NSManaged public var professions: [String]?
}
