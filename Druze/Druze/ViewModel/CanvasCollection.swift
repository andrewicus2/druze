//
//  CanvasBaseModel.swift
//  Druze
//
//  Created by drew on 12/5/23.
//

import Foundation
import SwiftUI


struct CanvasCollection: Codable {
    var canvasGroup: [CanvasBaseModel]
        
    init() {
        canvasGroup = [];
    }
    
    mutating func addItem(newCanvas: CanvasBaseModel) {
        canvasGroup.append(newCanvas)
    }
    
    mutating func updateItem(canvas: CanvasBaseModel) {
        if let index = getIndex(canvas: canvas) {
            canvasGroup[index] = canvas
        }
    }
    
    func getIndex(canvas: CanvasBaseModel) -> Int? {
        return canvasGroup.firstIndex { item in
            return item == canvas
        }
    }

    
    mutating func deleteItem(canvas: CanvasBaseModel) {
        if let index = getIndex(canvas: canvas) {
            canvasGroup.remove(at: index)
        }
    }
}
