//
//  DownloadableImage.swift
//  StrongReferenceDemo
//
//  Created by Schmelter, Tim on 2/12/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

import UIKit

protocol DownloadableImageDelegate {
    func imageDidDownload(_ image: UIImage)
    func imageFailedDownload(_ error: DownloadableImageError)
}

struct DownloadableImageError: ErrorProtocol {
    enum Reason {
        case noSuchImage
        case unsupportedFormat
        case invalidFileFormat
    }
    let reason: Reason
}

final class DownloadableImage {
    // PATTERN 1: Strong reference cycle in delegates
    // See also: MovieImageViewController.swift
    var delegate: DownloadableImageDelegate

    init(delegate: DownloadableImageDelegate) {
        Log.t()
        self.delegate = delegate
    }

    deinit {
        Log.t()
    }

    func doDownload(_ imageName: String) {
        guard let image = UIImage(named: imageName) else {
            delegate.imageFailedDownload(DownloadableImageError(reason: .noSuchImage))
            return
        }

        let delay = 0.75 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes.qosDefault).after(when: time) {
            // Get image from server
            DispatchQueue.main.async {
                // process...
                self.delegate.imageDidDownload(image)
            }
        }
    }

}
