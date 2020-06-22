//
//  FileManagerApi.swift
//  SwiftUI-Combine-Video
//
//  Created by Chandan Singh on 6/22/20.
//  Copyright © 2020 Developer005. All rights reserved.
//

import Combine
import Foundation

struct FileManagerApi {
    let fileName: String
    
    func getFileFromCache() throws -> Data {
        let fileManager: FileManager = .default
        do {
            let cacheDirectoryURL = try fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let temporaryFileURL = cacheDirectoryURL.appendingPathComponent(fileName)
            do {
                let data = try Data(contentsOf: temporaryFileURL)
                return data
            } catch let error {
                throw error
            }
        } catch let error {
            throw error
        }
    }
    
    func getFileUrl() -> URL {
        let fileManager: FileManager = .default
        let cacheDirectoryURL = try! fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let temporaryFileURL = cacheDirectoryURL.appendingPathComponent(fileName)
        return temporaryFileURL
//        do {
//            let cacheDirectoryURL = try! fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//            let temporaryFileURL = cacheDirectoryURL.appendingPathComponent(fileName)
//            return temporaryFileURL
//        } catch let error {
//            throw error
//        }
    }
    
    
    func checkifileExixts() throws -> Bool {
        let fileManager: FileManager = .default
        do {
            let cacheDirectoryURL = try fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let temporaryFileURL = cacheDirectoryURL.appendingPathComponent(fileName)
            if fileManager.fileExists(atPath: temporaryFileURL.absoluteString) {
               return true
            } else {
                return false
            }
        } catch let error {
            throw error
        }
    }
    
    func saveFileToCache(data: Data) throws {
        let fileManager: FileManager = .default
        do {
            let cacheDirectoryURL = try fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let temporaryFileURL = cacheDirectoryURL.appendingPathComponent(fileName)
            do {
                if fileManager.fileExists(atPath: temporaryFileURL.absoluteString) {
                    do {
                        try fileManager.removeItem(atPath: temporaryFileURL.absoluteString)
                    } catch let error {
                        throw error
                    }
                }
                try data.write(to: temporaryFileURL, options: .atomicWrite)
            } catch let error {
                throw error
            }
        } catch let error {
            throw error
        }
    }
}

extension FileManagerApi {
    func dataResponse() -> Publishers.FileManagerPublisher {
        return Publishers.FileManagerPublisher(fileName: fileName)
    }
}

extension FileManagerApi {
    func videos() -> AnyPublisher<[VideoDTO], Error> {
        return self.dataResponse()
            .map { $0 }
            .handleEvents(receiveOutput: { print(NSString(data: $0, encoding: String.Encoding.utf8.rawValue)!) })
            .decode(type: [VideoDTO].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}


