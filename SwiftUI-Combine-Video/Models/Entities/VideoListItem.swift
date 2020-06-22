//
//  VideoListItem.swift
//  SwiftUI-Combine-Video
//
//  Created by Chandan Singh on 6/22/20.
//  Copyright © 2020 Developer005. All rights reserved.
//

import Foundation

struct VideoListItem: Identifiable {
    
    private var video: VideoDTO
    
    var id: Int {
        return video.id
    }
    var name: String {
        return video.name
    }
    var thumbnail: URL? {
        return URL(string: video.thumbnail ?? "")
    }
    var description: String? {
        return video.description ?? ""
    }
    var videoLink: URL? {
        return URL(string: video.video_link ?? "")
    }

    init(_ video: VideoDTO) {
        self.video = video
    }
}

