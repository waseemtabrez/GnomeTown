//
//  ProfessionsListView.swift
//  GnomeTown
//
//  Created by Waseem Tabrez on 18/07/20.
//  Copyright © 2020 Waseem Tabrez. All rights reserved.
//

import SwiftUI

struct ProfessionsListView: View {
   @EnvironmentObject var professionsListVM: ProfessionsListVM
   @EnvironmentObject var gnomeListVM: GnomeListVM
   @Binding var showProfessionsList: Bool
    var body: some View {
      NavigationView {
         List {
            ForEach(self.professionsListVM.professions, id: \.self) { item in
               Button(action: {
                  self.professionsListVM.addSelectedProfessions(profession: item)
               }, label: {
                  VStack {
                     HStack {
                        Text(LocalizedStringKey(item))
                           .foregroundColor(self.professionsListVM.selectedProfessions.contains(item) ? Color.green : Color.secondary)
                           .padding(.leading, 8)
                        Spacer()
                        ZStack {
                           Circle()
                              .fill(self.professionsListVM.selectedProfessions.contains(item) ? Color.green : Color.secondary)
                              .frame(width: 18, height: 18)
                           if self.professionsListVM.selectedProfessions.contains(item) {
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
         .navigationBarItems(trailing: ProfessionDoneView(selectedProfessions: self.$professionsListVM.selectedProfessions, showView: self.$showProfessionsList)
         .environmentObject(self.gnomeListVM))
         .navigationBarTitle(Text("Selected Professions: \(self.professionsListVM.selectedProfessions.count)"))
      }
    }
}

struct ProfessionDoneView: View {
   @EnvironmentObject var gnomeListVM: GnomeListVM
   @Binding var selectedProfessions: [String]
   @Binding var showView: Bool
   var body: some View {
      Button(action: {
         self.gnomeListVM.selectedProfessions = self.selectedProfessions
         print(self.gnomeListVM.selectedProfessions.count)
         self.showView.toggle()
      }) {
         Text("Done")
      }
   }
}

struct ProfessionsListView_Previews: PreviewProvider {
    static var previews: some View {
      ProfessionsListView(showProfessionsList: Binding.constant(true))
    }
}
