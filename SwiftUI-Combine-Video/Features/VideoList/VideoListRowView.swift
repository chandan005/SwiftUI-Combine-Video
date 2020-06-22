//
//  VideoListRowView.swift
//  SwiftUI-Combine-Video
//
//  Created by Chandan Singh on 6/22/20.
//  Copyright © 2020 Developer005. All rights reserved.
//

import Combine
import SwiftUI

struct VideoListRowView: View {
    let video: VideoListItem
    @Environment(\.imageCache) var cache: ImageCache
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            thumbnail
            name
        }
    }
    
    private var name: some View {
        Text(video.name)
            .font(.caption)
            .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .leading)
    }
    
    private var thumbnail: some View {
        video.thumbnail.map { url in
            AsyncImage(
                url: url,
                identifier: String(video.id),
                cache: cache,
                placeholder: Rectangle().fill().foregroundColor(.gray),
                configuration: { $0.resizable().renderingMode(.original) }
            )
            .frame(idealHeight: UIScreen.main.bounds.width / 2 * 3)
            .frame(width: 80, height: 80, alignment: .leading)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }
    
    private var spinner: some View {
        Spinner(isAnimating: true, style: .medium)
    }
}
