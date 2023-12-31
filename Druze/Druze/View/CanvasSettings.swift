//
//  CanvasSettings.swift
//  Druze
//
//  Created by drew on 12/3/23.
//

import SwiftUI
import PhotosUI

struct CanvasSettings: View {
    @State private var resetConfirmation: Bool = false
    @Environment(\.dismiss) var dismiss
    @StateObject var canvasModel: CanvasViewModel
    @State var canvasName: String = "Canvas Name"
    @State private var bgPhoto: PhotosPickerItem?
    @Binding var lines: [Line]

    var body: some View {
        VStack {
            Text("Settings")
                .font(.custom("RoundedMplus1c-Black", size: 30))
                .padding(20)
            
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 5) {
                        Text("Name")
                            .font(.custom("RoundedMplus1c-Black", size: 20))
                            .opacity(0.5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(canvasName)
                            .font(.custom("RoundedMplus1c-Black", size: 30))
                            .padding(20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.thinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
//                        TextField("Title", text: $canvasName)
//                            .font(.custom("RoundedMplus1c-Black", size: 30))
//                            .padding(20)
//                            .background(.thinMaterial)
//                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    
                    VStack(spacing: 5) {
                        Text("Background")
                            .font(.custom("RoundedMplus1c-Black", size: 20))
                            .opacity(0.5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ZStack {
                            Image(uiImage: canvasModel.backgroundImage)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: 300)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            PhotosPicker(selection: $bgPhoto, matching: .images) {
                                Text("Change")
                                    .padding()
                            }
                            .font(.custom("RoundedMplus1c-Black", size: 30))
                            .foregroundStyle(.white)
                            .background(.thinMaterial)
                            .environment(\.colorScheme, .dark)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        .frame(maxWidth: .infinity)
                        .font(.custom("RoundedMplus1c-Black", size: 20))
                        .padding(20)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    
                    VStack(spacing: 5) {
                        Text("Reset Canvas")
                            .font(.custom("RoundedMplus1c-Black", size: 20))
                            .opacity(0.5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Button() {
                            resetConfirmation.toggle()
                        } label: {
                            Text("Reset")
                                .padding()
                                .frame(maxWidth: .infinity)
                        }
                        .font(.custom("RoundedMplus1c-Black", size: 30))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .background(.red)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
            }
            
            
            Spacer()
            
            
            Button() {
                dismiss()
            } label: {
                Text("Done")
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .font(.custom("RoundedMplus1c-Black", size: 30))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .background(.green)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .padding()
        .onAppear() {
            canvasName = canvasModel.canvasBaseModel.canvasName
        }
        .onChange(of: canvasName) {
            canvasModel.canvasBaseModel.canvasName = canvasName
        }
        .onChange(of: bgPhoto) {
            Task {
                if let data = try? await bgPhoto?.loadTransferable(type: Data.self) {
                    if let image = UIImage(data: data) {
                        if let compData = image.jpegData(compressionQuality: 0.1) {
                            canvasModel.changeBGImage(image: image, data: compData)
                        }
                    }
                    return
                }
                print("Failed")
                
                print("Failed")
            }
        }
        .alert("Are you sure you want to reset your canvas?", isPresented: $resetConfirmation) {
            Button("Reset", role: .destructive) {
                lines.removeAll()
//                canvasModel.resetCanvas()
                dismiss()
            }
            Button("Cancel", role: .cancel) {
            }
        }
    }
}

#Preview {
    Home(canvasModel: CanvasViewModel(inFileName: "testing", inCanvasName: "testing.json"))
}
