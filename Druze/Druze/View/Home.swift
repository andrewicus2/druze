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
                        canvasModel.addShapeToStack()
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
            SheetView(canvasModel: canvasModel)
        }
        
    }
}

#Preview {
    Home()
}

struct SheetView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var canvasModel: CanvasViewModel
    @State var text = "Lorem Ipsum"
    
    var body: some View {
        VStack {
            TextField("Text Field", text: $text)
                .padding()
                .background(.thinMaterial)
            Button("Save") {
                canvasModel.addTextToStack(text: text)
                dismiss()
            }
            Button("Cancel") {
                dismiss()
            }
        }
        .padding()
    }
}
