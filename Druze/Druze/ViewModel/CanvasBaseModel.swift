//
//  CanvasBaseModel.swift
//  Druze
//
//  Created by drew on 12/5/23.
//

import Foundation


struct CanvasBaseModel: Codable {
    var stack: [StackItem]
    
    var selected: UUID?
    
    init() {
        stack = [];
    }
    
    mutating func addItem(newItem: StackItem) {
        stack.append(newItem)
    }
    
    mutating func updateItem(item: StackItem) {
        if let index = getIndex(stackItem: item) {
            stack[index] = item
        }
    }
    
    func getIndex(stackItem: StackItem) -> Int? {
        return stack.firstIndex { item in
            return item.id == stackItem.id
        }
    }
}
