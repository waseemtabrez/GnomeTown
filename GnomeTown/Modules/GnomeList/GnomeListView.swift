//
//  GnomeListView.swift
//  GnomeTown
//
//  Created by Waseem Tabrez on 17/07/20.
//  Copyright © 2020 Waseem Tabrez. All rights reserved.
//

import SwiftUI

struct GnomeListView: View {
   @Environment(\.presentationMode) var presentation
   @EnvironmentObject var gnomeListVM: GnomeListVM
   @State var showGnomeList = false
   @State var showAlertNoInternet = false
   @State var showAlertNoData = false
    var body: some View {
      NavigationView{
         VStack{
            if self.gnomeListVM.loading {
               ZStack(alignment: .center){
               ActivityIndicator(isAnimating: self.$gnomeListVM.loading, style: .large).onAppear{
                  if self.gnomeListVM.filter {
                     self.gnomeListVM.filterResults(completion: {
                        DispatchQueue.main.async {
                           self.gnomeListVM.loading = false
                           self.gnomeListVM.filter = false
                        }
                     })
                  } else if !self.gnomeListVM.loadDataFromServer {
                     self.gnomeListVM.loadGnomes()
                  }
                  
                     Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                           print("Timer fired!")
                        self.gnomeListVM.runCount += 1
                           
                           if self.gnomeListVM.runCount == 5 {
                              timer.invalidate()
                              self.gnomeListVM.runCount = 0
                              self.gnomeListVM.loading = false
                           } else if self.gnomeListVM.loading == true {
                              timer.invalidate()
                              self.gnomeListVM.runCount = 0
                           } else if self.gnomeListVM.internetAvailable {
                              timer.invalidate()
                              self.gnomeListVM.runCount = 0
                              if self.gnomeListVM.gnomesFetched.isEmpty{
                                 self.gnomeListVM.loadGnomes()
                                 self.gnomeListVM.loading = true
                              } else {
                                 self.gnomeListVM.loading = false
                              }
                           } else if !self.gnomeListVM.gnomesFetched.isEmpty{
                              timer.invalidate()
                              self.gnomeListVM.loading = false
                        }
                        }
                     }
            }
            } else {
               if self.gnomeListVM.gnomesFetched.count == 0 {
                  VStack{
                     if self.gnomeListVM.gnomesFetched.count == 0 {
                        Text("No Gnomes Found").padding()
                     }
                        if !self.gnomeListVM.internetAvailable {
                           Text("Restore Internet connection and Refresh")
                              
                              .alert(isPresented: self.$showAlertNoInternet, content: {
                                 Alert(title: Text("No Internet Connection"), message: Text("Turn on Wifi or Cellular data to get the data from server."), dismissButton: .default(Text("Ok")))})
                              .onDisappear{
                                 self.gnomeListVM.loadDataFromServer = true
                                 self.gnomeListVM.loadGnomes()
                           }
                        }
                  }
               } else {
                  List{
                     ForEach(self.gnomeListVM.gnomesFetched, id: \.self) { (gnome: GnomeModel) in
                        
                        NavigationLink(destination: GnomeDetailsView(gnome: gnome)) {
                           GnomeItemView(gnomeModel: gnome)
                        }
                     }
                  }
                  .onAppear{
                     if !self.gnomeListVM.internetAvailable {
                        self.showAlertNoInternet = true
                     }
                  }
                  .alert(isPresented: self.$showAlertNoInternet, content: {
                     Alert(title: Text("No Internet Connection"), message: Text("Turn on Wifi or Cellular data to get the data from server."), dismissButton: .default(Text("Ok")))})
               }
            }
         }
         
         .sheet(isPresented: self.$showGnomeList, content: {
            FilterView(showFilterView: self.$showGnomeList).environmentObject(self.gnomeListVM)
         })
            .onAppear{
               if self.gnomeListVM.gnomesFetched.isEmpty {
                  self.gnomeListVM.loadDataFromServer = true
                  self.gnomeListVM.loading = true
                  self.gnomeListVM.checkInternetIsAvailable(completion: { (response) in
                     DispatchQueue.main.async {
                        self.gnomeListVM.internetAvailable = response
                        self.showAlertNoInternet = !response
                        self.gnomeListVM.loadGnomes()
                     }
                  })
               }
         }
      .navigationBarTitle("Brastlewark Crew")
         .navigationBarItems(leading: RefreshView(showAlert: self.$showAlertNoInternet).environmentObject(self.gnomeListVM), trailing: ShowFilterButton(showFilterView: self.$showGnomeList, showAlert: self.$showAlertNoData)
            .environmentObject(self.gnomeListVM))
      }
    }
}

enum AlertTypes {
   case noInternet
   case noData
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

         self.gnomeVM.checkInternetIsAvailable(completion: { (response) in
            DispatchQueue.main.async {
               self.gnomeVM.internetAvailable = response

               if self.gnomeVM.internetAvailable{
                  self.gnomeVM.loading = true
                  self.gnomeVM.loadDataFromServer = true
                  self.gnomeVM.loadGnomes()
               } else {
                     self.showAlert.toggle()
               }
            }
         })

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
   @Binding var showAlert: Bool
   var body: some View {
      HStack{
         Spacer()
         Button(action: {
            if self.gnomeListVM.gnomesFetched.isEmpty{
               self.showAlert.toggle()
            } else {
               self.showFilterView.toggle()
               self.presentation.wrappedValue.dismiss()
            }
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
