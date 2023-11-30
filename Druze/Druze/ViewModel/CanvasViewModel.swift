//
//  CanvasViewModel.swift
//  Dragging Text
//
//  Created by drew on 11/24/23.
//

import SwiftUI

// Holds all canvas data
class CanvasViewModel: ObservableObject {
    // Canvas Stack
    @Published var stack: [StackItem] = []
    
    @Published var selected: StackItem?
    
    // Image Picker
    @Published var showImagePicker: Bool = false
    @Published var imageData: Data = .init(count: 0)
    
    // Errors
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    // Adding Image to Stack
    func addImageToStack(image: UIImage) {
        // Creating SwiftUI Image View and Appending into stack
        
        let imageView = Image(uiImage: image)
        
        stack.append(StackItem(view: AnyView(imageView), type: "img", image: imageView))
    }
    
    // Drew's Code
    
    func addShapeToStack() {
        let rect = Rectangle()
        
        stack.append(StackItem(view: AnyView(rect), type: "rect", rect: rect))
    }
    
    func addTextToStack() {
        let text = Text("Lorem Ipsum")
 
        
        stack.append(StackItem(view: AnyView(text), type: "text", text: text))
    }
    
    func getActiveIndex() -> Int {
        if let active = selected {
            if let index = stack.firstIndex(of: active) {
                return index
            }
        }
        return 0
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
        if let active = selected {
            active.backgroundColor = Color.red
        }
        selected.backgroundColor = Color.red
    }
}
