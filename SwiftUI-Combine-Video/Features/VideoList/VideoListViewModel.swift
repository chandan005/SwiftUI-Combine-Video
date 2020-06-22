//
//  VideoListViewModel.swift
//  SwiftUI-Combine-Video
//
//  Created by Chandan Singh on 6/22/20.
//  Copyright © 2020 Developer005. All rights reserved.
//

import Foundation
import Combine

final class VideoListViewModel: ObservableObject {
    @Published private(set) var state = State.idle
    private var bag = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()
    
    init() {
        
    }
    
    deinit {
        bag.removeAll()
    }
}

extension VideoListViewModel {
    
    enum State {
        case idle
        case loading
        case loaded
        case error(Error)
    }
    
    enum Event {
        case onAppear
        case onSelectVideo(Int)
        case onVideosLoaded
        case onFailedToLoadVideos(Error)
    }
}
