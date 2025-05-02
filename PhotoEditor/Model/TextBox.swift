//
//  TextBox.swift
//  PhotoEditor
//
//  Created by Андрей Фроленков on 2.05.25.
//

import SwiftUI
import PencilKit

struct TextBox: Identifiable {
    
    var id = UUID().uuidString
    var text: String = ""
    var isBold: Bool = false
    var offset: CGSize = .zero
    var lastOffset: CGSize = .zero
    var textColor: Color = .white
    var isAdded: Bool = false
}
