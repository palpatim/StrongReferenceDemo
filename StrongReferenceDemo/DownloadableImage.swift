//
//  DownloadableImage.swift
//  StrongReferenceDemo
//
//  Created by Schmelter, Tim on 2/12/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

import UIKit

protocol DownloadableImageDelegate: class {
    func imageDidDownload(image: UIImage)
    func imageFailedDownload(error: DownloadableImageError)
}

struct DownloadableImageError: ErrorType {
    enum Reason {
        case NoSuchImage
        case UnsupportedFormat
        case InvalidFileFormat
    }
    let reason: Reason
}

final class DownloadableImage {
    // PATTERN 1: Strong reference cycle in delegates
    // See also: MovieImageViewController.swift
    weak var delegate: DownloadableImageDelegate?

    init(delegate: DownloadableImageDelegate) {
        Log.t()
        self.delegate = delegate
    }

    deinit {
        Log.t()
    }

    func doDownload(imageName: String) {
        guard let image = UIImage(named: imageName) else {
            delegate?.imageFailedDownload(DownloadableImageError(reason: .NoSuchImage))
            return
        }

        let delay = 0.75 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            // Get image from server
            dispatch_async(dispatch_get_main_queue()) {
                // process...
                self.delegate?.imageDidDownload(image)
            }
        }
    }

}
