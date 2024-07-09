//
//  Logger.swift
//
//  Created by nicosrm
//

import Foundation

// init global log
let log = Logger(logFileName: "ipd-\(Logger.formattedCurrentDate).log")

class Logger {
    
    private (set) var logFilePath: String
    private var isInDerivedData: Bool
    
    init(logFileName: String) {
        let currentDirectory = FileManager.default.currentDirectoryPath
        let pathDirectory = (currentDirectory as NSString)
            .appendingPathComponent("logs")
        let logFilePath = (pathDirectory as NSString)
            .appendingPathComponent(logFileName)
        self.logFilePath = logFilePath
        
        self.isInDerivedData = logFilePath.contains("DerivedData")
    
        self.createLogFileIfNeeded()
    }
    
    func log(_ items: Any...) {
        let separator = " "
        let terminator = "\n"
        
        let output = items.map { "\($0)" }.joined(separator: separator)
    
        let logMessage: String
        if output == terminator || output == "" {
            logMessage = "\(output)"
        } else if output == "" {
            logMessage = "\(output)\(terminator)"
        } else {
            logMessage = "[\(Self.formattedCurrentDate)] \(output)\(terminator)"
        }
        
        print(logMessage, terminator: "")
        
        guard !self.isInDerivedData else {
            return
        }
        
        guard let fileHandle = FileHandle(forWritingAtPath: logFilePath) else {
            print("Error opening file at path: \(logFilePath)")
            return
        }
        
        fileHandle.seekToEndOfFile()
        
        if let data = logMessage.data(using: .utf8) {
            fileHandle.write(data)
            fileHandle.closeFile()
        } else {
            print("Error converting log message to data.")
        }
    }
    
    func newFile(logFileName: String) {
        let currentDirectory = FileManager.default.currentDirectoryPath
        let pathDirectory = (currentDirectory as NSString)
            .appendingPathComponent("logs")
        let logFilePath = (pathDirectory as NSString)
            .appendingPathComponent(logFileName)
        self.logFilePath = logFilePath
        
        self.isInDerivedData = logFilePath.contains("DerivedData")
        
        self.createLogFileIfNeeded()
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
        guard !self.isInDerivedData else {
            return
        }
        
        if !FileManager.default.fileExists(atPath: logFilePath) {
            FileManager.default.createFile(
                atPath: logFilePath,
                contents: nil,
                attributes: nil
            )
        }
    }
}
