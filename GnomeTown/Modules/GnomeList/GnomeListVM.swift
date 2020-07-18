//
//  GnomeListVM.swift
//  GnomeTown
//
//  Created by 837676 on 17/07/20.
//  Copyright © 2020 Syed Developers. All rights reserved.
//

import Foundation
import CoreData

class GnomeListVM: ObservableObject {
   var dataStore = DataProvider(repository: NetworkManager.shared)
   @Published var gnomesFetched = [GnomeModel]()
   @Published var loading: Bool = false
   
   init() {
      self.gnomesFetched = CoredataManager.shared.fetchAllTypes()?.sorted(by: { $0.identifier ?? 0 < $1.identifier ?? 1 }) ?? [GnomeModel]()
   }
   
   func loadGnomes(){
      dataStore.fetchGnomes { (error) in
         guard error == nil else {
            print("Error retrieving data")
            return
         }
         
         let someArr = CoredataManager.shared.fetchAllTypes()?.sorted(by: { $0.identifier ?? 0 < $1.identifier ?? 1 }) ?? [GnomeModel]()
         DispatchQueue.main.async {
            self.gnomesFetched.removeAll()
            self.gnomesFetched.append(contentsOf: someArr)
            print("FetchedItemsNew!!!: \(self.gnomesFetched.count)")
            self.loading = false
         }
      }
   }
}
