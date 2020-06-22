//
//  VideoView.swift
//  SwiftUI-Combine-Video
//
//  Created by Chandan Singh on 6/22/20.
//  Copyright © 2020 Developer005. All rights reserved.
//

import AVKit
import SwiftUI

struct VideoView: UIViewControllerRepresentable {

    var videoUrl: URL
    var controller: AVPlayerViewController

    func makeUIViewController(context: UIViewControllerRepresentableContext<VideoView>) -> AVPlayerViewController {
        
        controller.allowsPictureInPicturePlayback = true
        controller.videoGravity = .resize
        let player = AVPlayer(url: videoUrl)
        player.automaticallyWaitsToMinimizeStalling = false
        controller.player = player
        controller.updatesNowPlayingInfoCenter = true
        controller.view.backgroundColor = UIColor.white

        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<VideoView>) {
    }
    
}
