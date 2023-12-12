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
    
    @State var selectedBGColor: Color = .black
    @State var selectedTextColor: Color = .white

    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            ZStack {
                
                Image(uiImage: canvasModel.backgroundImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
                    .onTapGesture(count: 1) {
                        canvasModel.selected = nil
                    }
                
                ForEach($canvasModel.canvasBaseModel.stack) { $stackItem in
                    ZStack {
                        ZStack {
                            if let viewItem = canvasModel.viewStack[stackItem.id] {
                                if let imageView = viewItem.imageView {
                                   imageView
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                }
                                else if let shapeView = viewItem.shapeView {
                                    shapeView
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundStyle(stackItem.backgroundColor)
                                }
                                else if let textView = viewItem.textView {
                                    textView
                                        .lineLimit(1)
                                        .font(.custom("RoundedMplus1c-Black", size: 50))
                                        .foregroundStyle(stackItem.textColor)
                                        .padding(20)
                                        .background(stackItem.backgroundColor)
                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                }
                            }
                        }
                        .overlay( /// apply a rounded border https://stackoverflow.com/questions/71744888/swiftui-view-with-rounded-corners-and-border
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.thinMaterial, lineWidth: stackItem == canvasModel.selected ? 5 : 0)
                        )
                        .rotationEffect(Angle(degrees: stackItem.rotation))
                        .scaleEffect(stackItem.hapticScale)
                        .scaleEffect(stackItem.scale)
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
                                selectedBGColor = stackItem.backgroundColor
                                selectedTextColor = stackItem.textColor
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
                                })
                                .onEnded({ value in
                                    stackItem.lastScale = stackItem.scale
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
                        if(canvasModel.selected == stackItem) {
                            HStack {
                                if(canvasModel.selected?.type != "img") {
                                    ColorPicker("BG Color Picker", selection: $selectedBGColor)
                                        .labelsHidden()
                                        .padding(5)
                                        .onChange(of: selectedBGColor) {
                                            if let rgbColor = selectedBGColor.cgColor {
                                                if let rgbValues = rgbColor.components {
                                                    stackItem.bgR = rgbValues[0]
                                                    stackItem.bgG = rgbValues[1]
                                                    stackItem.bgB = rgbValues[2]
                                                    stackItem.bgA = rgbValues[3]
                                                }
                                            }
                                            canvasModel.updateItem(item: stackItem)
                                        }
                                }
                                    
                                if(canvasModel.selected?.type == "text") {
                                    ColorPicker("Text Color Picker", selection: $selectedTextColor)
                                    .labelsHidden()
                                    .padding(5)
                                    .onChange(of: selectedTextColor) {
                                        if let rgbColor = selectedTextColor.cgColor {
                                            if let rgbValues = rgbColor.components {
                                                stackItem.txtR = rgbValues[0]
                                                stackItem.txtG = rgbValues[1]
                                                stackItem.txtB = rgbValues[2]
                                                stackItem.txtA = rgbValues[3]
                                            }
                                        }
                                        canvasModel.updateItem(item: stackItem)
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
                            .offset(stackItem.offset)
                        }
                    }
                }
            }
            .frame(width: size.width, height: size.height)
        }
        .frame(maxHeight: height)
        .clipped()
    }
}

//#Preview {
//    Home()
//}
