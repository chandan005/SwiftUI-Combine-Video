//
//  VideoDTO.swift
//  SwiftUI-Combine-Video
//
//  Created by Chandan Singh on 6/22/20.
//  Copyright © 2020 Developer005. All rights reserved.
//

struct VideoDTO: Codable {
    let id: Int
    let name: String
    let thumbnail: String?
    let description: String?
    var video_link: String?
}
