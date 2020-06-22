//
//  VideoApi.swift
//  SwiftUI-Combine-Video
//
//  Created by Chandan Singh on 6/22/20.
//  Copyright © 2020 Developer005. All rights reserved.
//

import Foundation
import Combine

final class VideoApi: NSObject {
    static let apiAgent = ApiAgent()
        static let base = URL(string: "https://iphonephotographyschool.com/test-api/")
}

extension VideoApi {
    static func videos() -> AnyPublisher<VideoPageDTO<VideoDTO>, Error> {
        let request = URLComponents(url: (base?.appendingPathComponent("videos"))!, resolvingAgainstBaseURL: true)?
            .request
        return apiAgent.run(request!)
    }
}

private extension URLComponents {
    var request: URLRequest? {
        url.map { URLRequest.init(url: $0) }
    }
}
