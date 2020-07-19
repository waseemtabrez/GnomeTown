//
//  GnomeFilterView.swift
//  GnomeTown
//
//  Created by Waseem Tabrez on 17/07/20.
//  Copyright © 2020 Waseem Tabrez. All rights reserved.
//

import SwiftUI

struct ColorsListView: View {
   @EnvironmentObject var professionsListVM : ColorsListVM
   @EnvironmentObject var gnomeListVM: GnomeListVM
   @Binding var showProfessionsList: Bool
   var body: some View {
      NavigationView {
         List {
            ForEach(self.professionsListVM.colors, id: \.self) { item in
               Button(action: {
                  self.professionsListVM.addSelectedColors(color: item)
               }, label: {
                  VStack {
                     HStack {
                        Text(LocalizedStringKey(item))
                           .foregroundColor(self.professionsListVM.selectedColors.contains(item) ? Color.green : Color.secondary)
                           .padding(.leading, 8)
                        Spacer()
                        ZStack {
                           Circle()
                              .fill(self.professionsListVM.selectedColors.contains(item) ? Color.green : Color.secondary)
                              .frame(width: 18, height: 18)
                           if self.professionsListVM.selectedColors.contains(item) {
                              Circle().stroke(Color.green, lineWidth: 2).frame(width: 25, height: 25)
                           } else {
                              Circle().stroke(Color.clear, lineWidth: 2).frame(width: 25, height: 25)
                           }
                        }.padding(.trailing, 8)
                     }
                  }
               }).background(Color.clear)
                  .padding([.horizontal], 3)
            }
         }
         .navigationBarItems(trailing: ColorsDoneView(selectedProfessions: self.$professionsListVM.selectedColors, showView: self.$showProfessionsList).environmentObject(self.gnomeListVM))
         .navigationBarTitle(Text("Selected Colors: \(self.professionsListVM.selectedColors.count)"))
      }
   }
}

struct ColorsDoneView: View {
   @EnvironmentObject var gnomeListVM: GnomeListVM
   @Binding var selectedProfessions: [String]
   @Binding var showView: Bool
   var body: some View {
      Button(action: {
            self.gnomeListVM.selectedColors = self.selectedProfessions
            print(self.gnomeListVM.selectedColors.count)
         self.showView.toggle()
      }) {
         Text("Done")
      }
   }
}
