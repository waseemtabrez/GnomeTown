//
//  GnomeListVM.swift
//  GnomeTown
//
//  Created by Waseem Tabrez on 17/07/20.
//  Copyright © 2020 Waseem Tabrez. All rights reserved.
//

import Foundation
import CoreData
import Network
import UserNotifications

class GnomeListVM: ObservableObject {
   var dataStore = DataProvider(repository: NetworkManager.shared)
   @Published var gnomesFetched = [GnomeModel]()
   @Published var totalGnomesFetched = [GnomeModel]()
   @Published var loading: Bool = true
   @Published var selectedProfessions = [String]()
   @Published var selectedColors = [String]()
   @Published var filter: Bool = false
   @Published var loadDataFromServer: Bool = true
   @Published var runCount: Int = 0
   @Published var ageChoosen: Int = 0
   @Published var ageFilter: AgeFilter = .none
   @Published var internetAvailable: Bool = true
   @Published var professionsCount: Int = 0
   @Published var hairColorsCount: Int = 0

   init() {
      self.gnomesFetched = CoredataManager.shared.fetchAllTypes()?.sorted(by: { $0.identifier ?? 0 < $1.identifier ?? 1 }) ?? [GnomeModel]()
   }
   
   func loadGnomes(){
      DispatchQueue.main.async {
         self.loading = true
      }
      checkInternetIsAvailable(completion: { (response) in
         DispatchQueue.main.async {
            self.internetAvailable = response
         }
      })
      if self.loadDataFromServer && self.internetAvailable {
         dataStore.fetchGnomes { (error) in
            guard error == nil else {
               DispatchQueue.main.async {
                  self.loading = false
               }
               print("Error retrieving data")
               return
            }
            DispatchQueue.main.async {
               self.deliverNotificationOnCompletion()
                  let someArr = CoredataManager.shared.fetchAllTypes()?.sorted(by: { $0.identifier ?? 0 < $1.identifier ?? 1 }) ?? [GnomeModel]()
                  self.totalGnomesFetched.removeAll()
                  self.totalGnomesFetched.append(contentsOf: someArr)
                  self.gnomesFetched.removeAll()
                  self.gnomesFetched.append(contentsOf: someArr)
                  print("FetchedItemsNew!!!: \(self.gnomesFetched.count)")
                  self.selectedColors.removeAll()
                  self.selectedProfessions.removeAll()
                  self.ageChoosen = 0
                  self.loading = false
//               self.filterResults(completion: {
//                  DispatchQueue.main.async {
//                     self.loading = false
//                     self.filter = false
//                  }
//               })
            }
         }
      } else {
         DispatchQueue.main.async {
            self.loading = true
            self.fetchLocalData { (fetchedGnomes) in
            DispatchQueue.main.async {
               if fetchedGnomes.isEmpty {
                  self.gnomesFetched.removeAll()
                  self.totalGnomesFetched.removeAll()
               } else {
                  self.totalGnomesFetched.removeAll()
                  self.totalGnomesFetched.append(contentsOf: fetchedGnomes)
                  self.gnomesFetched.removeAll()
                  self.gnomesFetched.append(contentsOf: fetchedGnomes)
               }
               self.loading = false
            }
         }
         }
      }
   }
   
   func fetchLocalData(completion: @escaping ([GnomeModel]) -> Void) {
      DispatchQueue.main.async {
         self.loading = true
         self.gnomesFetched.removeAll()
      }
      let fetchedResults = CoredataManager.shared.fetchAllTypes()?.sorted(by: { $0.identifier ?? 0 < $1.identifier ?? 1 }) ?? [GnomeModel]()
      if fetchedResults.isEmpty {
         completion([GnomeModel]())
      } else {
         completion(fetchedResults)
      }
   }
   
   func removeSelectedProfessions(profession: String) {
      selectedProfessions.removeAll { (item) -> Bool in
         item == profession
      }
   }
   
   func removeSelectedColors(color: String) {
      selectedColors.removeAll { (item) -> Bool in
         item == color
      }
   }
   
   func filterResults(completion: @escaping () -> Void) {
      DispatchQueue.main.async {
         self.loading.toggle()
      }
         if !self.selectedColors.isEmpty {
            self.gnomesFetched = self.gnomesFetched.filter { (gnome) -> Bool in
               self.selectedColors.contains(gnome.hairColor!)
            }
         }
      if !self.selectedProfessions.isEmpty {
         self.gnomesFetched = self.gnomesFetched.filter { (gnome) -> Bool in
            self.selectedProfessions.contains { (profession) in
               (gnome.professions?.contains(profession))!
            }
         }
      }
      
      if self.ageChoosen != 0 {
         self.gnomesFetched = self.gnomesFetched.filter({ (gnome) -> Bool in
            applyAgeFilterParam(age: gnome.age ?? 0)
         })
      }
      completion()
   }
   
   func applyAgeFilterParam(age: Int) -> Bool {
      switch self.ageFilter {
         case .equalTo:
            return age == self.ageChoosen
         case .lessThan:
            return age < self.ageChoosen
         case .greaterThan:
            return age > self.ageChoosen
         case .lessThanOrEqualTo:
            return age <= self.ageChoosen
         case .greaterThanOrEqualTo:
            return age >= self.ageChoosen

         default:
         return false
      }
   }
   
   func deliverNotificationOnCompletion() {
         let content = UNMutableNotificationContent()
         content.title = "Brastlewark"
         content.body = "Gnomes downloaded from the server"
         content.sound = UNNotificationSound.default
         let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
         let request = UNNotificationRequest(identifier: "BrastlewarkNotificationIdentifier", content: content, trigger: trigger)
         UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
   }
   
   func checkInternetIsAvailable(completion: @escaping (Bool) -> Void) {
      let monitor = NWPathMonitor()
      let queue = DispatchQueue(label: "InternetConnectionMonitor")
      monitor.pathUpdateHandler = { pathUpdateHandler in
         if pathUpdateHandler.status == .satisfied {
            completion(true)
         } else {
            completion(false)
         }
      }
      monitor.start(queue: queue)
   }
}

enum AgeFilter: String {
   case lessThan = "Less than"
   case greaterThan = "Greater than"
   case equalTo = "Equal to"
   case lessThanOrEqualTo = "Less than or equal to"
   case greaterThanOrEqualTo = "Greater than or equal to"
   case none = "None"
}
