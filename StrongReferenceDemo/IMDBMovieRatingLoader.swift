//
//  IMDBMovieRatingLoader.swift
//  StrongReferenceDemo
//
//  Created by Schmelter, Tim on 2/12/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

import Foundation

class IMDBMovieRatingLoader {
    typealias CompletionHandler = (NodeCell, Int) -> Void

    var cell: NodeCell
    let completionHandler: CompletionHandler

    /**
     Retrieves the movie's latest rating from the Interwebs, then invokes
     `completionHandler` on the main queue

     - parameter node: node to retrieve
     */
    init(cell: NodeCell, completionHandler: CompletionHandler) {
        Log.t()
        self.cell = cell
        self.completionHandler = completionHandler
        getRating()
    }

    deinit {
        Log.t()
    }

    func getRating() {
        let delay = 0.5 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            // Get rating from interwebs
            let rating = Int(arc4random_uniform(5) + 1)
            dispatch_async(dispatch_get_main_queue()) {
                self.completionHandler(self.cell, rating)
            }
        }
    }

}
