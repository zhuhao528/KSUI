//
//  UKSClassifySelectCollectionViewLayout.swift
//  KSBook
//
//  Created by zhu hao on 2020/10/16.
//  Copyright © 2020 kaishu. All rights reserved.
//

import UIKit

class UKSClassifySelectCollectionViewLayout: UICollectionViewFlowLayout {

    fileprivate lazy var cellAttrs: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()

    var attr1: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forCellWith: NSIndexPath(row: 0, section: 0) as IndexPath)

    var lastSection = -1

    var maxWidth: CGFloat = 0

    var maxHeight: CGFloat = 0
}

extension UKSClassifySelectCollectionViewLayout {
    override func prepare() {
        super.prepare()

        // 防止collectionView为空
        guard let collectionView = collectionView else { return }

        // 1.获取一共多少组
        let sectionCount = collectionView.numberOfSections

        attr1 = UICollectionViewLayoutAttributes(forCellWith: NSIndexPath(row: 0, section: 0) as IndexPath)
        // 2.获取每组中有多少个Item
        for i in 0..<sectionCount {

            let itemCount = collectionView.numberOfItems(inSection: i)

            for j in 0..<itemCount {

                // 2.1.获取Cell对应的indexPath
                let indexPath = IndexPath(item: j, section: i)

                // 2.2.根据indexPath创建UICollectionViewLayoutAttributes
                guard let attr = super.layoutAttributesForItem(at: indexPath) else { continue }

                if i != lastSection { /// 换section时
                    let x = minimumInteritemSpacing
                    let lineSpace = i == 0 ? 0 : minimumLineSpacing
                    let y = attr1.frame.origin.y + attr1.bounds.size.height + lineSpace
                    attr.frame = CGRect(x: CGFloat(x), y: y, width: itemSize.width, height: itemSize.height)
                    /// 统计最大高度
                    maxHeight = y + itemSize.height
                } else {
                    let viewWidth = collectionView.frame.size.width - attr1.frame.origin.x - attr1.bounds.size.width
                    if viewWidth >= itemSize.width { /// 同一行
                        let x = attr1.frame.origin.x + attr1.frame.size.width + minimumInteritemSpacing
                        let y = attr1.frame.origin.y
                        attr.frame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
                        /// 统计最大高度
                        maxHeight = y + itemSize.height
                    } else { /// 换行时
                        let x = itemSize.width + sectionInset.right + minimumInteritemSpacing * 2
                        let y = attr1.frame.origin.y + attr1.bounds.size.height + minimumLineSpacing
                        attr.frame = CGRect(x: CGFloat(x), y: y, width: itemSize.width, height: itemSize.height)
                        /// 统计最大宽度
                        maxWidth = attr1.frame.origin.x + attr1.bounds.size.width + minimumInteritemSpacing
                    }
                }

                attr1 = attr
                lastSection = i

                // 2.4.保存attr到数组中
                cellAttrs.append(attr)
            }
        }

    }
}

extension UKSClassifySelectCollectionViewLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellAttrs
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: maxWidth, height: maxHeight)
    }
}
