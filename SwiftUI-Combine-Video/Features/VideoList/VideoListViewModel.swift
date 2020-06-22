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

// MARK: - Inner Types
extension VideoListViewModel {
    
    enum State {
        case idle
        case loading
        case loaded([VideoListItem])
        case error(Error)
    }
    
    enum Event {
        case onAppear
        case onSelectVideo(Int)
        case onVideosLoaded([VideoListItem])
        case onFailedToLoadVideos(Error)
    }
}

// MARK: - State Machine
extension VideoListViewModel {
    static func reduce(_ state: State, _ event: Event) -> State {
        switch state {
        case .idle:
            switch event {
            case .onAppear:
                return .loading
            default:
                return state
            }
        case .loading:
            switch event {
            case .onVideosLoaded(let videos):
                return .loaded(videos)
            default:
                return state
            }
        case .loaded:
            return state
        case .error:
            return state
        }
    }
}
