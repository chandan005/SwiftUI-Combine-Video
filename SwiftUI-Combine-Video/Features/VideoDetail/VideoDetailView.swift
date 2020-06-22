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
    
    @Environment(\.presentationMode) var presentation
    @ObservedObject var viewModel: VideoDetailViewModel
    @State private var avController = AVPlayerViewController()
    @State var showProgressBar = false
    
    var body: some View {
        videoView(self.viewModel.videoListItem)
        .onDisappear {
            self.avController.player?.pause()
        }
    }
    
    private func videoView(_ video: VideoListItem) -> some View {
        ScrollView {
            VStack {
                video.videoLink.map { url in
                    VideoView(videoUrl: self.viewModel.isInternetConnected ? url : FileManagerApi(fileName: "video.mp4").getFileUrl(), controller: avController)
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
                self.viewModel.isInternetConnected ?
                Button(action: {
                    self.showProgressBar.toggle()
                    if !self.viewModel.didFinishDownloading {
                        self.viewModel.startDownload()
                    }
                }) {
                    Text("Download Video")
                    Image(systemName: "square.and.arrow.down")
                }.sheet(isPresented: self.$showProgressBar, onDismiss: {
                    print(self.showProgressBar)
                    self.viewModel.cancelDownload()
                }) {
                    CircularProgressView(currentProgress: self.$viewModel.currentProgress, percentage: self.$viewModel.percentage,  didFinishDownload: self.$viewModel.didFinishDownloading)
                }
                
                :
                Button(action: {
                }) {
                    Text("No Internet")
                    Image(systemName: "square.and.arrow.down")
                }.sheet(isPresented: self.$showProgressBar, onDismiss: {
                    print(self.showProgressBar)
                    self.viewModel.cancelDownload()
                }) {
                    CircularProgressView(currentProgress: self.$viewModel.currentProgress, percentage: self.$viewModel.percentage,  didFinishDownload: self.$viewModel.didFinishDownloading)
                }
            )
        }
    }
}
