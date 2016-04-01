//
//  MovieImageViewController.swift
//  StrongReferenceDemo
//
//  Created by Schmelter, Tim on 2/12/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

import UIKit

class MovieImageViewController: UIViewController {
    let bogusPropertyToShowMemoryUsage: [NSDate] = {  (0 ..< 100_000).map { _ in NSDate() } }()
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "More", style: .Plain, target: self, action: Selector("handleMoreAction:"))
        
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
    
    func handleMoreAction(sender: UIBarButtonItem) {
        // setup share controller
        if(moreAlert == nil){
            let moreAlert = UIAlertController(title: "More", message: "Would you like to explore more titles in this category?", preferredStyle: .Alert)
            
            // PATTERN 3: Closures capture references to `self`
            moreAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { [unowned self] action in
                let name = self.node.name
                UIApplication.sharedApplication().openURL(NSURL(string: "http://google.com/search?q="+name.urlEncodedString())!)
            }))
            
            moreAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { action in
                // cancel
            }))
            
            self.moreAlert = moreAlert
        }
        
        presentViewController(moreAlert, animated: true, completion: nil)
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
