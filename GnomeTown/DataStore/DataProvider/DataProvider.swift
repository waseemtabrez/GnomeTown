//
//  DataProvider.swift
//  GnomeTown
//
//  Created by 837676 on 17/07/20.
//  Copyright © 2020 Syed Developers. All rights reserved.
//

import Foundation
import CoreData

struct DataProvider {
   
   private let repository: NetworkManager
      
   init(repository: NetworkManager) {
      self.repository = repository
   }
   
   func fetchGnomes(completion: @escaping(Error?) -> Void) {
      repository.getGnomes() { gnomes, error in
         if let error = error {
            completion(error)
            return
         }
         
         guard let jsonDictionary = gnomes else {
            let error = NSError(domain: dataErrorDomain, code: DataErrorCode.wrongDataFormat.rawValue, userInfo: nil)
            completion(error)
            return
         }
         
         _ = self.syncGnomes(gnomes: jsonDictionary, taskContext: NSManagedObjectContext.currentStore.newBackgroundContext())
         
         completion(nil)
      }
   }
   
   private func syncGnomes(gnomes: [GnomeModel], taskContext: NSManagedObjectContext) -> Bool {
      var successfull = false
      taskContext.performAndWait {
         //Deleting old records
         CoredataManager.shared.deletePreviouslyStoredData()
         
         // Create new records.
         CoredataManager.shared.save(gnomes: gnomes)
         
         // Saving all the changes just made and resetting the taskContext to free the cache.
         if taskContext.hasChanges {
            do {
               try taskContext.save()
            } catch {
               print("Error: \(error)\nCould not save Core Data context.")
            }
            taskContext.reset() // Resetting the context to clean up the cache and lower the memory footprint.
         }
         successfull = true
      }
      return successfull
   }
}
