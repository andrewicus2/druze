//
//  StackItem.swift
//  Dragging Text
//
//  Created by drew on 11/24/23.
//

import SwiftUI


// Holds each Stack Item View

// Does not conform to Codable??

struct StackItem: Identifiable, Equatable, Codable {
    var id = UUID().uuidString
//    var view: AnyView
    var type: String
    

    
    var image: Data?
    var shape: String?
    var text: String?
    
    var imageView: Image {
        if let imgData = image {
            if let uiImg = UIImage(data: imgData) {
                return Image(uiImage: uiImg)
            }
        }
        return Image(systemName: "x")
    }
    
    // Equatable - Drew
    static func ==(st1: StackItem, st2: StackItem) -> Bool {
        return st1.id == st2.id
    }
    
    // Gesture Properties
    
    var offset: CGSize = .zero // extension to make it codable
    var lastOffset: CGSize = .zero
    var scale: Double = 1
    var lastScale: Double = 1
    var rotation: Double = 0
    var lastRotation: Double = 0
        
    var width: Double = 200
    var lastWidth: Double = 200
    
    var height: Double = 200
    var lastHeight: Double = 200
    
    var textBody: String = "Lorem Ipsum"
    
    var backgroundColor: String = "black"
    var textColor: String = "white"
    var textBold: Bool = true
}
