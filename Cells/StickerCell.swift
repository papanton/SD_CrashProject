//
//  StickerCell.swift
//  SD_CrashProject
//
//  Created by Antonis papantoniou on 7/5/18.
//  Copyright © 2018 Unusual Labs, Inc. All rights reserved.
//

import UIKit
import FLAnimatedImage
import SDWebImage

class StickerCell: UICollectionViewCell {
  
  @IBOutlet weak var imageVIew: FLAnimatedImageView!

  func fill(sticker: Sticker) {
    imageVIew.sd_setImage(with: sticker.imageUrl)
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    imageVIew.image = nil
    imageVIew.animatedImage = nil
    imageVIew.sd_cancelCurrentImageLoad()
  }

}
