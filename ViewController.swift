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

  @IBOutlet var collectionView: UICollectionView!

  var pagedList: APIPagedList<Sticker>? {
    didSet {
      pagedList?.loadMore { _ in
        self.collectionView.reloadData()
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.register(UINib(nibName: "StickerCell", bundle: nil),
                            forCellWithReuseIdentifier: "cell")
    pagedList = StickerService.getStickers()
    // Do any additional setup after loading the view, typically from a nib.
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

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offset = scrollView.contentOffset.y
    let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
    guard let pagedList = pagedList, (maxOffset - offset) <= 800,
      pagedList.hasMore, !pagedList.loading else { return }
    pagedList.loadMore { [weak self] _ in
      self?.collectionView.reloadData()
    }
  }

}

extension ViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return pagedList?.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StickerCell
    if let sticker = pagedList?[indexPath.row] {
      cell.fill(sticker: sticker)
    }
    return cell
  }

}
