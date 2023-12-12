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
    
    let fileName = "canvs-new-json.json"
    
    @Published var selected: StackItem?
    
    @Published var viewStack: [String : StackItemView]
    
    @Published var backgroundImage: UIImage
    
    
    init() {
        print("Model Init")
                
        canvasBaseModel = CanvasBaseModel(JSONfileName: fileName)
        backgroundImage = UIImage(imageLiteralResourceName: "druze-default")
        viewStack = [:]
        
        if !canvasBaseModel.stack.isEmpty {
            for stackItem in canvasBaseModel.stack {
                if let imageData = stackItem.image {
                    if let imageView = UIImage(data: imageData) {
                        viewStack[stackItem.id] = StackItemView(imageView: Image(uiImage: imageView))
                    }
                } else if let shapeData = stackItem.shape {
                    viewStack[stackItem.id] = StackItemView(shapeView: Image(systemName: "\(shapeData).fill"))
                } else if let textData = stackItem.text {
                    viewStack[stackItem.id] = StackItemView(textView: Text(textData))
                }
            }
        }
                
        if let bgImage = canvasBaseModel.backgroundImage {
            if let uiBG = UIImage(data: bgImage) {
                backgroundImage = uiBG
            }
        }
    }
    
    // Errors
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    
    // Adding Image to Stack
    func addImageToStack(image: Data) {
        // Creating SwiftUI Image View and Appending into stack
        let addedItem = StackItem(type: "img", image: image)
        
        canvasBaseModel.addItem(newItem: addedItem)
        if let imageView = UIImage(data: image) {
            viewStack[addedItem.id] = StackItemView(imageView: Image(uiImage: imageView))
        }
    }
    
    // Drew's Code
    
    func addShapeToStack(type: String) {
        let addedItem = StackItem(type: "shape", shape: type)

        
        canvasBaseModel.addItem(newItem: addedItem)
        viewStack[addedItem.id] = StackItemView(shapeView: Image(systemName: "\(type).fill"))
    }
    
    func addTextToStack(text: String) {
        
        let addedItem = StackItem(type: "text", text: text)
        
        canvasBaseModel.addItem(newItem: addedItem)
        viewStack[addedItem.id] = StackItemView(textView: Text(text))
    }
    
    func updateItem(item: StackItem) {
        canvasBaseModel.updateItem(item: item)
        saveModel()
    }
    
    func saveModel() {
        canvasBaseModel.saveAsJSON(fileName: fileName)
    }
    
    func deleteItem(item: StackItem) {
        canvasBaseModel.deleteItem(stackItem: item)
        viewStack.removeValue(forKey: item.id)
    }
    
    func moveToFront(item: StackItem) {
        canvasBaseModel.moveToFront(stackItem: item)
    }
    
    func changeBGImage(image: UIImage, data: Data) {
        backgroundImage = image
        canvasBaseModel.backgroundImage = data
        saveModel()
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
