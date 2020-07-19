//
//  AgeFilterView.swift
//  GnomeTown
//
//  Created by Waseem Tabrez on 18/07/20.
//  Copyright © 2020 Waseem Tabrez. All rights reserved.
//

import SwiftUI

struct AgeFilterView: View {
   @EnvironmentObject var ageFilterVM : AgeFilterVM
   @EnvironmentObject var gnomeListVM: GnomeListVM
   @Binding var showAgeFilter: Bool
   var body: some View {
      NavigationView {
         VStack {
            VStack {
               TextField("Enter age", text: self.$ageFilterVM.selectedAgeString).padding().keyboardType(.numberPad)
            }.background(Color(UIColor.systemGray5))
            .clipShape(Capsule())
            .border(Color(UIColor.systemGray6))
            VStack {
               VStack(alignment: .leading) {
                  HStack {
                     Text("Age Parameters").background(Color(UIColor.systemGray5))
                     Spacer()
                  }
               }.background(Color(UIColor.systemGray5)).padding()
               .clipShape(Capsule())
               ForEach(self.ageFilterVM.ageTypes, id: \.self) { item in
                  Button(action: {
                     self.ageFilterVM.set(ageType: item)
                  }, label: {
                     VStack {
                        HStack {
                           Text(LocalizedStringKey(item.rawValue))
                              .foregroundColor(self.ageFilterVM.selectedAgeType == item ? Color.green : Color.secondary)
                              .padding(.leading, 8)
                              .onTapGesture {
                                 self.ageFilterVM.set(ageType: item)
                           }
                           Spacer()
                           ZStack {
                              Circle()
                                 .fill(self.ageFilterVM.selectedAgeType == item ? Color.green : Color.secondary)
                                 .frame(width: 18, height: 18)
                              if self.ageFilterVM.selectedAgeType == item {
                                 Circle().stroke(Color.green, lineWidth: 2).frame(width: 25, height: 25)
                              } else {
                                 Circle().stroke(Color.clear, lineWidth: 2).frame(width: 25, height: 25)
                              }
                           }.padding(.trailing, 8)
                        }
                     }
                  }).background(Color.clear)
                     .padding([.horizontal], 3)
               }.background(Color(UIColor.systemGray5))
            }.padding().background(Color(UIColor.systemGray5)).cornerRadius(20)
            Spacer()
         }
         .navigationBarItems(trailing: AgeFilterDoneView(selectedAgeString: self.$ageFilterVM.selectedAgeString, selectedAgeType: self.$ageFilterVM.selectedAgeType, showView: self.$showAgeFilter).environmentObject(self.gnomeListVM))
         .navigationBarTitle(Text("Age Filter"))
      }
   }
}

struct AgeFilterDoneView: View {
   @EnvironmentObject var gnomeListVM: GnomeListVM
   @Binding var selectedAgeString: String
   @Binding var selectedAgeType: AgeFilter
   @Binding var showView: Bool
   var body: some View {
      Button(action: {
         self.gnomeListVM.ageChoosen = Int(self.selectedAgeString) ?? 0
         self.gnomeListVM.ageFilter = self.selectedAgeType
         print(self.gnomeListVM.selectedColors.count)
         self.showView.toggle()
      }) {
         Text("Done")
      }
   }
}


struct AgeFilterView_Previews: PreviewProvider {
    static var previews: some View {
      AgeFilterView(showAgeFilter: Binding.constant(true))
    }
}
