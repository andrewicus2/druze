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
    @Published var canvasModel: CanvasBaseModel
    
    let saveFileName = "canvas.json"
    
    init() {
        print("Model Init")
        
        canvasModel = CanvasBaseModel(JSONfileName: saveFileName)
    }
    
    // Errors
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    @Published var backgroundImage: UIImage = UIImage(imageLiteralResourceName: "druze-default")
    
    // Adding Image to Stack
    func addImageToStack(image: Data) {
        // Creating SwiftUI Image View and Appending into stack
        
        canvasModel.addItem(newItem: StackItem(type: "img", image: image))
    }
    
    // Drew's Code
    
    func addShapeToStack(type: String) {
//        let shape = Image(systemName: "\(type).fill")
        
        canvasModel.addItem(newItem: StackItem(type: "shape", shape: type))
    }
    
    func addTextToStack(text: String) {
        
        canvasModel.addItem(newItem:StackItem(type: "text", text: text))
    }
    
    func updateItem(item: StackItem) {
        canvasModel.updateItem(item: item)
        saveModel()
    }
    
    func saveModel() {
        print("Document saveModel")
        canvasModel.saveAsJSON(fileName: saveFileName)
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
