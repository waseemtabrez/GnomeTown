//
//  ProfessionsListVM.swift
//  GnomeTown
//
//  Created by Waseem Tabrez on 18/07/20.
//  Copyright © 2020 Waseem Tabrez. All rights reserved.
//

import Foundation

class ProfessionsListVM: ObservableObject {
   @Published var professions = [String]()
   @Published var selectedProfessions = [String]()
   var gnomeFilterVM = GnomeFilterVM()
   @Published var professionsModel = [ProfessionsModel]()

   init() {
      self.professions = gnomeFilterVM.getProfessions()
      self.professionsModel = self.professions.map{ ProfessionsModel(isSelected: false, name: $0)
      }
      clearSelectedProfessions()
   }
   func clearSelectedProfessions() {
      self.selectedProfessions = [String]()
   }
   
   func resetSelectedProfessions() {
      self.selectedProfessions = self.professions
   }
   
   func addSelectedProfessions(profession: String) {
      if selectedProfessions.contains(profession) {
         selectedProfessions.removeAll { (item) -> Bool in
            item == profession
         }
      } else {
         self.selectedProfessions.append(profession)
      }
   }
   
   func removeSelectedProfessions(profession: String) {
         selectedProfessions.removeAll { (item) -> Bool in
            item == profession
      }
   }
}

struct ProfessionsModel: Hashable {
   var isSelected: Bool
   var name: String
}
