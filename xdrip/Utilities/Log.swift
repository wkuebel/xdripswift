import Foundation
import os

fileprivate var log:OSLog = {
    let log:OSLog = OSLog(subsystem: Constants.Log.subSystem, category: Constants.Log.debuglogging)
    return log
}()


/// will only be used during development
func debuglogging(_ logtext:String) {
    os_log("%{public}@", log: log, type: .debug, logtext)
}
