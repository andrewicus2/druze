//
//  CanvasBaseModel.swift
//  Druze
//
//  Created by drew on 12/5/23.
//

import Foundation
import SwiftUI


struct CanvasCollection: Codable {
    var group: [CanvasBaseModel]
        
    init() {
        group = [];
    }
    
    mutating func addItem(newCanvas: CanvasBaseModel) {
        group.append(newCanvas)
    }
    
    mutating func updateItem(canvas: CanvasBaseModel) {
        if let index = getIndex(canvas: canvas) {
            group[index] = canvas
        }
    }
    
    func getIndex(canvas: CanvasBaseModel) -> Int? {
        return group.firstIndex { item in
            return item == canvas
        }
    }

    
    mutating func deleteItem(canvas: CanvasBaseModel) {
        if let index = getIndex(canvas: canvas) {
            group.remove(at: index)
        }
    }
}
