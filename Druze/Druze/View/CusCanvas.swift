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
    
    @State private var deleteConfirmation: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            ZStack {
                
                Image("druze-default")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
                    .onTapGesture(count: 1) {
                        canvasModel.selected = nil
                    }
                
                
                
                ForEach($canvasModel.canvasBaseModel.stack) { $stackItem in
                    ZStack {
                        if let shape = stackItem.shape {
                            Image(systemName: "\(shape).fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            //                    .foregroundStyle(stackItem.backgroundColor)
                                .frame(width: stackItem.width)
                        } else if(stackItem.image != nil) {
                            stackItem.imageView
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: stackItem.width)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } else if let text = stackItem.text {
                            Text(text)
                                .lineLimit(1)
                                .font(.custom(stackItem.textBold ? "RoundedMplus1c-Black" : "RoundedMplus1c-Regular", size: 500))
                                .minimumScaleFactor(0.01)
                            //                    .foregroundStyle(stackItem.textColor)
                                .padding(20)
                                .frame(width: stackItem.width)
                            //                    .background(stackItem.backgroundColor)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                            
                        }
                        
                        if(canvasModel.selected == stackItem) {
                            HStack {
                                if(canvasModel.selected?.type != "img") {
//                                    ColorPicker("BG Color Picker", selection: $stackItem.backgroundColor)
//                                        .labelsHidden()
//                                        .padding(5)
                                }
                                if(canvasModel.selected?.type == "text") {
//                                    ColorPicker("Text Color Picker", selection: $stackItem.textColor)
//                                        .labelsHidden()
//                                        .padding(5)
                                    
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
                                    canvasModel.moveToFront(item: stackItem)
                                    canvasModel.saveModel()
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
                            .alert("Are you sure you want to delete this?", isPresented: $deleteConfirmation) {
                                Button("Delete", role: .destructive) {
                                    canvasModel.deleteItem(item: stackItem)
                                    canvasModel.saveModel()
                                }
                                Button("Cancel", role: .cancel) { }
                            }
                            .foregroundStyle(.white)
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .overlay( /// apply a rounded border https://stackoverflow.com/questions/71744888/swiftui-view-with-rounded-corners-and-border
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.thinMaterial, lineWidth: stackItem == canvasModel.selected ? 5 : 0)
                    )
                    .rotationEffect(Angle(degrees: stackItem.rotation))
                    .scaleEffect(stackItem.hapticScale)
                    .scaleEffect(1)
                    .offset(stackItem.offset)
                    .onLongPressGesture(minimumDuration: 0.3) {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        withAnimation(.easeInOut){
                            stackItem.hapticScale = 1.2
                        }
                        withAnimation(.easeInOut.delay(0.05)) {
                            stackItem.hapticScale = 1
                        }
                        if(stackItem == canvasModel.selected) {
                            return
                        } else {
                            canvasModel.selected = stackItem
                        }
                    }
                    .gesture(
                        
                        DragGesture()
                            .onChanged({ value in
                                stackItem.offset = CGSize(width: stackItem.lastOffset.width + value.translation.width, height: stackItem.lastOffset.height + value.translation.height)
                            }).onEnded({ value in
                                stackItem.lastOffset = stackItem.offset
                                canvasModel.updateItem(item: stackItem)
                            })
                    )
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
                                canvasModel.updateItem(item: stackItem)
                            })
                            .simultaneously(with: RotationGesture()
                                .onChanged({ value in
                                    stackItem.rotation = stackItem.lastRotation + value.degrees
                                }).onEnded({ value in
                                    stackItem.lastRotation = stackItem.rotation
                                    canvasModel.updateItem(item: stackItem)
                                })
                            )
                    )
                }
            }
            .frame(width: size.width, height: size.height)
        }
        .frame(maxHeight: height)
        .clipped()
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
            if let shape = stackItem.shape {
                Image(systemName: "\(shape).fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
//                    .foregroundStyle(stackItem.backgroundColor)
                    .frame(width: stackItem.width)
            } else if let image = stackItem.image {
                if let imageRen = UIImage(data: image) {
                    Image(uiImage: imageRen)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: stackItem.width)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            } else if let text = stackItem.text {
                Text(text)
                    .lineLimit(1)
                    .font(.custom(stackItem.textBold ? "RoundedMplus1c-Black" : "RoundedMplus1c-Regular", size: 500))
                    .minimumScaleFactor(0.01)
//                    .foregroundStyle(stackItem.textColor)
                    .padding(20)
                    .frame(width: stackItem.width)
//                    .background(stackItem.backgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                
            }
        }
        .overlay( /// apply a rounded border https://stackoverflow.com/questions/71744888/swiftui-view-with-rounded-corners-and-border
            RoundedRectangle(cornerRadius: 10)
                .stroke(.thinMaterial, lineWidth: stackItem == selectedItem ? 5 : 0)
        )
        .rotationEffect(Angle(degrees: stackItem.rotation))
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
            
            DragGesture()
                .onChanged({ value in
                    withAnimation(.linear(duration: 0.1)) {
                        stackItem.offset = CGSize(width: stackItem.lastOffset.width + value.translation.width, height: stackItem.lastOffset.height + value.translation.height)
                    }
                }).onEnded({ value in
                    stackItem.lastOffset = stackItem.offset
                })
        )
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
                        stackItem.rotation = stackItem.lastRotation + value.degrees
                    }).onEnded({ value in
                        stackItem.lastRotation = stackItem.rotation
                    })
                )
        )
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
    }
}
