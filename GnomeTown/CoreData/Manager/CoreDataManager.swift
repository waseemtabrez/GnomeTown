//
//  CoreDataManager.swift
//  GnomeTown
//
//  Created by Waseem Tabrez on 15/07/20.
//  Copyright © 2020 Waseem Tabrez. All rights reserved.
//

import Foundation
import CoreData

struct CoredataManager {
   static let shared = CoredataManager(viewContext: NSManagedObjectContext.viewContext, bckContext: NSManagedObjectContext.backgroundContext)
   var managedObjectContextView: NSManagedObjectContext
   var managedObjectContextBck: NSManagedObjectContext

   private init(viewContext: NSManagedObjectContext, bckContext: NSManagedObjectContext) {
      self.managedObjectContextView = viewContext
      self.managedObjectContextBck = bckContext
   }
   
   func save(gnomes: [GnomeModel]) {
      var gnomesMO = [Gnome]()
      for type in gnomes {
         let entity = Gnome(context: self.managedObjectContextBck)
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
      self.managedObjectContextBck.performAndWait {
         do {
            try self.managedObjectContextBck.save()
         } catch {
            print(error)
         }
         self.managedObjectContextBck.reset()
      }
   }
   
   func deletePreviouslyStoredData() {
      let fetchRequest: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Gnome")
      let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
      
      self.managedObjectContextBck.performAndWait {
         do {
            try self.managedObjectContextBck.executeAndMergeChanges(withBatchDeleteRequest: batchDeleteRequest)
            
            print("Coredata Items after Batch deletion: \(CoredataManager.shared.fetchAllTypes()?.count ?? 45)")
         } catch {
            print("Can't delete the Coredata objects")
         }
         self.managedObjectContextBck.reset()
      }
   }
   
   func fetchBy(name: String) -> GnomeModel? {
      var accounts = [Gnome]()
      let request: NSFetchRequest<Gnome> = Gnome.fetchRequest()
      request.predicate = NSPredicate(format: "name == %@", name as CVarArg)
      
      do {
         accounts = try self.managedObjectContextView.fetch(request)
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
         gnomeEntityArray = try self.managedObjectContextView.fetch(gnomeFetchRequest)
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
