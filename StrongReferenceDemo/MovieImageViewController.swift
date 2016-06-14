//
//  MovieImageViewController.swift
//  StrongReferenceDemo
//
//  Created by Schmelter, Tim on 2/12/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

import UIKit

class MovieImageViewController: UIViewController {
    let bogusPropertyToShowMemoryUsage: [Date] = {  (0 ..< 100_000).map { _ in Date() } }()
    private static let placeholderImage = UIImage(named: "moviePlaceholder")!

    @IBOutlet weak var movieImage: UIImageView!

    var node: Node!
    var downloadableImage: DownloadableImage?
    var moreAlert: UIAlertController!
    
    deinit {
        Log.t()
    }

    override func viewDidLoad() {
        Log.t()
        title = node?.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "More", style: .plain, target: self, action: #selector(MovieImageViewController.handleMoreAction(_:)))
        
        // Download placeholder image from local cache
        guard let imageName = node?.imageName else {
            return
        }

        // PATTERN 1: Strong reference cycle in delegates
        // See also: DownloadableImage.swift
        downloadableImage = DownloadableImage(delegate: self)
        downloadableImage?.doDownload(imageName)
    }

    // MARK: - More
    
    func handleMoreAction(_ sender: UIBarButtonItem) {
        // setup share controller
        if(moreAlert == nil){
            let moreAlert = UIAlertController(title: "More", message: "Would you like to explore more titles in this category?", preferredStyle: .alert)
            
            // PATTERN 3: Closures capture references to `self`
            moreAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                let name = self.node.name
                UIApplication.shared().openURL(URL(string: "http://google.com/search?q="+name.urlEncodedString())!)
            }))
            
            moreAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                // cancel
            }))
            
            self.moreAlert = moreAlert
        }
        
        present(moreAlert, animated: true, completion: nil)
    }
}

extension MovieImageViewController: DownloadableImageDelegate {
    func imageDidDownload(_ image: UIImage) {
        movieImage.image = image
    }

    func imageFailedDownload(_ error: DownloadableImageError) {
        // Display appropriate error condition
    }
}
