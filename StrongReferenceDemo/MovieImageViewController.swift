//
//  MovieImageViewController.swift
//  StrongReferenceDemo
//
//  Created by Schmelter, Tim on 2/12/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

import UIKit

class MovieImageViewController: UIViewController {
    private static let placeholderImage = UIImage(named: "moviePlaceholder")!

    @IBOutlet weak var movieImage: UIImageView!

    var node: Node?
    var downloadableImage: DownloadableImage?

    deinit {
        Log.t()
    }

    override func viewDidLoad() {
        title = node?.name ?? "Movie"

        // Download placeholder image from local cache
        guard let imageName = node?.imageName else {
            return
        }

        // PATTERN 1: Strong reference cycle in delegates
        // See also: DownloadableImage.swift
        downloadableImage = DownloadableImage(delegate: self)
        downloadableImage?.doDownload(imageName)
    }

}

extension MovieImageViewController: DownloadableImageDelegate {
    func imageDidDownload(image: UIImage) {
        movieImage.image = image
    }

    func imageFailedDownload(error: DownloadableImageError) {
        // Display appropriate error condition
    }
}
