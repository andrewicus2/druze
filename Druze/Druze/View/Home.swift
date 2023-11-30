//
//  Home.swift
//  Dragging Text
//
//  Created by drew on 11/24/23.
//

//  src: https://www.youtube.com/watch?v=zvdHmnp8sLA

import SwiftUI

struct Home: View {
    @StateObject var canvasModel: CanvasViewModel = .init()
    @State private var deleteConfirmation: Bool = false
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            // Canvas display
            Canvas()
                .environmentObject(canvasModel)
                .onTapGesture(count: 1) {
                    canvasModel.selected?.selected = false
                    canvasModel.selected = nil
                }
                .ignoresSafeArea()
            
            // Selected Tools
            if let active = canvasModel.selected {
                HStack() {
                    Button {
                        deleteConfirmation = true
                    } label: {
                        Image(systemName: "trash")
                            .font(.title3)
                    }
                    
                    Button {
                        canvasModel.moveActiveToFront()
                    } label: {
                        Image(systemName: "square.2.layers.3d.top.filled")
                            .font(.title3)
                    }
                    
                    Button {
                        canvasModel.moveActiveToBack()
                    } label: {
                        Image(systemName: "square.2.layers.3d.bottom.filled")
                            .font(.title3)
                    }
                    if(active.type == "rect") {
                        Button {
                            canvasModel.changeActiveColor(color: .red)
                        } label: {
                            Image(systemName: "paintbrush.fill")
                                .font(.title3)
                        }
                    }
                }
                .foregroundStyle(.white)
                .padding()
                .background(.black)
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            
            // Toolbar            
            HStack {
                
                Spacer()

                HStack(spacing: 24) {
                    Button {
                        canvasModel.showImagePicker.toggle()
                    } label: {
                        Image(systemName: "photo")
                            .font(.title3)
                    }
                    Button {
                        canvasModel.addTextToStack()
                    } label: {
                        Image(systemName: "character.textbox")
                            .font(.title3)
                    }

                    Button {
                        canvasModel.addShapeToStack()
                    } label: {
                        Image(systemName: "plus")
                            .font(.title3)
                    }
                }
            }
            .foregroundStyle(.white)
            .padding()
            .background(.black)
            .frame(maxHeight: .infinity, alignment: .top)
            
            Button {
                
            } label: {
                Image(systemName: "arrow.right.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)

        }
        .preferredColorScheme(.dark)
        .alert(canvasModel.errorMessage, isPresented: $canvasModel.showError) {}
        .sheet(isPresented: $canvasModel.showImagePicker) {
            if let image = UIImage(data: canvasModel.imageData) {
                canvasModel.addImageToStack(image: image)
            }
        } content: {
            ImagePicker(showPicker: $canvasModel.showImagePicker, imageData: $canvasModel.imageData)
        }
        .alert("Are you sure you want to delete this?", isPresented: $deleteConfirmation) {
            Button("Delete", role: .destructive) { canvasModel.deleteActive() }
            Button("Cancel", role: .cancel) { }
        }
    }
}

#Preview {
    Home()
}
