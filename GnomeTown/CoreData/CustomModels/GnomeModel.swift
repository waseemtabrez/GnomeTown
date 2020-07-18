//
//  GnomeModel.swift
//  GnomeTown
//
//  Created by 837676 on 17/07/20.
//  Copyright © 2020 Syed Developers. All rights reserved.
//

import Foundation

struct GnomeModel: /*Identifiable,*/ Codable, Hashable {
//   static func == (lhs: GnomeModel, rhs: GnomeModel) -> Bool {
//      lhs.identifier == rhs.identifier
//   }
//   func hash(into hasher: inout Hasher) {
//      hasher.combine(identifier)
//   }
   
   var identifier: Int?
   var name: String?
   var thumbnail: String?
   var age: Int?
   var weight: Double?
   var height: Double?
   var hairColor: String?
   var professions: [String]?
   var friends: [String]?
   
   enum CodingKeys: String, CodingKey {
      case name, thumbnail, age, weight, height, professions, friends
      case hairColor = "hair_color"
      case identifier = "id"
   }
}