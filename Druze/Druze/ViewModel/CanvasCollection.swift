//
//  CanvasCollection.swift
//  Druze
//
//  Created by drew on 12/12/23.
//

import Foundation

struct CanvasInfo: Hashable, Codable {
    var id: String
    var name: String
}

struct CanvasCollection: Codable, Equatable, Identifiable {
    var collection: [CanvasInfo]
    
    var id = UUID().uuidString
    
    mutating func addItem(newCan: CanvasInfo) {
        collection.append(newCan)
    }
}

class CanvasCollectionModel: ObservableObject {
    // Canvas Stack
    @Published var canvasCollection: CanvasCollection
    
    let fileName = "Druze-Testing-Storage.json"
    
    init() {
        canvasCollection = CanvasCollection(JSONfileName: fileName)
        
    }
    
    func addCanvas(canvasID: String, canvasName: String) {
        let addCan = CanvasInfo(id: canvasID, name: canvasName)
        canvasCollection.addItem(newCan: addCan)
        saveModel()
    }
    
    
    
//    func updateItem() {
//        canvasCollection.updateItem(item: item)
//        saveModel()
//    }
    
    func saveModel() {
        canvasCollection.saveAsJSON(fileName: fileName)
    }
    
    //    func deleteItem(item: StackItem) {
    //        canvasBaseModel.deleteItem(stackItem: item)
    //        viewStack.removeValue(forKey: item.id)
    //        saveModel()
    //    }
    //
    //    func moveToFront(item: StackItem) {
    //        canvasBaseModel.moveToFront(stackItem: item)
    //        saveModel()
    //    }
    //
    //    func changeBGImage(image: UIImage, data: Data) {
    //        backgroundImage = image
    //        canvasBaseModel.backgroundImage = data
    //        saveModel()
    //    }
}



//class CanvasCollection: Identifiable, ObservableObject, Codable {
//    @Published var collection: [CanvasInfo]
//    
//    @Published var id = UUID().uuidString
//
//    func addItem(canvasID: String, canvasName: String) {
//        collection.append(CanvasInfo(id: canvasID, name: canvasName))
//    }
//}


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
