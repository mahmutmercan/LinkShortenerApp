//
//  ShortLinkModel.swift
//  LinkShortenerApp
//
//  Created by Mahmut MERCAN on 12.08.2021.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let shortLinkModel = try? newJSONDecoder().decode(ShortLinkModel.self, from: jsonData)

import Foundation

// MARK: - ShortLinkModel
struct ShortLinkModel: Codable {
    let ok: Bool
    let result: Result
}

// MARK: - Result
struct Result: Codable {
    let code: String
    let shortLink: String
    let fullShortLink: String
    let shortLink2: String
    let fullShortLink2: String
    let shortLink3: String
    let fullShortLink3: String
    let shareLink: String
    let fullShareLink: String
    let originalLink: String
    
    enum CodingKeys: String, CodingKey {
        case code
        case shortLink = "short_link"
        case fullShortLink = "full_short_link"
        case shortLink2 = "short_link2"
        case fullShortLink2 = "full_short_link2"
        case shortLink3 = "short_link3"
        case fullShortLink3 = "full_short_link3"
        case shareLink = "share_link"
        case fullShareLink = "full_share_link"
        case originalLink = "original_link"
    }
}
