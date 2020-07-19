//
//  FilterView.swift
//  GnomeTown
//
//  Created by 837676 on 18/07/20.
//  Copyright © 2020 Syed Developers. All rights reserved.
//

import SwiftUI

struct FilterView: View {
   @Binding var showFilterView: Bool
   @State var showView: Bool = false
   @State var filterType: FilterType = .none
   @EnvironmentObject var gnomeListVM: GnomeListVM
   @ObservedObject var professionsVM: ProfessionsListVM = ProfessionsListVM()
   @ObservedObject var colorsVM: ColorsListVM = ColorsListVM()
   @ObservedObject var ageFilterVM: AgeFilterVM = AgeFilterVM()

    var body: some View {
      NavigationView{
         VStack(alignment: .leading){
            HStack{
               Button(action: {
                  self.filterType = .age
                  self.showView.toggle()
               }) {
                  Text("Age")
                     .foregroundColor(UITraitCollection.current.userInterfaceStyle == .dark ? Color.white : Color.black)
                     .font(.headline)
               }
               Spacer()
               if self.gnomeListVM.ageChoosen != 0 {
                  Text("\(self.gnomeListVM.ageFilter.rawValue) \(self.gnomeListVM.ageChoosen)")
               }
            }
         .padding()
            .background(Color(UIColor.systemGray5))
               .border(Color(UIColor.systemGray5))
               .cornerRadius(20)
            
            Divider().hidden()
            
            VStack(alignment: .center) {
               HStack{
                  Text("Colors")
                     .font(.headline)
                     .onTapGesture {
                        self.filterType = .colors
                        self.showView.toggle()
                  }
                  Spacer()
               }.padding()
               
               if self.gnomeListVM.selectedColors.count != 0 {
                  HStack(alignment: .firstTextBaseline) {
                     ForEach(self.gnomeListVM.selectedColors, id: \.self) { item in
                        HStack{
                           Text(item).font(.footnote).padding(2)
                              .fixedSize(horizontal: true, vertical: true)
                           Image(systemName: "xmark.circle").foregroundColor(Color.red)
                              .onTapGesture {
                                 self.gnomeListVM.removeSelectedColors(color: item)
                           }
                           }.fixedSize(horizontal: true, vertical: true)
                        .padding(4)
                        .overlay(Capsule().stroke(Color.blue.opacity(0.8), lineWidth: 1))
                     }
                     Spacer()
                  }.padding([.bottom, .leading])
               }
            }
            .background(Color(UIColor.systemGray5))
            .border(Color(UIColor.systemGray5))
            .cornerRadius(20)

            Divider().hidden()
            VStack(alignment: .leading) {
               HStack{
                  Text("Professions")
                     .font(.headline)
                     .onTapGesture {
                        self.filterType = .professions
                        self.showView.toggle()
                  }
                  Spacer()
               }.padding()
               
               if self.gnomeListVM.selectedProfessions.count != 0 {
                     VStack(alignment: .leading) {
                        List{
                        ForEach(self.gnomeListVM.selectedProfessions, id: \.self) { item in
                           
                           
                           HStack{
                              Text(item).font(.footnote).padding(2)
                                 .fixedSize(horizontal: true, vertical: true)
                              Button(action: {
                                 self.gnomeListVM.removeSelectedProfessions(profession: item)
                              }) {
                                    Image(systemName: "xmark.circle").foregroundColor(Color.red)
                              }
                           }
                              .listRowBackground(Color(UIColor.systemGray5))
                           .frame(height: 20)
                              .padding(4)
                              .overlay(Capsule().stroke(Color.blue.opacity(0.8), lineWidth: 1))
                           
                        }.listRowBackground(Color(UIColor.systemGray5))
                        } .frame(height: CGFloat(self.gnomeListVM.selectedProfessions.count <= 10 ? self.gnomeListVM.selectedProfessions.count : 10) * CGFloat(30)+12)

                      
                        .listRowBackground(Color(UIColor.systemGray5))

                        }.frame(height: CGFloat(self.gnomeListVM.selectedProfessions.count <= 10 ? self.gnomeListVM.selectedProfessions.count : 10) * CGFloat(30)+20)
                        .padding([.bottom, .horizontal]).listRowBackground(Color(UIColor.systemGray5))
                  .onAppear{
                     UITableView.appearance().separatorStyle = .none
                  }
               }

            }
            .background(Color(UIColor.systemGray5))
            .border(Color(UIColor.systemGray5))
            .cornerRadius(20)

            Spacer().listRowBackground(Color(UIColor.systemGray5))
               
            .navigationBarTitle("Filters")
            }.padding()
         .sheet(isPresented: self.$showView) {
            if self.filterType == .professions {
               ProfessionsListView(showProfessionsList: self.$showView)
                  .environmentObject(self.gnomeListVM)
                  .environmentObject(self.professionsVM)
            } else if self.filterType == .colors {
               ColorsListView(showProfessionsList: self.$showView)
                  .environmentObject(self.gnomeListVM)
                  .environmentObject(self.colorsVM)
            } else if self.filterType == .age {
               AgeFilterView(showAgeFilter: self.$showView)
                  .environmentObject(self.gnomeListVM)
                  .environmentObject(self.ageFilterVM)
            }
         }
         .navigationBarItems(leading: ClearFiltersView().environmentObject(self.gnomeListVM), trailing: FiltersDoneView(showView: self.$showFilterView ).environmentObject(self.gnomeListVM))
      }.listRowBackground(Color(UIColor.systemGray5))
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
      FilterView(showFilterView: Binding.constant(true))
    }
}

enum FilterType {
   case colors
   case professions
   case age
   case none
}


struct ClearFiltersView: View {
   @EnvironmentObject var gnomeListVM: GnomeListVM
   var body: some View {
      Button(action: {
         self.gnomeListVM.selectedProfessions.removeAll()
         self.gnomeListVM.selectedColors.removeAll()
      }) {
         Text("Clear Filters")
      }
   }
}

struct FiltersDoneView: View {
   @EnvironmentObject var gnomeListVM: GnomeListVM
   @Binding var showView: Bool
   var body: some View {
      Button(action: {
         self.showView.toggle()
         if (!self.gnomeListVM.selectedColors.isEmpty || !self.gnomeListVM.selectedProfessions.isEmpty){
            self.gnomeListVM.loading = true
            self.gnomeListVM.filter = true
         } else {
            self.gnomeListVM.loading = true
            self.gnomeListVM.loadDataFromServer = false
         }
      }) {
         Text("Done")
      }
   }
}
