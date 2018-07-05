//
//  Sticker.swift
//  SD_CrashProject
//
//  Created by Antonis papantoniou on 7/5/18.
//  Copyright © 2018 Unusual Labs, Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

class Sticker {

  let imageUrl: URL

  init(imageUrl: URL) {
    self.imageUrl = imageUrl
  }

  convenience required init?(data: JSON) {
    if let imageUrl = data["variations"]["md"].url {
      self.init(imageUrl: imageUrl)
    } else {
      print("Could not parse sticker data: \(data)")
      return nil
    }
  }

}
