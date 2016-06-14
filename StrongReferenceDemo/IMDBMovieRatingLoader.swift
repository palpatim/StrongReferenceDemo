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
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes.qosDefault).after(when: time) {
            // Get rating from interwebs
            let rating = Int(arc4random_uniform(5) + 1)
            DispatchQueue.main.async {
                self.completionHandler(self.cell, rating)
            }
        }
    }

}
