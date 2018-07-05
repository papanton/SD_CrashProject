//
//  PagedList.swift
//  SD_CrashProject
//
//  Created by Antonis papantoniou on 7/5/18.
//  Copyright © 2018 Unusual Labs, Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol Model {
  init?(data: JSON)
}

class PagedList<Element: Model> {

  var items: [Element] = []

  var numPages: Int = 1
  var currentPage: Int = 0
  var total: Int = 0
  var loading: Bool = false
  var hasMore: Bool = true

  var count: Int {
    return items.count
  }

  func loadMore(_ callback: ((PagedList) -> Void)? = nil) {}
  func cancelOperations() {}

  internal func process(data: JSON) {
    for (_, subData):(String, JSON) in data {
      if let item = Element(data: subData) {
        self.items.append(item)
      } else {
        print("Failed to parse data as model: \(subData)")
      }
    }
  }

}

extension PagedList: CustomStringConvertible {

  var description: String {
    var description = "PagedList[ "
    for item in items {
      if description == "PagedList[ " {
        description += "\(item)"
      } else {
        description += ", \(item)"
      }
    }
    description += " ]"
    return description
  }

}

extension PagedList: Collection {
  // The upper and lower bounds of the collection, used in iterations
  var startIndex: Int { return items.startIndex }
  var endIndex: Int { return items.endIndex }

  subscript(requestedIndex: Int) -> Element {
    get {
      return items[requestedIndex]
    }
    set(newElement) {
      items[requestedIndex] = newElement
    }
  }

  // Method that returns the next index when iterating
  func index(after i: Int) -> Int {
    return items.index(after: i)
  }

}
