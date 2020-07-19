//
//  GnomeListView.swift
//  GnomeTown
//
//  Created by 837676 on 17/07/20.
//  Copyright © 2020 Syed Developers. All rights reserved.
//

import SwiftUI

struct GnomeListView: View {
   @Environment(\.presentationMode) var presentation
   @EnvironmentObject var gnomeListVM: GnomeListVM
   @State var showGnomeList = false
   @State var showAlert = false
    var body: some View {
      NavigationView{
         Group{
            if self.gnomeListVM.loading {
               ActivityIndicator(isAnimating: self.$gnomeListVM.loading, style: .large).onAppear{
                  if self.gnomeListVM.filter {
                     self.gnomeListVM.filterResults()
                  } else if !self.gnomeListVM.loadDataFromServer {
                     self.gnomeListVM.loadGnomes()
                  }
                  
                  if self.gnomeListVM.loading {
                     self.gnomeListVM.runCount = 0
                     Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                           print("Timer fired!")
                        self.gnomeListVM.runCount += 1
                           
                           if self.gnomeListVM.runCount == 5 {
                              timer.invalidate()
                              self.gnomeListVM.loading = false
                           } else if self.gnomeListVM.loading == true {
                              timer.invalidate()
                           }
//                           else {
//                              if self.gnomeListVM.gnomesFetched.count != 0 {
//                                 timer.invalidate()
//                                 self.gnomeListVM.loading = false
//                              }
//                           }
                        }
                     }
               }
            } else {
               
               if self.gnomeListVM.gnomesFetched.count == 0 {
                  VStack{
                     Text("No Gnomes Found").padding()
                     if !self.gnomeListVM.internetAvailable {
                        Text("Restore Internet connection and Refresh")
                     }
                  }
               } else {
                  List{
                     ForEach(self.gnomeListVM.gnomesFetched, id: \.self) { (gnome: GnomeModel) in
                        
                        NavigationLink(destination: GnomeDetailsView(gnome: gnome)) {
                           GnomeItemView(gnomeModel: gnome)
                        }
                     }
                  }.onAppear{
                     if self.gnomeListVM.filter {
                        self.gnomeListVM.filterResults()
                     }
                     self.gnomeListVM.loading = false
                  }
               }
            }

         }.onAppear{
            if self.gnomeListVM.filter {
               self.gnomeListVM.filterResults() 
            }
         }
         .alert(isPresented: self.$showAlert, content: {
            Alert(title: Text("No Internet Connection"), message: Text("Turn on Wifi or Cellular data to get the data from server."), dismissButton: .default(Text("Ok")))
         })
         .sheet(isPresented: self.$showGnomeList, content: {
            FilterView(showFilterView: self.$showGnomeList).environmentObject(self.gnomeListVM)
         })
            .onAppear{
               self.gnomeListVM.checkInternetIsAvailable()
         }
      .navigationBarTitle("Brastlewark Crew")
            .navigationBarItems(leading: RefreshView(showAlert: self.$showAlert).environmentObject(self.gnomeListVM), trailing: ShowFilterButton(showFilterView: self.$showGnomeList).environmentObject(self.gnomeListVM))
      }
    }
}

struct GnomeListView_Previews: PreviewProvider {
    static var previews: some View {
        GnomeListView()
    }
}

struct RefreshView: View {
   @EnvironmentObject var gnomeVM: GnomeListVM
   @Binding var showAlert: Bool
   var body: some View {
      Button(action: {
         self.gnomeVM.checkInternetIsAvailable()
         if self.gnomeVM.internetAvailable{
            self.gnomeVM.loading = true
            self.gnomeVM.loadDataFromServer = true
            self.gnomeVM.loadGnomes()
         } else {
            self.showAlert.toggle()
         }
      }) {
         Image(systemName: "icloud.and.arrow.down")
      }
   }
}

struct ClearAllFiltersView: View {
   @EnvironmentObject var gnomeVM: GnomeListVM
   var body: some View {
      Button(action: {
         self.gnomeVM.selectedColors.removeAll()
         self.gnomeVM.selectedProfessions.removeAll()
         self.gnomeVM.ageChoosen = 0
         self.gnomeVM.ageFilter = .none
         self.gnomeVM.loading = true
         self.gnomeVM.loadDataFromServer = true
         self.gnomeVM.loadGnomes()
      }) {
         Image(systemName: "xmark.circle").foregroundColor(Color.red)
      }
   }
}


struct ShowFilterButton: View {
   @Environment(\.presentationMode) var presentation
   @EnvironmentObject var gnomeListVM: GnomeListVM
   @Binding var showFilterView: Bool
   var body: some View {
      HStack{
         Spacer()
         Button(action: {
            self.showFilterView.toggle()
            self.presentation.wrappedValue.dismiss()
         }) {
            Image(systemName: "line.horizontal.3.decrease.circle")
         }
         
         if !(self.gnomeListVM.selectedProfessions.isEmpty && self.gnomeListVM.selectedColors.isEmpty && self.gnomeListVM.ageChoosen == 0) {
            ClearAllFiltersView().environmentObject(self.gnomeListVM)
         }
      }
   }
}

struct GnomeItemView: View {
   var gnomeModel: GnomeModel
   
   var body: some View {
      HStack {
         ImageFromURLView(urlString: gnomeModel.thumbnail, isDetailView: false)
         VStack(alignment: .leading) {
            Text("\(gnomeModel.name!)")
               .font(.headline)
         }
      }
   }
}
