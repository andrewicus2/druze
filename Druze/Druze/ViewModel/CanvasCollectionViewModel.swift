//
//  CanvasViewModel.swift
//  Dragging Text
//
//  Created by drew on 11/24/23.
//

/// TODO:
///  Make stack items Codable
///  Reading and writing to Json
///  Use environment object


import SwiftUI

class CanvasCollectionViewModel: ObservableObject {
    // Canvas Stack
    @Published var canvasCollection: CanvasCollection
    
    let saveFileName = "druzeCreationsTesting.json"
    
    init() {
        print("Canvas Model Init")
        
        canvasCollection = CanvasCollection(JSONfileName: saveFileName)
    }
    
    // Errors
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    func updateItem(canvas: CanvasBaseModel) {
        canvasCollection.updateItem(canvas: canvas)
        saveModel()
    }
    
    func saveModel() {
        canvasCollection.saveAsJSON(fileName: saveFileName)
    }
    
    func deleteItem(canvas: CanvasBaseModel) {
        canvasCollection.deleteItem(canvas: canvas)
        saveModel()
    }
    
    func addCanvas(canvas: CanvasBaseModel) {
        canvasCollection.addItem(newCanvas: canvas)
        saveModel()
    }
}
