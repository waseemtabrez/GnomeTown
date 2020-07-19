//
//  ColorsFilterVM.swift
//  GnomeTown
//
//  Created by Waseem Tabrez on 18/07/20.
//  Copyright © 2020 Waseem Tabrez. All rights reserved.
//

import Foundation

class ColorsListVM: ObservableObject {
   @Published var colors = [String]()
   @Published var selectedColors = [String]()
   var gnomeFilterVM = GnomeFilterVM()
   
   init() {
      self.colors = gnomeFilterVM.getHaircolors()
      clearSelectedColors()
   }
   func clearSelectedColors() {
      self.selectedColors = [String]()
   }
   
   func resetSelectedColors() {
      self.selectedColors = self.colors
   }
   
   func addSelectedColors(color: String) {
      if selectedColors.contains(color) {
         selectedColors.removeAll { (item) -> Bool in
            item == color
         }
      } else {
         self.selectedColors.append(color)
      }
   }
}
