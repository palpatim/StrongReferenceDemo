//
//  MovieListViewController.swift
//  StrongReferenceDemo
//
//  Created by Schmelter, Tim on 2/3/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

import UIKit

final class MovieListViewController: MovieListBaseViewController {
    let bogusPropertyToShowMemoryUsage: [Date] = {  (0 ..< 100_000).map { _ in Date() } }()
    var currentFolder: Node!
    var ratingsLoaders = [NodeCell: IMDBMovieRatingLoader?]()
    
    deinit {
        Log.t()
    }

    override func viewDidLoad() {
        Log.t()
        super.viewDidLoad()
        if currentFolder == nil {
            currentFolder = NodeDataSource.nodeById(0)
        }
        title = currentFolder.name ?? "Movies"
    }

    override func getCurrentFolder() -> Node {
        return currentFolder
    }
    
    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentFolder.childIds?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let node = nodeForIndexPath(indexPath) else {
            return UITableViewCell()
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NodeCell", for: indexPath) as? NodeCell else {
            return UITableViewCell()
        }

        cell.textLabel?.text = node.name

        if NodeDataSource.hasChildren(node) {
            // Folder
            cell.accessoryType = .disclosureIndicator
            cell.detailTextLabel?.text = ""
        } else {
            // Individual Movie
            if let imageName = node.imageName, image = UIImage(named: imageName) {
                cell.imageView?.image = image
            }

            getLatestRatingForCell(cell)
        }

        return cell
    }

    
    // MARK: - Ratings

    func getLatestRatingForCell(_ cell: NodeCell) {
        cell.detailTextLabel?.text = "Loading rating..."
        // PATTERN 2: Instance functions are partially-applied closures on `self`
        ratingsLoaders[cell] = IMDBMovieRatingLoader(cell: cell, completionHandler: updateCell)
    
//        ratingsLoaders[cell] = IMDBMovieRatingLoader(cell: cell, completionHandler: { [weak self] in
//            self?.updateCell($0, withRating: $1)
//        })
        
    }

    private func updateCell(_ cell: NodeCell, withRating rating: Int) {
        guard let detailTextLabel = cell.detailTextLabel else {
            return
        }
        detailTextLabel.text = String(format: "%d stars", arguments: [rating])
    }
}
