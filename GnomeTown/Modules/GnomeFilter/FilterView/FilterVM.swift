//
//  FilterVM.swift
//  GnomeTown
//
//  Created by Waseem Tabrez on 17/07/20.
//  Copyright © 2020 Waseem Tabrez. All rights reserved.
//

import Foundation

class GnomeFilterVM: ObservableObject {
   var dataStore = DataProvider(repository: NetworkManager.shared)
   @Published var filteredArray = [GnomeModel]()
   
   @Published var filter = [[String](), [String]()]
   
   @Published var hairColor = [String]()
   @Published var professions = [String]()
   @Published var selectedHairColor = ""
   @Published var selectedProfessions = [String]()
   @Published var age = 0
   
   init() {
      self.hairColor = getHaircolors()
      self.professions = getProfessions()
   }
      
   func getProfessions() -> [String] {
      let data = CoredataManager.shared.fetchAllTypes() ?? [GnomeModel]()
      let newEl = data.compactMap{ array in
         return array.professions
      }
      var wholesomeArray = [String]()
      for item in newEl{
         wholesomeArray.append(contentsOf: item)
      }
      let professionsLocal = wholesomeArray.removeDuplicates()
      self.professions.removeAll()
      self.professions.append(contentsOf: professionsLocal)
      return professionsLocal
   }
   
   func getHaircolors() -> [String] {
      let data = CoredataManager.shared.fetchAllTypes() ?? [GnomeModel]()
      var hairColorsLocal = data.compactMap{ $0.hairColor }
      hairColorsLocal = hairColorsLocal.removeDuplicates()
      self.hairColor.removeAll()
      self.hairColor.append(contentsOf: hairColorsLocal)
      return hairColorsLocal
   }
   
   func removeSelectedProfessions(profession: String) {
      self.selectedProfessions.removeAll { (item) -> Bool in
         item == profession
      }
   }
}
