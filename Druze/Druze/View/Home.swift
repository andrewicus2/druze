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
    @State private var addingText: Bool = false
    @State private var addingShape: Bool = false
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            // Canvas display
            Canvas()
                .environmentObject(canvasModel)
                .ignoresSafeArea()
            
            // Toolbar            
            HStack {
                HStack(spacing: 24) {
                    Button {
                        canvasModel.showImagePicker.toggle()
                    } label: {
                        Image(systemName: "photo")
                            .font(.system(size: 40))
                    }
                    Button {
                        addingText.toggle()
                    } label: {
                        Image(systemName: "character.textbox")
                            .font(.system(size: 40))
                    }

                    Button {
                        addingShape.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 40))
                    }
                }
            }
            .padding(24)
            .foregroundStyle(.black)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
            .padding(20)
        }
        .alert(canvasModel.errorMessage, isPresented: $canvasModel.showError) {}
        .sheet(isPresented: $canvasModel.showImagePicker) {
            if let image = UIImage(data: canvasModel.imageData) {
                canvasModel.addImageToStack(image: image)
            }
        } content: {
            ImagePicker(showPicker: $canvasModel.showImagePicker, imageData: $canvasModel.imageData)
        }
        .sheet(isPresented: $addingText) {
            TextCreation(canvasModel: canvasModel)
        }.sheet(isPresented: $addingShape) {
            ShapeCreation(canvasModel: canvasModel)
        }
        
    }
}

#Preview {
    Home()
}

struct TextCreation: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var canvasModel: CanvasViewModel
    @State var text = ""
    
    
    
    var body: some View {
        VStack {
            Spacer()
            TextField("Say something fun!", text: $text)
                .font(.system(size: 30))
                .padding(20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            Spacer()
            Button("Cancel") {
                dismiss()
            }
            .font(.system(size: 30, weight: .bold))
            .foregroundStyle(.gray)
            .padding()
            .frame(maxWidth: .infinity)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            Button("Save") {
                canvasModel.addTextToStack(text: text)
                dismiss()
            }
            .font(.system(size: 30, weight: .bold))
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(.green)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
        }
        .padding()
    }
}

struct ShapeCreation: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var canvasModel: CanvasViewModel
    @State var text = ""
    
    let shapeTypes: [String] = ["square", "circle", "triangle", "star", "hexagon", "octagon", "seal", "shield"]
    
    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]

    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(shapeTypes, id: \.self) { shape in
                        Button {
                            canvasModel.addShapeToStack(type: shape)
                            dismiss()
                        } label: {
                            Image(systemName: "\(shape).fill")
                                .resizable()
                                .frame(maxWidth: .infinity)
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(.black)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
        }
        .padding()
    }
}

