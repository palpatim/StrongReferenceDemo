//
//  Log.swift
//  StrongReferenceDemo
//
//  Created by Schmelter, Tim on 2/16/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

import Foundation

struct Log {
    /**
     Prints a "TRACE" level log message with the current function and an optional message.
     Differs from other log messages in that default values for `tag` and `message`
     are `__FILE__` and `__FUNCTION__`, respectively.
     If `tag` is a file, this function will convert the tag to a basename, less
     file extension, so that `/path/to/file/NavigationController.swift` will be
     converted to `NavigationController`.

     - parameter tag: typically is the class name generating the log, defaults to `__FILE__`
     - parameter message: message to log, defaults to `__FUNCTION__`
     */
    static func t(tag: String = __FILE__, _ message: String = __FUNCTION__) {
        var convertedTag = tag
        let url = NSURL(fileURLWithPath: tag)
        if let basename = url.URLByDeletingPathExtension?.lastPathComponent {
            convertedTag = basename
        }
        NSLog("%@", "\(convertedTag):\(message)")
    }
}
