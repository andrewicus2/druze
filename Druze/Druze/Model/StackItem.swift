//
//  StackItem.swift
//  Dragging Text
//
//  Created by drew on 11/24/23.
//

import SwiftUI


import SwiftUI

class StackItem: ObservableObject, Identifiable, Equatable {
    var id = UUID().uuidString
    var view: AnyView
    var type: String
    
    var image: Image?
    var rect: Rectangle?
    var text: Text?
    
    // Gesture Properties
    @Published var offset: CGSize = .zero
    @Published var lastOffset: CGSize = .zero
    @Published var scale: CGFloat = 1
    @Published var lastScale: CGFloat = 1
    @Published var rotation: Angle = .zero
    @Published var lastRotation: Angle = .zero
    
    @Published var selected: Bool = false
    
    @Published var backgroundColor: Color?
    @Published var foregroundColor: Color?
    
    // Equatable
    static func ==(st1: StackItem, st2: StackItem) -> Bool {
        return st1.id == st2.id
    }
    
    init(view: AnyView, type: String, backgroundColor: Color? = Color.black, foregroundColor: Color? = Color.black,
         image: Image? = nil, rect: Rectangle? = nil, text: Text? = nil) {
        self.view = view
        self.type = type
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.image = image
        self.rect = rect
        self.text = text
    }
}
