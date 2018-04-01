//
//  NSPersistentContainer+Factory.swift
//  XYCoreData
//
//  Copyright © 2017 Xiao Yao. All rights reserved.
//

import CoreData

extension NSPersistentContainer {
    
    public convenience init(name: String, groupID: String?, storeType: String = NSSQLiteStoreType, fileManager: FileManager = FileManager.default, completionHandler: @escaping (_ error: Error?) -> Void) {
        
        let modelURL = Bundle.findCoreDataModel(name: name)
        guard let URL = modelURL else {
            // TODO: Handle Error
            fatalError("Could not create URL for Core Data model")
        }
        
        guard let mom = NSManagedObjectModel(contentsOf: URL) else {
            // TODO: Handle Error
            fatalError("Could not load Core Data model at \(URL)")
        }
        
        self.init(name: name, managedObjectModel: mom)
        
        let storeURL: URL
        if let gID = groupID,
            let sURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: gID) {
            storeURL = sURL.appendingPathComponent("\(name).sqlite")
        } else {
            storeURL = URL
        }
        
        let description = NSPersistentStoreDescription(url: storeURL)
        description.type = storeType
        persistentStoreDescriptions = [description]
        
        loadPersistentStores { (storeDescription, error) in
            if let e = error {
                debugPrint("Could not load persistent stores: \(e)")
                completionHandler(e)
            } else {
                completionHandler(nil)
            }
        }
    }
    
}
