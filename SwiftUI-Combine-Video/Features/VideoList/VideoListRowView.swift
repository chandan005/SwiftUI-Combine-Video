//
//  VideoListRowView.swift
//  SwiftUI-Combine-Video
//
//  Created by Chandan Singh on 6/22/20.
//  Copyright © 2020 Developer005. All rights reserved.
//

import Combine
import SwiftUI

struct VideoListRowView {
    let video: VideoListItem
    
    var body: some View {
        name
    }
    
    private var name: some View {
        Text(video.name)
            .font(.caption)
            .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .leading)
    }
}
