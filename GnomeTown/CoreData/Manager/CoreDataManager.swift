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
         } catch {
            print(error)
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
         } catch {
            print("Can't delete the Coredata objects")
         }
      }
   }
   
   func fetchBy(name: String) -> GnomeModel? {
      var accounts = [Gnome]()
      let request: NSFetchRequest<Gnome> = Gnome.fetchRequest()
      request.predicate = NSPredicate(format: "name == %@", name as CVarArg)
      
      do {
         accounts = try self.managedObjectContext.fetch(request)
      } catch let error as NSError {
         print(error)
      }
      
      return gnomeEntityToModel(gnomes: accounts).first
   }
   
   private func gnomeEntityToModel(gnomes: [Gnome]) -> [GnomeModel] {
      var gnomesAsCustomModel  = [GnomeModel]()
      for currentGnome in gnomes {
         var item = GnomeModel()
         item.name = currentGnome.name!
         item.age = Int(currentGnome.age)
         item.identifier = Int(currentGnome.identifier)
         item.height = currentGnome.height
         item.weight = currentGnome.weight
         item.hairColor = currentGnome.hairColor
         item.thumbnail = currentGnome.thumbnail
         item.friends = currentGnome.friends
         item.professions = currentGnome.professions
         gnomesAsCustomModel.append(item)
      }
      return gnomesAsCustomModel
   }
   
   func fetchAllTypes() -> [GnomeModel]? {
      var gnomeEntityArray = [Gnome]()
      var gnomesAsCustomModel  = [GnomeModel]()
      let gnomeFetchRequest: NSFetchRequest<Gnome> = Gnome.fetchRequest()
      
      do {
         gnomeEntityArray = try self.managedObjectContext.fetch(gnomeFetchRequest)
      } catch let error as NSError {
         print(error)
      }
      
      for gnome in gnomeEntityArray {
         var item = GnomeModel()
         item.name = gnome.name
         item.identifier = Int(gnome.identifier)
         item.age = Int(gnome.age)
         item.height = gnome.height
         item.weight = gnome.weight
         item.hairColor = gnome.hairColor ?? ""
         item.professions = (gnome.professions ?? [String]()) as [String]
         item.friends = (gnome.friends ?? [String]()) as [String]
         item.thumbnail = gnome.thumbnail
         
         
         gnomesAsCustomModel.append(item)
      }
      return gnomesAsCustomModel
   }
}
