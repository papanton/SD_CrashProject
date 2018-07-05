//
//  APIPagedList.swift
//  SD_CrashProject
//
//  Created by Antonis papantoniou on 7/5/18.
//  Copyright © 2018 Unusual Labs, Inc. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class APIPagedList<Element: Model>: PagedList<Element> {

  // Alamofire queries
  let requestRouter: ((Int, Int?) -> URLRequestConvertible)?
  let id: Int?
  var request: DataRequest?

  @discardableResult
  init(router: @escaping (Int, Int?) -> URLRequestConvertible, id: Int?) {
    requestRouter = router
    self.id = id
  }

  override func loadMore(_ callback: ((APIPagedList) -> Void)? = nil ) {
    guard hasMore && !loading, let requestRouter = requestRouter else {
      callback?(self)
      return
    }

    loading = true
    request = Alamofire.request(requestRouter(id ?? -1, currentPage + 1)).validate().responseJSON{ response in
        guard !response.result.isFailure, let value = response.result.value else {
          print("Failed to get page \(response.debugDescription)")
          self.hasMore = false
          return
        }
        let rawJson = JSON(value)
        let data = rawJson[Strings.Data]
        if let currPage = rawJson[Strings.Meta][Strings.CurrentPage].int,
          let numPages = rawJson[Strings.Meta][Strings.LastPage].int,
          let total = rawJson[Strings.Meta][Strings.Total].int {
          self.currentPage = currPage
          self.numPages = numPages
          self.total = total
        }
        if self.currentPage == self.numPages || data.arrayValue.isEmpty {
          self.hasMore = false
        }
        self.process(data: data)
        DispatchQueue.main.async {
          callback?(self)
        }
        self.loading = false
    }
  }

  override func cancelOperations() {
    request?.cancel()
  }

}
