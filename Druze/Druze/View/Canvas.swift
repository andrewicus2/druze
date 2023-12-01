//
//  Canvas.swift
//  Dragging Text
//
//  Created by drew on 11/24/23.
//

import SwiftUI

struct Canvas: View {
    var height: CGFloat = .infinity
    @EnvironmentObject var canvasModel: CanvasViewModel
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            ZStack {
                Color.white
                
                ForEach($canvasModel.stack) { $stackItem in
                    CanvasSubView(stackItem: $stackItem) {
                        stackItem.view
                            .padding(stackItem.id == canvasModel.selected?.id ? 4 : 0)
                            .border(.green, width: stackItem.id == canvasModel.selected?.id ? 4 : 0)
                    } selected: {
                        selected(stackItem: stackItem)
                    }
                }
            }
            .frame(width: size.width, height: size.height)
        }
        .frame(maxHeight: height)
        .clipped()
    }
    
    func selected(stackItem: StackItem) {
        canvasModel.selected?.selected = false
        canvasModel.selected = stackItem
    }
    
    func getIndex(stackItem: StackItem) -> Int {
        return canvasModel.stack.firstIndex { item in
            return item.id == stackItem.id
        } ?? 0
    }
}

#Preview {
    Home()
}

// Canvas Subview
struct CanvasSubView<Content: View>: View {
    var content: Content
    @Binding var stackItem: StackItem
    var selected: ()->()
    

    
    @State var hapticScale: CGFloat = 1
    
    init(stackItem: Binding<StackItem>, @ViewBuilder content: @escaping () -> Content, selected: @escaping () -> ()) {
        self.content = content()
        self._stackItem = stackItem
        self.selected = selected
    }
    
    var body: some View {
        ZStack {
            if let contentR = stackItem.rect {
                contentR
                    .fill($stackItem.backgroundColor.wrappedValue ?? Color.black)
                    .frame(width: 200, height: 200)
            } else if let contentI = stackItem.image {
                contentI
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width / 1.5)
            } else if let contentT = stackItem.text {
                contentT
                    .font(.title3)
                    .foregroundStyle(.black)
            }
        }
    }
}
