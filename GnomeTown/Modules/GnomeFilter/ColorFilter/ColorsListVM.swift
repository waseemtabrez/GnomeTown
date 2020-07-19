//
//  ColorsFilterVM.swift
//  GnomeTown
//
//  Created by 837676 on 18/07/20.
//  Copyright © 2020 Syed Developers. All rights reserved.
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
