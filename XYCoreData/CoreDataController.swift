//
//  CoreDataController.swift
//  XYCoreData
//
//  Copyright © 2018 Xiao Yao. All rights reserved.
//  See LICENSE.txt for licensing information
//

import CoreData
import XYCommon
import XYUserDefaults

// MARK: - CoreDataControllerObserver

@objc public protocol CoreDataControllerObserver: AnyObject {
    
    func refreshData()
    
}

// MARK: - CoreDataController

public class CoreDataController {
    
    public let persistentContainer: NSPersistentContainer
    
    private let userDefaults: UserDefaults?
    private let bundle: Bundle
    
    private var notificationToken: NotificationToken?
    
    private let observers = NSHashTable<CoreDataControllerObserver>.weakObjects()
    
    public var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    public var shouldRefreshData: Bool {
        guard let lastBundleID = userDefaults?.lastBundleIDToPersist else { return false }
        return lastBundleID != bundle.bundleIdentifier
    }
    
    public init(groupID: String? = nil, bundle: Bundle = Bundle.main, name: String = "Database", completionHandler: @escaping (_ error: Error?) -> Void) {
        userDefaults = UserDefaults(suiteName: groupID)
        self.bundle = bundle
        
        persistentContainer = NSPersistentContainer(
            name: name,
            groupID: groupID,
            completionHandler: completionHandler
        )
        
        let center = NotificationCenter.default
        
        notificationToken = center.addObserver(forName: Notification.Name.NSManagedObjectContextDidSave) { [weak self] (note) in
            guard let `self` = self else { return }
            self.userDefaults?.lastBundleIDToPersist = self.bundle.bundleIdentifier
        }
        
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    public func refreshData() {
        observers.allObjects.forEach({ $0.refreshData() })
        userDefaults?.lastBundleIDToPersist = nil
    }
    
    public func addObserver(_ observer: CoreDataControllerObserver) {
        observers.add(observer)
    }
    
}

// MARK: - UserDefaults

extension UserDefaults {
    
    private struct CoreDataControllerKeySuffixes {
        static let lastBundleIDToPersist = "lastBundleIDToPersist"
    }
    
    var lastBundleIDToPersist: String? {
        get {
            return value(forKey: makeKey(for: CoreDataControllerKeySuffixes.lastBundleIDToPersist)) as? String
        }
        set {
            set(newValue, forKey: makeKey(for: CoreDataControllerKeySuffixes.lastBundleIDToPersist))
        }
    }
    
    func makeKey(for suffix: String) -> String {
        return "\(UserDefaults.keyPrefix).\(suffix)"
    }
    
}
