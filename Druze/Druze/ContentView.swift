//
//  ContentView.swift
//  Dragging Text
//
//  Created by drew on 11/24/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var canvasCollectionModel: CanvasCollectionViewModel = CanvasCollectionViewModel()
    @State private var deleteConfirmation: Bool = false
    @State private var addingCanvas: Bool = false
    
    @State private var canvasStack: [String] = []
    
    @State var canvasName: String = "My Canvas"
    
    var body: some View {
        NavigationStack {
            VStack {
                Button() {
//                    addingCanvas.toggle()
                    canvasStack.append("\(UUID().uuidString).json")
                } label: {
                    VStack {
                        Image(systemName: "plus")
                        Text("create new canvas")
                    }
                }
            } 
            NavigationLink("Canvas") {
                Home(canvasModel: CanvasViewModel(inFileName: "cnvas-json-testing.json"))
            }
            ForEach(canvasStack, id: \.self) { canvasID in
                NavigationLink(canvasID) {
                    Home(canvasModel: CanvasViewModel(inFileName: canvasID))
                }
            }
        }
        .sheet(isPresented: $addingCanvas) {
            CanvasCreation(canvasCollectionModel: canvasCollectionModel)
        }
    }
}

#Preview {
    ContentView()
}

struct CanvasCreation: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var canvasCollectionModel: CanvasCollectionViewModel
    @State var text = ""
    
    var body: some View {
        VStack {
            Text("Add Some Text")
                .font(.custom("RoundedMplus1c-Black", size: 30))
                .padding(20)
            
            Spacer()
            
            TextField("Say something fun!", text: $text)
                .font(.custom("RoundedMplus1c-Black", size: 30))
                .padding(20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Spacer()
            
            Button() {
                dismiss()
            } label: {
                Text("Cancel")
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .font(.custom("RoundedMplus1c-Black", size: 30))
            .foregroundStyle(.gray)
            .frame(maxWidth: .infinity)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            
            Button() {
//                canvasCollectionModel.addCanvas(canvas: CanvasBaseModel(JSONfileName: "\(text).json", inName: text))
                
                dismiss()
            } label: {
                Text("Save")
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .font(.custom("RoundedMplus1c-Black", size: 30))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .background(.green)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .disabled(text.isEmpty ? true : false)
            .opacity(text.isEmpty ? 0.5 : 1)
        }
        .padding()
    }
}
