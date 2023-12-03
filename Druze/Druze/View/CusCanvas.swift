//
//  Canvas.swift
//  Dragging Text
//
//  Created by drew on 11/24/23.
//

import SwiftUI

struct CustCanvas: View {
    var height: CGFloat = .infinity
    @EnvironmentObject var canvasModel: CanvasViewModel
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            ZStack {
                Color.white
                    .onTapGesture(count: 1) {
                        canvasModel.selected = nil
                    }
                
                ForEach($canvasModel.stack) { $stackItem in
                    CanvasSubView(stackItem: $stackItem, selectedItem: canvasModel.selected ?? nil) {
                        stackItem.view
                    } selected: {
                        selected(stackItem: stackItem)
                    } deleteItem: {
                        deleteItem(stackItem: stackItem)
                    } moveToFront: {
                        moveToFront(stackItem: stackItem)
                    }
                }
            }
            .frame(width: size.width, height: size.height)
        }
        .frame(maxHeight: height)
        .clipped()
    }
    
    func selected(stackItem: StackItem) {
        if(stackItem == canvasModel.selected) {
            return
        } else {
            canvasModel.selected = stackItem
        }
    }
    
    func getIndex(stackItem: StackItem) -> Int {
        return canvasModel.stack.firstIndex { item in
            return item.id == stackItem.id
        } ?? 0
    }
    
    func deleteItem(stackItem: StackItem) {
        canvasModel.stack.remove(at: getIndex(stackItem: stackItem))
    }
    
    func moveToFront(stackItem: StackItem) {
        canvasModel.stack.append(canvasModel.stack.remove(at: getIndex(stackItem: stackItem)))
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
    var deleteItem: ()->()
    var moveToFront: ()->()
    @State var deleteConfirmation: Bool = false
    @State var height: CGFloat = .zero
    @State var width: CGFloat = .zero
    var selectedItem: StackItem?
    
    @EnvironmentObject var canvasModel: CanvasViewModel
    
    @State var hapticScale: CGFloat = 1
    
    init(stackItem: Binding<StackItem>, selectedItem: StackItem?, @ViewBuilder content: @escaping () -> Content, selected: @escaping () -> (), deleteItem: @escaping () -> (), moveToFront: @escaping () -> ()) {
        self.content = content()
        self._stackItem = stackItem
        self.selected = selected
        self.deleteItem = deleteItem
        self.moveToFront = moveToFront
        self.selectedItem = selectedItem
    }
    
    var body: some View {
        ZStack {
            if let contentS = stackItem.shape {
                contentS
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(stackItem.backgroundColor)
                    .frame(width: stackItem.width)
            } else if let contentI = stackItem.image {
                contentI
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: stackItem.width)
            } else if let contentT = stackItem.text {
                contentT
                    .font(.system(size: 500))
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
                    .fontWeight(stackItem.textBold ? .bold : .regular)
                    .foregroundStyle(stackItem.textColor)
                    .padding(20)
                    .frame(width: stackItem.width)
                    .background(stackItem.backgroundColor)
            } else if let contentP = stackItem.line {
                Canvas { ctx, size in
                    ctx.stroke(contentP, with: .color(stackItem.backgroundColor), style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay( /// apply a rounded border https://stackoverflow.com/questions/71744888/swiftui-view-with-rounded-corners-and-border
            RoundedRectangle(cornerRadius: 10)
                .stroke(.thinMaterial, lineWidth: stackItem == selectedItem ? 5 : 0)
        )
        .rotationEffect(stackItem.rotation)
        .scaleEffect(hapticScale)
        .scaleEffect(1)
        .offset(stackItem.offset)
        .onLongPressGesture(minimumDuration: 0.3) {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            withAnimation(.easeInOut){
                hapticScale = 1.2
            }
            withAnimation(.easeInOut.delay(0.05)) {
                hapticScale = 1
            }
            selected()
        }
        .gesture(
            MagnifyGesture()
                .onChanged({ value in
                    stackItem.scale = stackItem.lastScale + (value.magnification - 1)
                    stackItem.width = stackItem.lastWidth * stackItem.scale
                    stackItem.height = stackItem.lastHeight * stackItem.scale
                })
                .onEnded({ value in
                    stackItem.lastWidth = stackItem.width
                    stackItem.lastHeight = stackItem.height
                })
                .simultaneously(with: RotationGesture()
                    .onChanged({ value in
                        stackItem.rotation = stackItem.lastRotation + value
                    }).onEnded({ value in
                        stackItem.lastRotation = stackItem.rotation
                    })
                )
                .simultaneously(with: DragGesture()
                    .onChanged({ value in
                        stackItem.offset = CGSize(width: stackItem.lastOffset.width + value.translation.width, height: stackItem.lastOffset.height + value.translation.height)
                    }).onEnded({ value in
                        stackItem.lastOffset = stackItem.offset
                    })
                ))
        
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        height = geo.size.height
                        width = geo.size.width
                    }
                    .onChange(of:stackItem.scale) {
                        
                        height = geo.size.height
                        width = geo.size.width
                    }
            }
        )
        .alert("Are you sure you want to delete this?", isPresented: $deleteConfirmation) {
            Button("Delete", role: .destructive) { deleteItem() }
            Button("Cancel", role: .cancel) { }
        }
        
        
        
        /// UI ON SELECTION
        ///  CANNOT FIGURE OUT HOW TO ALIGN THIS TO THE BOTTOM OF THE VIEW
        if(canvasModel.selected == stackItem) {
            HStack {
                if(canvasModel.selected?.type != "img") {
                    ColorPicker("BG Color Picker", selection: $stackItem.backgroundColor)
                        .labelsHidden()
                        .padding(5)
                }
                if(canvasModel.selected?.type == "text") {
                    ColorPicker("Text Color Picker", selection: $stackItem.textColor)
                        .labelsHidden()
                        .padding(5)
                    
                    Button {
                        stackItem.textBold.toggle()
                    } label: {
                        Image(systemName: "bold")
                            .padding()
                            .background(stackItem.textBold ? Color.gray : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                
                Button {
                    moveToFront()
                } label: {
                    Image(systemName: "square.2.layers.3d.top.filled")
                }
                .padding(5)
                
                Button {
                    deleteConfirmation.toggle()
                } label: {
                    Image(systemName: "trash")
                        .font(.title3)
                }
                .padding(5)
            }
            .foregroundStyle(.white)
            .padding(10)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .offset(stackItem.offset)
        }
    }
}
