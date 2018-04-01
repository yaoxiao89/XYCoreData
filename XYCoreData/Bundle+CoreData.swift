//
//  Bundle+CoreData.swift
//  XYCoreData
//
//  Copyright © 2018 Xiao Yao. All rights reserved.
//  See LICENSE.txt for licensing information
//

import Foundation

// MARK: - Bundle

extension Bundle {
    
    class func findCoreDataModel(name: String) -> URL? {
        var bundles = Bundle.allBundles
        bundles.append(contentsOf: Bundle.allFrameworks)
        for bundle in bundles {
            if let url = bundle.url(forResource: name, withExtension: "momd") {
                return url
            }
        }
        return nil
    }
    
}
