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
                    } moveFront: {
                        moveViewToFront(stackItem: stackItem)
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
    
    func moveViewToFront(stackItem: StackItem) {
        let currentIndex = getIndex(stackItem: stackItem)
        let lastIndex = canvasModel.stack.count - 1
        
        canvasModel.stack
            .insert(canvasModel.stack.remove(at: currentIndex), at: lastIndex)
    }
}

#Preview {
    Home()
}

// Canvas Subview
struct CanvasSubView<Content: View>: View {
    var content: Content
    @Binding var stackItem: StackItem
    var moveFront: ()->()
    var selected: ()->()
    
    init(stackItem: Binding<StackItem>, @ViewBuilder content: @escaping ()-> Content, moveFront: @escaping ()->(), selected: @escaping ()->()) {
        self.content = content()
        self._stackItem = stackItem
        self.moveFront = moveFront
        self.selected = selected
    }
    
    @State var hapticScale: CGFloat = 1
    
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
            .rotationEffect(stackItem.rotation)
            .scaleEffect(stackItem.scale < 0.4 ? 0.4 : stackItem.scale)
            .scaleEffect(hapticScale)
            .offset(stackItem.offset)
            .onLongPressGesture(minimumDuration: 0.3) {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                withAnimation(.easeInOut){
                    hapticScale = 1.2
                }
                withAnimation(.easeInOut.delay(0.05)) {
                    hapticScale = 1
                }
                stackItem.selected.toggle()
                selected()
            }
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        stackItem.offset = CGSize(width: stackItem.lastOffset.width + value.translation.width, height: stackItem.lastOffset.height + value.translation.height)
                    }).onEnded({ value in
                        stackItem.lastOffset = stackItem.offset
                    })
            )
            .gesture(
                MagnifyGesture()
                    .onChanged({ value in
                        stackItem.scale = stackItem.lastScale + (value.magnification - 1)
                    }) .onEnded({ value in
                        stackItem.lastScale = stackItem.scale
                    })
                    .simultaneously(with:
                        RotationGesture()
                        .onChanged({ value in
                            stackItem.rotation = stackItem.lastRotation + value
                        }).onEnded({ value in
                            stackItem.lastRotation = stackItem.rotation
                        })
                    )
            )
    }
}
