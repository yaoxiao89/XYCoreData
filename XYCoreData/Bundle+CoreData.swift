//
//  Bundle+CoreData.swift
//  XYCoreData
//
//  Created by Xiao Yao on 12/19/17.
//  Copyright © 2017 Xiao Yao. All rights reserved.
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
