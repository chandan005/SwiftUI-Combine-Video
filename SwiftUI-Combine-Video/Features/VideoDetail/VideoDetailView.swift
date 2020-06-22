//
//  VideoDetailView.swift
//  SwiftUI-Combine-Video
//
//  Created by Chandan Singh on 6/22/20.
//  Copyright © 2020 Developer005. All rights reserved.
//

import Combine
import SwiftUI
import AVKit

struct VideoDetailView: View {
    
    @ObservedObject var viewModel: VideoDetailViewModel
    @State private var avController = AVPlayerViewController()
    
    var body: some View {
        videoDetailView(self.viewModel.videoListItem)
        .onDisappear {
            self.avController.player?.pause()
        }
    }
    
    private func videoDetailView(_ video: VideoListItem) -> some View {
        ScrollView {
            VStack {
                video.videoLink.map { url in
                    VideoView(videoUrl: url , controller: avController)
                        .frame(height: UIScreen.main.bounds.height / 2.25)
                        .cornerRadius(5)
                }
                Spacer()
                    
                Text(video.name)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                    
                Spacer()
                Spacer()
                
                video.description.map {
                    Text($0)
                        .font(Font.footnote)
                        .foregroundColor(Color.init(.lightGray))
                        .multilineTextAlignment(.center)
                }
            }.padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
            .navigationBarItems(trailing:
                Button(action: {
                }) {
                    Text("Download")
                    Image(systemName: "square.and.arrow.down")
                }            )
        }
    }
}
