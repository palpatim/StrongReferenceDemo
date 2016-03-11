//
//  MovieListViewController.swift
//  StrongReferenceDemo
//
//  Created by Schmelter, Tim on 2/3/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

import UIKit

final class MovieListViewController: UITableViewController {
    let bogusPropertyToShowMemoryUsage: [NSDate] = {  (0 ..< 100_000).map { _ in NSDate() } }()
    var currentFolder: Node!
    var selectedNode: Node?

    var ratingsLoaders = [NodeCell: IMDBMovieRatingLoader?]()
    
    var shareController: UIAlertController!
    
    deinit {
        Log.t()
    }

    override func viewDidLoad() {
        Log.t()
        super.viewDidLoad()
        if currentFolder == nil {
            currentFolder = NodeDataSource.nodeById(0)
        }
        setupBackgroundView()
        tableView.separatorStyle = .SingleLine
        title = currentFolder.name ?? "Movies"
    }

    // MARK: - UIViewController overrides

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else {
            return
        }

        switch identifier {
        case "navigateToMovie":
            defer {
                selectedNode = nil
            }
            guard let movieImageViewController = segue.destinationViewController as? MovieImageViewController else {
                return
            }
            movieImageViewController.node = selectedNode
        default:
            break
        }
    }

    // MARK: - UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentFolder.childIds?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let node = nodeForIndexPath(indexPath) else {
            return UITableViewCell()
        }
        guard let cell = tableView.dequeueReusableCellWithIdentifier("NodeCell", forIndexPath: indexPath) as? NodeCell else {
            return UITableViewCell()
        }

        cell.node = node
        cell.textLabel?.text = cell.statusText

        if NodeDataSource.hasChildren(node) {
            // Folder
            cell.accessoryType = .DisclosureIndicator
            cell.detailTextLabel?.text = ""
        } else {
            // Individual Movie
            cell.accessoryType = .DetailButton
            if let imageName = node.imageName, image = UIImage(named: imageName) {
                cell.imageView?.image = image
            }

            getLatestRatingForCell(cell)
        }

        return cell
    }

    // MARK: - UITableViewDelegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let node = nodeForIndexPath(indexPath) else {
            return
        }
        if NodeDataSource.hasChildren(node) {
            navigateToFolder(node)
        } else {
            navigateToItem(node)
        }
    }

    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        self.tableView(tableView, didSelectRowAtIndexPath: indexPath)
    }

    // MARK: - Navigation

    private func navigateToFolder(node: Node) {
        guard let storyboard = self.storyboard else {
            return
        }
        guard let folderViewController = storyboard.instantiateViewControllerWithIdentifier("MovieListViewController") as? MovieListViewController else {
            return
        }
        folderViewController.currentFolder = node
        self.navigationController?.pushViewController(folderViewController, animated: true)
    }

    private func navigateToItem(node: Node) {
        selectedNode = node
        performSegueWithIdentifier("navigateToMovie", sender: self)
    }

    private func nodeForIndexPath(indexPath: NSIndexPath) -> Node? {
        let children = currentFolder.childIds ?? []
        let childId = children[indexPath.row]
        return NodeDataSource.nodeById(childId)
    }

    // MARK: - Ratings

    func getLatestRatingForCell(cell: NodeCell) {
        cell.detailTextLabel?.text = "Loading rating..."
        // PATTERN 2: Instance functions are partially-applied closures on `self`
        ratingsLoaders[cell] = IMDBMovieRatingLoader(cell: cell, completionHandler: updateCell)
    }

    private func updateCell(cell: NodeCell, withRating rating: Int) {
        guard let detailTextLabel = cell.detailTextLabel else {
            return
        }
        detailTextLabel.text = String(format: "%d stars", arguments: [rating])
    }
    
    // MARK: - Share
    
    @IBAction func handleShareAction(sender: UIBarButtonItem) {
        // setup share controller
        if(shareController == nil){
            let shareController = UIAlertController(title: "Share", message: "Would you like to share this category?", preferredStyle: .Alert)
            
            // PATTERN 3: Closures capture references to `self`
            shareController.addAction(UIAlertAction(title: "Share", style: .Default, handler: { action in
                let name = self.currentFolder.name
                let actionViewController = UIActivityViewController(activityItems: [name], applicationActivities: nil)
                self.presentViewController(actionViewController, animated: true, completion: nil)
            }))
            
            shareController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { action in
                // cancel
            }))
            
            self.shareController = shareController
        }
        
        presentViewController(shareController, animated: true, completion: nil)
    }


    // MARK: - Private utility methods

    private func setupBackgroundView() {
        let backgroundView = UIView(frame: tableView.frame)
        backgroundView.backgroundColor = UIColor(red: 252/255, green: 244/255, blue: 220/255, alpha: 1.0)

        let imageView = UIImageView(image: UIImage(named: "Arrows")!)
        let size = CGSize(width: 100, height: 100)
        let centerX = CGRectGetMidX(tableView.frame)
        let centerY = CGRectGetMidY(tableView.frame)
        let center = CGPoint(x: centerX, y: centerY)
        let frame = CGRect(center: center, size: size)
        imageView.frame = frame
        imageView.layer.opacity = 0.20
        backgroundView.addSubview(imageView)

        tableView.backgroundView = backgroundView
    }

}

// MARK: - Private utility extensions

private extension CGRect {
    init(center: CGPoint, size: CGSize) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        let origin = CGPoint(x: originX, y: originY)
        self.init(origin: origin, size: size)
    }
}
