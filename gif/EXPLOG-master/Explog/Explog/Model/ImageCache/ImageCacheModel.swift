//
//  ImageCache.swift
//  Explog
//
//  Created by MIN JUN JU on 2018. 1. 1..
//  Copyright © 2018년 becomingmacker. All rights reserved.
//

import Foundation
import AlamofireImage


// MARK: Image Cache 
struct Store {
    static var shared: Store = Store()
    var imageCache: AutoPurgingImageCache = AutoPurgingImageCache(memoryCapacity: 900_000_000_000,
                                                                         preferredMemoryUsageAfterPurge: 60_000_000)
    private init() {}
}



