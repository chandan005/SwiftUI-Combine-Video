//
//  VideoDetailViewModel.swift
//  SwiftUI-Combine-Video
//
//  Created by Chandan Singh on 6/22/20.
//  Copyright © 2020 Developer005. All rights reserved.
//

import Foundation
import Combine
import Network

final class VideoDetailViewModel: NSObject, ObservableObject {
    
    @Published var videoListItem: VideoListItem
    @Published var currentProgress: String = ""
    @Published var totalSize: String = ""
    @Published var percentage: Float = 0
    @Published var didFinishDownloading: Bool = false
    @Published var isInternetConnected: Bool = true
    private var bag: Set<AnyCancellable> = []
    let download = Download()
    let monitor = NWPathMonitor()
    
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.default
      return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    init(videoDetail: VideoListItem) {
        videoListItem = videoDetail
        super.init()
        checkIfDownloadedFileExists()
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        checkIfInternetExists()
    }
    
    func startDownload(){
        let url = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4")
        self.download.task = self.downloadsSession.downloadTask(with: url!)
        self.download.task?.resume()
    }
    
    func cancelDownload() {
        download.task?.cancel()
    }
    
    func checkIfDownloadedFileExists(){
        let fileMangerApi = FileManagerApi(fileName: "video.mp4")
        do {
            if try fileMangerApi.checkifileExixts() {
                self.didFinishDownloading = true
            } else {
                self.didFinishDownloading = false
            }
        } catch {
            self.didFinishDownloading = false
        }
    }
    
    func checkIfInternetExists(){
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self.isInternetConnected = true
                }
            } else {
                DispatchQueue.main.async {
                    self.isInternetConnected = false
                }
            }
        }
    }

}

extension VideoDetailViewModel: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let fileMangerApi = FileManagerApi(fileName: "video.mp4")
        do {
            let videoData = try Data(contentsOf: location)
            do {
                try fileMangerApi.saveFileToCache(data: videoData)
                DispatchQueue.main.async {
                    self.didFinishDownloading = true
                }
            } catch {
                self.didFinishDownloading = false
            }
        }catch {
            self.didFinishDownloading = false
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {

        DispatchQueue.main.async {
            let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)
            self.percentage = progress * 100
            self.currentProgress = String(format: "%.1f%% of %@", progress * 100, totalSize)
        }
    }
    
}
