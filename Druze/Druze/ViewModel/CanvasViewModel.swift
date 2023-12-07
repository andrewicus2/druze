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

// Holds all canvas data
class CanvasViewModel: ObservableObject {
    // Canvas Stack
    @Published var canvasBaseModel: CanvasBaseModel
    
    let saveFileName = "canvas.json"
    
    @Published var selected: StackItem?
    
    init() {
        print("Model Init")
        
        canvasBaseModel = CanvasBaseModel(JSONfileName: saveFileName)
        
        
//        backgroundImage = UIImage()
//        if let bgImage = UIImage(data: canvasBaseModel.backgroundImage) {
//            backgroundImage = bgImage
//        }
        
    }
    
    // Errors
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    @Published var backgroundImage: UIImage?
    
    // Adding Image to Stack
    func addImageToStack(image: Data) {
        // Creating SwiftUI Image View and Appending into stack
        
        canvasBaseModel.addItem(newItem: StackItem(type: "img", image: image))
    }
    
    // Drew's Code
    
    func addShapeToStack(type: String) {
//        let shape = Image(systemName: "\(type).fill")
        
        canvasBaseModel.addItem(newItem: StackItem(type: "shape", shape: type))
    }
    
    func addTextToStack(text: String) {
        
        canvasBaseModel.addItem(newItem:StackItem(type: "text", text: text))
    }
    
    func updateItem(item: StackItem) {
        canvasBaseModel.updateItem(item: item)
        saveModel()
    }
    
    func saveModel() {
//        print("Document saveBaseModel")
        canvasBaseModel.saveAsJSON(fileName: saveFileName)
    }
    
    func deleteItem(item: StackItem) {
        canvasBaseModel.deleteItem(stackItem: item)
    }
    
    func moveToFront(item: StackItem) {
        canvasBaseModel.moveToFront(stackItem: item)
    }
    
    
    
//    func addLineToStack(points: [CGPoint]) {
//        var path = Path()
//        path.addLines(points)
//        
//        stack.append(StackItem(view: AnyView(path), type: "path", line: path))
//    }
    
//    func getActiveIndex() -> Int {
//        if let active = selected {
//            if let index = stack.firstIndex(of: active) {
//                return index
//            }
//        }
//        return 0
//    }
    
//    func resetCanvas() {
//        stack.removeAll()
//        backgroundImage = UIImage(imageLiteralResourceName: "druze-default")
//    }
//    
//    func deleteActive() {
//        stack.remove(at: getActiveIndex())
//        selected = nil
//    }
//    
//    func moveActiveToFront() {
//        stack.append(stack.remove(at: getActiveIndex()))
//    }
//    
//    func moveActiveToBack() {
//        stack.insert(stack.remove(at: getActiveIndex()), at: 0)
//    }
    
//    func changeActiveColor(color: Color) {
//        selected?.backgroundColor = color
//    }
}
