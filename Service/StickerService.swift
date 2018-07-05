//
//  StickerService.swift
//  SD_CrashProject
//
//  Created by Antonis papantoniou on 7/5/18.
//  Copyright © 2018 Unusual Labs, Inc. All rights reserved.
//

import Foundation
import Alamofire

class StickerService {

  enum Router: URLRequestConvertible {
    case getStickers(packId: Int, page: Int?)

    var path: String {
      switch self {
      case .getStickers(_, _): return "animated"
      }
    }

    func asURLRequest() throws -> URLRequest {
      let URL = Foundation.URL(string: "https://dashboard.stickerpop.co/api/")!
      var request = URLRequest(url: URL.appendingPathComponent(path))
      request.httpMethod = HTTPMethod.get.rawValue
      switch self {
      case .getStickers(_, let page):
        let parameters: Parameters = [Strings.Page: page ?? 1]
        return try URLEncoding().encode(request, with: parameters)
      }
    }
  }

  class func getStickers() -> APIPagedList<Sticker> {
    return APIPagedList<Sticker>(router: Router.getStickers, id: -1)
  }

}
