//
//  StickerService.swift
//  SD_CrashProject
//
//  Created by Antonis papantoniou on 7/5/18.
//  Copyright © 2018 Unusual Labs, Inc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class StickerService {

  enum Router: URLRequestConvertible {
    case getStickers

    var path: String {
      switch self {
      case .getStickers: return "animated"
      }
    }

    func asURLRequest() throws -> URLRequest {
      let URL = Foundation.URL(string: "https://dashboard.stickerpop.co/api/")!
      var request = URLRequest(url: URL.appendingPathComponent(path))
      request.httpMethod = HTTPMethod.get.rawValue
      return try URLEncoding().encode(request, with: [:])
    }
  }

  class func getStickers(completion: @escaping([Sticker]) -> Void) {
    Alamofire.request(Router.getStickers).validate().responseJSON { response in
      guard let value = response.result.value else { return }
      let stickers = JSON(value)[Strings.Data].arrayValue.compactMap({ Sticker(data: $0) })
      completion(stickers)
    }
  }

}
