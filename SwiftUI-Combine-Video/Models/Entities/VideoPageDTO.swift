//
//  VideoPageDTO.swift
//  SwiftUI-Combine-Video
//
//  Created by Chandan Singh on 6/22/20.
//  Copyright © 2020 Developer005. All rights reserved.
//

struct VideoPageDTO<T: Codable>: Codable {
    let videos: [T]
}
