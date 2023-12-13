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
    
    let fileName = "Druze-Storage.json"
    
    init() {
        canvasCollection = CanvasCollection(JSONfileName: fileName)
        
    }
    
    func addCanvas(canvasID: String, canvasName: String) {
        let addCan = CanvasInfo(id: canvasID, name: canvasName)
        canvasCollection.addItem(newCan: addCan)
        saveModel()
    }
    
    func saveModel() {
        canvasCollection.saveAsJSON(fileName: fileName)
    }
}
