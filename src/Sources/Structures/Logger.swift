//
//  Logger.swift
//
//  Created by nicosrm
//

import Foundation

// init global log
let log = Logger(logFileName: "ipd-\(Logger.formattedCurrentDate).log")

class Logger {
    
    let logFilePath: String
    
    init(logFileName: String) {
        let currentDirectory = FileManager.default.currentDirectoryPath
        let pathDirectory = (currentDirectory as NSString)
            .appendingPathComponent("logs")
        let logFilePath = (pathDirectory as NSString)
            .appendingPathComponent(logFileName)
        self.logFilePath = logFilePath
        createLogFileIfNeeded()
    }
    
    func log(_ items: Any...) {
        let separator = " "
        let terminator = "\n"
        
        let output = items.map { "\($0)" }.joined(separator: separator)
        
        guard let fileHandle = FileHandle(forWritingAtPath: logFilePath) else {
            print("Error opening file at path: \(logFilePath)")
            return
        }
        
        fileHandle.seekToEndOfFile()
    
        let logMessage: String
        if output == terminator || output == "" {
            logMessage = "\(output)"
        } else if output == "" {
            logMessage = "\(output)\(terminator)"
        } else {
            logMessage = "[\(Self.formattedCurrentDate)] \(output)\(terminator)"
        }
        
        print(logMessage, terminator: "")
        
        if let data = logMessage.data(using: .utf8) {
            fileHandle.write(data)
            fileHandle.closeFile()
        } else {
            print("Error converting log message to data.")
        }
    }
    
    static var formattedCurrentDate: String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
        let dateString = dateFormatter.string(from: currentDate)
        return dateString
    }
}

// MARK: - Private helpers

private extension Logger {
    
    func createLogFileIfNeeded() {
        if !FileManager.default.fileExists(atPath: logFilePath) {
            FileManager.default.createFile(
                atPath: logFilePath,
                contents: nil,
                attributes: nil
            )
        }
    }
}
