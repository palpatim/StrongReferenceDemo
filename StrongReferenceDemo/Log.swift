//
//  Log.swift
//  StrongReferenceDemo
//
//  Created by Schmelter, Tim on 2/16/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

import Foundation

struct Log {

    // will log this level and higher tags
    // TODO: Raise this to .Warn or .Error in release mode after CDALL-27691
    static var level = LogLevel.Trace

    enum LogLevel: Int {
        case Trace = 1
        case Debug
        case Info
        case Warning
        case Error
        case Fatal

        func getTag() -> String {
            return String(self).uppercaseString
        }
    }

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
        log(.Trace, tag: convertedTag, message: message)
    }

    /**
     Prints a log message with the following format

     DEBUG_TAG\tag:message

     - parameter tag: typically is the class name generating the log
     - parameter message:
     */
    static func d(tag: String, _ message: String) {
        log(.Debug, tag: tag, message: message)
    }

    /**
     Prints a log message with the following format

     INFO_TAG\tag:message

     - parameter tag: typically is the class name generating the log
     - parameter message:
     */
    static func i(tag: String, _ message: String) {
        log(.Info, tag: tag, message: message)
    }

    /**
     Prints a log message with the following format

     INFO_TAG\tag:message

     - parameter tag: typically is the class name generating the log
     - parameter message:
     */
    static func w(tag: String, _ message: String) {
        log(.Warning, tag: tag, message: message)
    }

    /**
     Prints a log message with the following format

     ERROR_TAG\tag:message

     - parameter tag: typically is the class name generating the log
     - parameter message:
     */
    static func e(tag: String, _ message: String) {
        log(.Error, tag: tag, message: message)
    }

    /**
     Prints a log message with the following format iff the passed error
     is set
     ERROR_TAG\tag:message error:errorOptional

     - parameter tag:           typically is the class name generating the log
     - parameter message:       message description
     - parameter errorOptional: to display if set
     */
    static func ifError(tag: String, _ message: String, _ errorOptional: NSError?) {
        if let error = errorOptional {
            e(tag, message, error)
        }
    }

    /**
     Prints a log message with the following format
     ERROR_TAG\tag:message error:localized error description code: error code domain: error domain

     - parameter tag:           typically is the class name generating the log
     - parameter message:       message description
     - parameter error:         to display
     */
    static func e(tag: String, _ message: String, _ error: NSError) {
        log(.Error, tag: tag, message: "\(message) error:\(error.localizedDescription) code: \(error.code) domain: \(error.domain)")
    }

    /**
     Prints a log message with the following format
     ERROR_TAG\tag: message error: error type

     - parameter tag:
     - parameter message:
     - parameter error:
     */
    static func e(tag: String, _ message: String, _ error: ErrorType) {
        log(.Error, tag: tag, message: "\(message) error:\(error)")
    }

    /**
     Prints a log message with the following format

     FATAL_TAG\tag:message

     - parameter tag: typically is the class name generating the log
     - parameter message:
     */
    static func fatal(tag: String, _ message: String) {
        log(.Fatal, tag: tag, message: message)
    }

    /**
     Will dispatch the log to NSLog only if the log level is greater than or equal to the current level set for debug or release

     - parameter level:   The level of severity of the log
     - parameter tag:     typically is the class name generating the log
     - parameter message: log message
     */
    private static func log(level: LogLevel, tag: String, message: String) {
        if(level.rawValue >= self.level.rawValue) {
            NSLog("%@", "\(level.getTag())\\\(tag):\(message)")
        }
    }
}
