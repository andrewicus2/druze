//
//  CanvasCollection.swift
//  Druze
//
//  Created by drew on 12/12/23.
//

import Foundation

struct CanvasInfo: Hashable {
    var id: String
    var name: String
}

class CanvasCollection: Identifiable, ObservableObject {
    @Published var collection: [CanvasInfo]
    
    var id = UUID().uuidString
    
    init() {
        collection = []
    }

    func addItem(canvasID: String, canvasName: String) {
        collection.append(CanvasInfo(id: canvasID, name: canvasName))
    }
    
//    mutating func updateItem(item: StackItem) {
//        if let index = getIndex(stackItem: item) {
//            stack[index] = item
//        }
//    }
    
//    func getIndex(stackItem: StackItem) -> Int? {
//        return stack.firstIndex { item in
//            return item == stackItem
//        }
//    }
    
//    mutating func deleteItem(stackItem: StackItem) {
//        if let index = getIndex(stackItem: stackItem) {
//            stack.remove(at: index)
//        }
//    }
    
//    mutating func moveToFront(stackItem: StackItem) {
//        if let index = getIndex(stackItem: stackItem) {
//            stack.append(stack.remove(at: index))
//        }
//    }
}
