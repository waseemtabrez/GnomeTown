//
//  CoreDataManager.swift
//  GnomeTown
//
//  Created by 837676 on 15/07/20.
//  Copyright © 2020 Syed Developers. All rights reserved.
//

import Foundation
import CoreData

struct CoredataManager {
   static let shared = CoredataManager(moContext: NSManagedObjectContext.currentContext)
   var managedObjectContext: NSManagedObjectContext
   
   private init(moContext: NSManagedObjectContext) {
      self.managedObjectContext = moContext
   }
   
   func save(gnomes: [GnomeModel]) {
      var gnomesMO = [Gnome]()
      for type in gnomes {
         let entity = Gnome(context: self.managedObjectContext)
         entity.name = type.name
         guard let identifier = type.identifier, let age = type.age else {
            return
         }
         entity.identifier = Int16(identifier)
         entity.age = Int16(age)
         entity.height = type.height ?? 0.0
         entity.weight = type.weight ?? 0.0
         entity.hairColor = type.hairColor ?? ""
         entity.professions = (type.professions ?? [String]())
         entity.friends = (type.friends ?? [String]())
         entity.thumbnail = type.thumbnail
         
         gnomesMO.append(entity)
      }
      self.managedObjectContext.performAndWait {
         do {
            try self.managedObjectContext.save()
//            completion()
         } catch {
            print(error)
//            completion()
         }
      }
   }
   
   func deletePreviouslyStoredData() {
      let fetchRequest: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Gnome")
      let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
      
      self.managedObjectContext.performAndWait {
         do {
            try self.managedObjectContext.executeAndMergeChanges(withBatchDeleteRequest: batchDeleteRequest)
            
            print("Coredata Items after Batch deletion: \(CoredataManager.shared.fetchAllTypes()?.count ?? 45)")
//            completion()
         } catch {
            print("Can't delete the Coredata objects")
         }
      }
   }
   
   func fetchAllTypes() -> [GnomeModel]? {
      var accountTypes = [Gnome]()
      var accountTypesInModel  = [GnomeModel]()
      let accountRequest: NSFetchRequest<Gnome> = Gnome.fetchRequest()
      
      do {
         accountTypes = try self.managedObjectContext.fetch(accountRequest)
      } catch let error as NSError {
         print(error)
      }
      
      for accountType in accountTypes {
         var item = GnomeModel()
         item.name = accountType.name
         item.identifier = Int(accountType.identifier)
         item.age = Int(accountType.age)
         item.height = accountType.height
         item.weight = accountType.weight
         item.hairColor = accountType.hairColor ?? ""
         item.professions = (accountType.professions ?? [String]()) as [String]
         item.friends = (accountType.friends ?? [String]()) as [String]
         item.thumbnail = accountType.thumbnail
         
         
         accountTypesInModel.append(item)
      }
      return accountTypesInModel
   }
}
