//
//  NodeCell.swift
//  StrongReferenceDemo
//
//  Created by Schmelter, Tim on 2/12/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

import UIKit

class NodeCell: UITableViewCell {

    // MARK: - Lifecycle

    required init?(coder aDecoder: NSCoder) {
        Log.t()
        super.init(coder: aDecoder)
    }

    deinit {
        Log.t()
    }

    override func prepareForReuse() {
        detailTextLabel?.text = nil
        textLabel?.text = nil
        accessoryType = .None
        imageView?.image = nil
    }
}
