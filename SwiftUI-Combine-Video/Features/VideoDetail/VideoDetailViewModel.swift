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

final class VideoDetailViewModel:  ObservableObject {
    
    @Published var videoListItem: VideoListItem
    @Published var currentProgress: String = ""
    @Published var totalSize: String = ""
    @Published var percentage: Float = 0
    @Published var didFinishDownloading: Bool = false
    @Published var isInternetConnected: Bool = true
    private var bag: Set<AnyCancellable> = []
    let download = Download()
    
    init(videoDetail: VideoListItem) {
        videoListItem = videoDetail
    }
}
