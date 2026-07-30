//
//  VideoModel.swift
//  Movipedia
//
//  Created by Steven Lie on 29/07/26.
//

import Foundation

struct VideoListResponse: Codable {
    let id: Int
    let results: [VideoModel]
}

public struct VideoModel: Codable, Identifiable {
    public let id: String
    let key: String?
    let name: String?
    let site: String?
    let type: String?
    let official: Bool?
}
