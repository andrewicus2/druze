//
//  CanvasBaseModel.swift
//  Druze
//
//  Created by drew on 12/5/23.
//

import Foundation
import SwiftUI


struct CanvasBaseModel: Codable {
    var stack: [StackItem]
    
//    var backgroundImage: Data
    
    init() {
        stack = [];
        
//        backgroundImage = Data()
//
//        if let image = UIImage(named: "druze-default") {
//            print(image)
//            if let data = image.pngData() {
//                print("hi")
//                backgroundImage = data
//            }
//        }

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
            return item == stackItem
        }
    }
    
    mutating func deleteItem(stackItem: StackItem) {        
        if let index = getIndex(stackItem: stackItem) {
            stack.remove(at: index)
        }
    }
    
    mutating func moveToFront(stackItem: StackItem) {
        if let index = getIndex(stackItem: stackItem) {
            stack.append(stack.remove(at: index))
        }
    }
}
