//
//  MOCExtension.swift
//  GnomeTown
//
//  Created by 837676 on 15/07/20.
//  Copyright © 2020 Syed Developers. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
   static var currentContext: NSManagedObjectContext {
      return CoreDataCustomStack.shared.persistentContainer.viewContext
   }
   
   static var currentStore: NSPersistentCloudKitContainer {
      return CoreDataCustomStack.shared.persistentContainer
   }
   
   /// Executes the given `NSBatchDeleteRequest` and directly merges the changes to bring the given managed object context up to date.
   ///
   /// - Parameter batchDeleteRequest: The `NSBatchDeleteRequest` to execute.
   /// - Throws: An error if anything went wrong executing the batch deletion.
   public func executeAndMergeChanges(withBatchDeleteRequest request: NSBatchDeleteRequest) throws {
      request.resultType = .resultTypeObjectIDs
      let result = try execute(request) as? NSBatchDeleteResult
      let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: result?.result as? [NSManagedObjectID] ?? []]
      NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self])
   }

}

extension Array where Element:Equatable {
   func removeDuplicates() -> [Element] {
      var result = [Element]()
      
      for value in self {
         if result.contains(value) == false {
            result.append(value)
         }
      }
      
      return result
   }
}
