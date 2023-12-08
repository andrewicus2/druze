//
//  StackItemView.swift
//  Druze
//
//  Created by drew on 12/7/23.
//

import Foundation
import SwiftUI


//
//  StackItem.swift
//  Dragging Text
//
//  Created by drew on 11/24/23.
//

import SwiftUI


// Holds each Stack Item View

// Does not conform to Codable??

struct StackItemView: Identifiable, Equatable {
    var id = UUID().uuidString
    var imageView: Image?
    var shapeView: Image?
    var textView: Text?
}

