//
//  ContentView.swift
//  GnomeTown
//
//  Created by Waseem Tabrez on 15/07/20.
//  Copyright © 2020 Waseem Tabrez. All rights reserved.
//

import SwiftUI

struct ContentView: View {
   @State private var selection = 0
   @ObservedObject var gnomeListVM = GnomeListVM()
   @ObservedObject var gnomeFilterVM = GnomeFilterVM()
   
   
   var body: some View {
      TabView(selection: self.$selection){
         GnomeListView().environmentObject(self.gnomeListVM)
            .tabItem {
               VStack {
                  Image(systemName: "person.3.fill")
                  Text("Brastlewark Crew")
               }
         }.tag(0)
         
         BrastlewarkDashboardView()
            .environmentObject(self.gnomeListVM)
            .environmentObject(self.gnomeFilterVM)
            .tabItem {
               VStack {
                  Image(systemName: "house")
                  Text("Home")
               }
         }
         .tag(1)
      }.onAppear{
         self.gnomeListVM.loadDataFromServer = true
         self.gnomeListVM.loadGnomes()
      }
   }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
