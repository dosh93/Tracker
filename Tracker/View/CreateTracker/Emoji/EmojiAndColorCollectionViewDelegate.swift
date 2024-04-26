//
//  EmojiCollectionViewDelegate.swift
//  Tracker
//
//  Created by Dosh on 04.04.2024.
//

import UIKit

protocol EmojiAndColorCollectionViewDelegate: AnyObject {
    func selectEmoji(_ emoji: String)
    func selectColor(_ color: UIColor)
}
