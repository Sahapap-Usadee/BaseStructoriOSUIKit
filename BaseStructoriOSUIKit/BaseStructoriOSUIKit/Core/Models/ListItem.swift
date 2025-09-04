//
//  ListItem.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 4/9/2568 BE.
//

import Foundation

struct ListItem: Identifiable, Equatable {
    let id: Int
    let title: String
    let subtitle: String
    var isSelected: Bool
}
