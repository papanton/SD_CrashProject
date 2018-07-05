//
//  ViewController.swift
//  SD_CrashProject
//
//  Created by Antonis papantoniou on 7/5/18.
//  Copyright © 2018 Unusual Labs, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  internal var cellsPerRow = 4
  internal var cellRatio: CGFloat = 1
  private let inset: CGFloat = 10
  private let minimumLineSpacing: CGFloat = 10
  private let minimumInteritemSpacing: CGFloat = 10

  var stickers: [Sticker] = []

  @IBOutlet var collectionView: UICollectionView!

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.register(UINib(nibName: "StickerCell", bundle: nil),
                            forCellWithReuseIdentifier: "cell")

    StickerService.getStickers { [weak self] stickers in
      self?.stickers = stickers
      self?.collectionView.reloadData()
    }
  }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return minimumLineSpacing
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return minimumInteritemSpacing
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    var marginsAndInsets: CGFloat = 0
    if #available(iOS 11.0, *) {
      marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right
        + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
    } else {
      marginsAndInsets = inset * 2 + collectionView.contentInset.left + collectionView.contentInset.right
        + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
    }
    let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
    return CGSize(width: itemWidth, height: itemWidth * cellRatio)
  }

}

extension ViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return stickers.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StickerCell
      cell.fill(sticker: stickers[indexPath.row])
  return cell
  }

}
