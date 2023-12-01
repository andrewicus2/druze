//
//  StackItem.swift
//  Dragging Text
//
//  Created by drew on 11/24/23.
//

import SwiftUI


// Holds each Stack Item View
struct StackItem: Identifiable, Equatable {
    var id = UUID().uuidString
    var view: AnyView
    var type: String
    
    var image: Image?
    var rect: Rectangle?
    var text: Text?
    
    
    // Equatable - Drew
    static func ==(st1: StackItem, st2: StackItem) -> Bool {
        return st1.id == st2.id
    }
    
    // Gesture Properties
    
    var offset: CGSize = .zero
    var lastOffset: CGSize = .zero
    var scale: CGFloat = 1
    var lastScale: CGFloat = 1
    var rotation: Angle = .zero
    var lastRotation: Angle = .zero
        
    var width: CGFloat = 200
    var lastWidth: CGFloat = 200
    
    var height: CGFloat = 200
    var lastHeight: CGFloat = 200
    
    var textBody: String = "Lorem Ipsum"
    
    var backgroundColor: Color = .red
    var foreroundColor: Color?
}
