//
//  NodeDataSource.swift
//  StrongReferenceDemo
//
//  Created by Schmelter, Tim on 2/12/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

struct Node {
    let id: Int
    let name: String
    let imageName: String?

    let parentId: Int?
    var childIds: [Int]?

    init(id: Int, name: String, imageName: String? = nil, parentId: Int? = nil, childIds: [Int]? = nil) {
        self.id = id
        self.name = name
        self.imageName = imageName

        self.parentId = parentId
        self.childIds = childIds
    }
}

struct NodeDataSource {
    static let nodes = [
        Node(id: 0,   name: "Movies", childIds: [100, 102]),
        Node(id: 100, name: "Comedy", parentId: 0, childIds: [101, 110]),

        Node(id: 102, name: "Arsenic and Old Lace", imageName: "ArsenicandOldLace", parentId: 0),

        Node(id: 110, name: "Zany", parentId: 100, childIds: [111, 112, 113]),
        Node(id: 113, name: "Animal Crackers", imageName: "AnimalCrackers", parentId: 110),
        Node(id: 111, name: "Duck Soup", imageName: "DuckSoup", parentId: 110),
        Node(id: 112, name: "A Night at the Opera", imageName: "NightAtOpera", parentId: 110),

        Node(id: 101, name: "The Philadelphia Story", imageName: "PhiladelphiaStory", parentId: 100),

    ]

    static func childrenInFolder(_ node: Node) -> [Node]? {
        return node.childIds?.map(nodeById).flatMap { $0 }
    }

    static func nodeById(_ id: Int) -> Node? {
        guard let i = nodes.index(where: { $0.id == id }) else {
            return nil
        }
        return nodes[i]
    }

    static func hasChildren(_ node: Node) -> Bool {
        return node.childIds?.count > 0
    }

}
