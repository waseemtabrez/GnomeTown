//
//  AgeFilterVM.swift
//  GnomeTown
//
//  Created by 837676 on 18/07/20.
//  Copyright © 2020 Syed Developers. All rights reserved.
//

import Foundation

class AgeFilterVM: ObservableObject {
   @Published var ageTypes: [AgeFilter] = [.equalTo, .greaterThan, .greaterThanOrEqualTo, .lessThan, .lessThanOrEqualTo]
   @Published var selectedAgeType: AgeFilter = .equalTo
   @Published var selectedAgeString = ""
   @Published var selectedAge = 0

   var gnomeFilterVM = GnomeFilterVM()
   
   init() {
      clearSelectedAge()
   }
   func clearSelectedAge() {
      self.selectedAgeType = .equalTo
      self.selectedAge = 0
   }
   
   func resetSelectedColors() {
      self.selectedAgeString = ""
      self.selectedAgeType = .equalTo
   }
   
   func set(ageType: AgeFilter) {
      self.selectedAgeType = ageType
   }
   func set(age: Int) {
      self.selectedAge = age
      self.selectedAgeString = String(age)
   }
}
