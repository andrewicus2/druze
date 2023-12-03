//
//  Home.swift
//  Dragging Text
//
//  Created by drew on 11/24/23.
//

//  src: https://www.youtube.com/watch?v=zvdHmnp8sLA

import SwiftUI
import _PhotosUI_SwiftUI

struct Line {
    var points: [CGPoint]
    var color: Color
}

struct Home: View {
    @StateObject var canvasModel: CanvasViewModel = .init()
    @State private var deleteConfirmation: Bool = false
    @State private var addingText: Bool = false
    @State private var addingShape: Bool = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var drawingMode: Bool = false
    
    @State private var lines: [Line] = []
    @State private var selectedColor = Color.orange
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            // Canvas display
            CustCanvas()
                .environmentObject(canvasModel)
                .ignoresSafeArea()
            
          
                Canvas {ctx, size in
                    for line in lines {
                        var path = Path()
                        path.addLines(line.points)
                        
                        ctx.stroke(path, with: .color(line.color), style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                    }
                }
                .gesture(
                    drawingMode ?
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged({ value in
                            let position = value.location
                            
                            if value.translation == .zero {
                                lines.append(Line(points: [position], color: selectedColor))
                            } else {
                                guard let lastIdx = lines.indices.last else {
                                    return
                                }
                                
                                lines[lastIdx].points.append(position)
                            }
                        })
                    : nil
                )
                .allowsHitTesting(drawingMode)
        
            
            // Toolbar            
            if(drawingMode) {
                HStack(spacing: 24) {
                    Button {
                        drawingMode.toggle()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 40))
                    }
                    
                    ColorPicker("Pen Color Picker", selection: $selectedColor)
                        .labelsHidden()
                        
                }
                .padding(24)
                .foregroundStyle(.black)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .frame(maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea()
                .padding(20)
            } else {
                HStack(spacing: 24) {
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
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
                    Button {
                        drawingMode.toggle()
                    } label: {
                        Image(systemName: "pencil.tip")
                            .font(.system(size: 40))
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
        }
        .alert(canvasModel.errorMessage, isPresented: $canvasModel.showError) {}
        .sheet(isPresented: $addingText) {
            TextCreation(canvasModel: canvasModel)
        }.sheet(isPresented: $addingShape) {
            ShapeCreation(canvasModel: canvasModel)
        }
        .onChange(of: selectedPhoto) {
            Task {
                if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        canvasModel.addImageToStack(image: uiImage)
                        return
                    }
                }

                print("Failed")
            }
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
