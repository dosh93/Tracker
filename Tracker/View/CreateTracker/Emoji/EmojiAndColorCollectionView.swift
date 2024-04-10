//
//  EmojiUITable.swift
//  Tracker
//
//  Created by Dosh on 04.04.2024.
//

import UIKit

enum SectionItem {
    case emoji(String)
    case color(UIColor)
}

struct Section {
    let title: String
    let items: [SectionItem]
}


class EmojiAndColorCollectionView: NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    private var sections: [Section] = [
        Section(title: "Emoji", items: [.emoji("🙂"), .emoji("😻"), .emoji("🌺"), .emoji("🐶"), .emoji("❤️"), .emoji("😱"), .emoji("😇"), .emoji("😡"), .emoji("🥶"), .emoji("🤔"), .emoji("🙌"), .emoji("🍔"), .emoji("🥦"), .emoji("🏓"), .emoji("🥇"), .emoji("🎸"), .emoji("🏝"), .emoji("😪")]),
        Section(title: "Цвет", items: [.color(.ypColor1), .color(.ypColor2), .color(.ypColor3), .color(.ypColor4), .color(.ypColor5), .color(.ypColor6), .color(.ypColor7), .color(.ypColor8), .color(.ypColor9), .color(.ypColor10), .color(.ypColor11), .color(.ypColor12), .color(.ypColor13), .color(.ypColor14), .color(.ypColor15), .color(.ypColor16), .color(.ypColor17), .color(.ypColor18)])
    ]
    
    private var selectedEmojiIndexPath: IndexPath?
    private var selectedColorIndexPath: IndexPath?
    weak var delegate: EmojiAndColorCollectionViewDelegate?
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - 16 * 2 - 5 * 6
        let cellWidth =  availableWidth / 6
        return CGSize(width: cellWidth, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionItem = sections[indexPath.section].items[indexPath.row]
        
        switch sectionItem {
            
        case.emoji(let emoji):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCollectionViewCell.identifier, for: indexPath) as? EmojiCollectionViewCell else { return UICollectionViewCell() }
            cell.setCell(emoji: emoji, isSelect: selectedEmojiIndexPath == indexPath)
            return cell
            
        case .color(let color):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.identifier, for: indexPath) as? ColorCollectionViewCell else { return UICollectionViewCell() }
            cell.setCell(color: color, isSelect: selectedColorIndexPath == indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: EmojiAndColorCollectionViewHeader.identifier, for: indexPath) as? EmojiAndColorCollectionViewHeader else { return UICollectionReusableView() }
        
        header.headerLabel.text = sections[indexPath.section].title
  
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionItem = sections[indexPath.section].items[indexPath.row]
        
        switch sectionItem {
            
        case.emoji(let emoji):
            let oldIndexPath = selectedEmojiIndexPath
            selectedEmojiIndexPath = indexPath
            
            var indexPathsToReload: [IndexPath] = []
            if let oldIndexPath = oldIndexPath, oldIndexPath != indexPath {
                indexPathsToReload.append(oldIndexPath)
            }
            indexPathsToReload.append(indexPath)
            
            collectionView.reloadItems(at: indexPathsToReload)
            delegate?.selectEmoji(emoji)
        case .color(let color):
            let oldIndexPath = selectedColorIndexPath
            selectedColorIndexPath = indexPath
            
            var indexPathsToReload: [IndexPath] = []
            if let oldIndexPath = oldIndexPath, oldIndexPath != indexPath {
                indexPathsToReload.append(oldIndexPath)
            }
            indexPathsToReload.append(indexPath)
            
            collectionView.reloadItems(at: indexPathsToReload)
            delegate?.selectColor(color)
        }
    }
}
