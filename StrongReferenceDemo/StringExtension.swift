//
//  StringUtil.swift
//  StrongReferenceDemo
//
//  Created by Matthews, Jamie on 3/25/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

extension String {
    func urlEncodedString() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}
