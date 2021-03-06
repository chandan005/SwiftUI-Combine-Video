//
//  VideoListView.swift
//  SwiftUI-Combine-Video
//
//  Created by Chandan Singh on 6/22/20.
//  Copyright © 2020 Developer005. All rights reserved.
//

import Combine
import SwiftUI

struct VideoListView: View {
    @ObservedObject var viewModel: VideoListViewModel
    
    var body: some View {
        NavigationView {
            content
                .navigationBarTitle("Videos")
        }
        .onAppear { self.viewModel.send(event: .onAppear) }
    }
    
    private var content: some View {
        switch viewModel.state {
        case .idle:
            return Color.clear.eraseToAnyView()
        case .loading:
            return Spinner(isAnimating: true, style: .large).eraseToAnyView()
        case .error(let error):
            return Text(error.localizedDescription).eraseToAnyView()
        case .retrying:
            viewModel.send(event: .onFailedToLoadVideosFromApi)
            return EmptyView().eraseToAnyView()
        case .loaded(let videos):
            return list(of: videos).eraseToAnyView()
        }
    }
    
    private func list(of videos: [VideoListItem]) -> some View {
        return List(videos) { video in
            NavigationLink(destination: VideoDetailView(viewModel: VideoDetailViewModel(videoDetail: video)), label: {
                VideoListRowView(video: video)
            })
        }
    }
}
