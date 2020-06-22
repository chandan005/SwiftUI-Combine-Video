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
    @Published var isInternetConnected: Bool = true
    
    init() {
        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                Self.whenLoading(),
                Self.whenFailedToLoadFromUrl(),
                Self.userInput(input: input.eraseToAnyPublisher())
            ]
        )
        .assign(to: \.state, on: self)
        .store(in: &bag)
    }
    
    func send(event: Event) {
        input.send(event)
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
        case retrying
        case error(Error)
    }
    
    enum Event {
        case onAppear
        case onSelectVideo(Int)
        case onVideosLoaded([VideoListItem])
        case onFailedToLoadVideosFromApi
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
            case .onFailedToLoadVideosFromApi:
                return .retrying
            case .onVideosLoaded(let videos):
                return .loaded(videos)
            default:
                return state
            }
        case .retrying:
            switch event {
            case .onFailedToLoadVideos(let error):
                return .error(error)
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
    
    static func whenLoading() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .loading = state else { return Empty().eraseToAnyPublisher() }
            return VideoApi.videos() .map { videos in
                let fileMangerApi = FileManagerApi(fileName: "videos.json")
                do {
                    let data = try JSONEncoder().encode(videos.videos)
                    do {
                        try fileMangerApi.saveFileToCache(data: data)
                    } catch { }
                } catch { }
                return videos.videos.map(VideoListItem.init)
            }
            .map(Event.onVideosLoaded)
            .catch { _ in Just(Event.onFailedToLoadVideosFromApi)}
            .eraseToAnyPublisher()
        }
    }
    
    static func whenFailedToLoadFromUrl() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .retrying = state else { return Empty().eraseToAnyPublisher() }
            return FileManagerApi(fileName: "videos.json").videos()
                .map { $0.map(VideoListItem.init) }
                .map(Event.onVideosLoaded)
                .catch { Just(Event.onFailedToLoadVideos($0))}
                .eraseToAnyPublisher()
        }
    }
    
    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}
