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
    
    var bgR:CGFloat = 0.976
    var bgG:CGFloat = 0.322
    var bgB:CGFloat = 0.016
    var bgA:Double = 1.0
    
    var backgroundColor:Color {
        return colorFromRGB(r: bgR, g: bgG, b: bgB, a: bgA)
    }
    
    var txtR:CGFloat = 1.0
    var txtG:CGFloat = 1.0
    var txtB:CGFloat = 1.0
    var txtA:Double = 1.0
    
    var textColor:Color {
        return colorFromRGB(r: txtR, g: txtG, b: txtB, a: txtA)
    }
    
    var textBold: Bool = true
    
    var hapticScale: Double = 1

    func colorFromRGB(r: CGFloat, g: CGFloat, b:CGFloat, a:CGFloat) -> Color {
        return Color(red: r, green: g, blue: b, opacity: a)
    }
    
    
    func updateBGColor(color: Color) {
        
    }
}
