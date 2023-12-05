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
    @Published var stack: [StackItem] = []
    
    //    @Published var stack = [StackItem]() {
    //        didSet {
    //            if let encoded = try? JSONEncoder().encode(stack) {
    //                UserDefaults.standard.set(encoded, forKey: "Stack")
    //            }
    //        }
    //    }
    //
    //    init() {
    //
    //    }
    
    @Published var selected: StackItem?
    
    // Image Picker
    @Published var showImagePicker: Bool = false
    @Published var imageData: Data = .init(count: 0)
    
    // Errors
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    @Published var backgroundImage: UIImage = UIImage(imageLiteralResourceName: "druze-default")
    
    // Adding Image to Stack
    func addImageToStack(image: UIImage) {
        // Creating SwiftUI Image View and Appending into stack
        
        let imageView = Image(uiImage: image)
        
        stack.append(StackItem(view: AnyView(imageView), type: "img", image: imageView))
    }
    
    // Drew's Code
    
    func addShapeToStack(type: String) {
        let shape = Image(systemName: "\(type).fill")
        
        stack.append(StackItem(view: AnyView(shape), type: "shape", shape: shape))
    }
    
    func addTextToStack(text: String) {
        
        let textView = Text(text)
        
        stack.append(StackItem(view: AnyView(textView), type: "text", text: textView))
    }
    
//    func addLineToStack(points: [CGPoint]) {
//        var path = Path()
//        path.addLines(points)
//        
//        stack.append(StackItem(view: AnyView(path), type: "path", line: path))
//    }
    
    func getActiveIndex() -> Int {
        if let active = selected {
            if let index = stack.firstIndex(of: active) {
                return index
            }
        }
        return 0
    }
    
    func resetCanvas() {
        stack.removeAll()
        backgroundImage = UIImage(imageLiteralResourceName: "druze-default")
    }
    
    func deleteActive() {
        stack.remove(at: getActiveIndex())
        selected = nil
    }
    
    func moveActiveToFront() {
        stack.append(stack.remove(at: getActiveIndex()))
    }
    
    func moveActiveToBack() {
        stack.insert(stack.remove(at: getActiveIndex()), at: 0)
    }
    
    func changeActiveColor(color: Color) {
        selected?.backgroundColor = color
    }
}
