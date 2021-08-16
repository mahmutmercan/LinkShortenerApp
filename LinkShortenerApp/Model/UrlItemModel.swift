//
//  UrlItemModel.swift
//  LinkShortenerApp
//
//  Created by Mahmut MERCAN on 10.08.2021.
//

struct UrlItemModel: Decodable {
    let long_url: String
    let shortener_url: String
  
  enum CodingKeys: String, CodingKey {
    case long_url = "long_url"
    case shortener_url = "shortener_url"
    
  }
}
