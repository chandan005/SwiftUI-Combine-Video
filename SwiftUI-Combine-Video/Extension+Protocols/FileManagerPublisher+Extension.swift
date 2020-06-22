//
//  FileManagerPublisher+Extension.swift
//  SwiftUI-Combine-Video
//
//  Created by Chandan Singh on 6/22/20.
//  Copyright © 2020 Developer005. All rights reserved.
//

import Combine
import Foundation

extension Publishers {
    private final class FileManagerSubscription<S: Subscriber>: Subscription where S.Input == Data, S.Failure == Error {
        private let fileName: String
        private var subscriber: S?
        
        init(fileName: String, subscriber: S){
            self.fileName = fileName
            self.subscriber = subscriber
            sendRequest()
        }
        func request(_ demand: Subscribers.Demand) {
            
        }
        
        func cancel() {
            subscriber = nil
        }
        
        private func sendRequest(){
            guard let subscriber = subscriber else { return }
            do {
                let cacheDirectoryURL = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let temporaryFileURL = cacheDirectoryURL.appendingPathComponent(fileName)
                do {
                    let data = try Data(contentsOf: temporaryFileURL)
                     _ = subscriber.receive(data)
                } catch let error {
                    _ = subscriber.receive(completion: Subscribers.Completion.failure(error))
                }
            } catch let error {
                _ = subscriber.receive(completion: Subscribers.Completion.failure(error))
            }
        }
    }
}

extension Publishers {
    
    struct FileManagerPublisher: Publisher {
        typealias Output = Data
        typealias Failure = Error
        
        private let fileName: String
        
        init(fileName: String) {
            self.fileName = fileName
        }
        
        func receive<S: Subscriber>(subscriber: S) where
            
            FileManagerPublisher.Failure == S.Failure, FileManagerPublisher.Output == S.Input {
                let subscription = FileManagerSubscription(fileName: fileName, subscriber: subscriber)
                subscriber.receive(subscription: subscription)
        }
    }
}

