//
//  VideoDetailViewModel.swift
//  SwiftUI-Combine-Video
//
//  Created by Chandan Singh on 6/22/20.
//  Copyright © 2020 Developer005. All rights reserved.
//

import Combine
import Foundation

final class VideoDetailViewModel:  ObservableObject {
    @Published var videoListItem: VideoListItem
    private var bag: Set<AnyCancellable> = []
    
    init(videoDetail: VideoListItem) {
        videoListItem = videoDetail
    }
}
