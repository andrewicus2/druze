//
//  ContentView.swift
//  Dragging Text
//
//  Created by drew on 11/24/23.
//


///**TODO:**
///  - Store CanvasCollection in json
///  - Tie inputted canvas name to displayed and editable canvas name
///  - Front end for home screen

import SwiftUI

struct ContentView: View {
    @State private var deleteConfirmation: Bool = false
    @State private var addingCanvas: Bool = false
    @State private var showingInfo: Bool = false
        
    @StateObject var canvasCollection: CanvasCollectionModel = CanvasCollectionModel()
    
    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Image("angled-blooom-tile")
                    .resizable(resizingMode: .tile)
                    .opacity(0.05)
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Button {
                            showingInfo.toggle()
                        } label: {
                            Image("bloom-icon")
                                .resizable()
                                .frame(width: 45, height: 45)
                            Text("Druze")
                                .font(.custom("RoundedMplus1c-Black", size: 30))
                        }
                        

                        Spacer()

                        Button {
                            addingCanvas.toggle()
                        } label: {
                            Image(systemName: "plus")
                            .font(.system(size: 26, weight: .bold))
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                    }
                    .foregroundStyle(.black)
                    .padding(.init(top: 10, leading: 20, bottom: 20, trailing: 20))
                    .background(
                        Color.white.ignoresSafeArea(edges: .top)
                    )
                    
                    
                    if(canvasCollection.canvasCollection.collection.isEmpty) {
                        Spacer()
                        VStack{
                            Image(systemName: "hand.point.up")
                                .font(.system(size: 35, weight: .bold))
                                .rotationEffect(Angle(degrees: 37))
                                .padding()
                            HStack {
                                Text("Tap")
                                    .font(.custom("RoundedMplus1c-Black", size: 30))
                                Image(systemName: "plus")
                                    .font(.system(size: 30, weight: .bold))
                            }
                            Text("to create your first bloom!")
                                .font(.custom("RoundedMplus1c-Black", size: 30))
                                .multilineTextAlignment(.center)
                        }
                        .padding(20)
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 10) {
                                ForEach(canvasCollection.canvasCollection.collection, id: \.self) { canvasInfo in
                                    NavigationLink(destination: Home(canvasModel: CanvasViewModel(inFileName: canvasInfo.id, inCanvasName: canvasInfo.name)) ) {
                                        ButtonView(name: canvasInfo.name)
                                            .frame(maxWidth: .infinity)
                                    }
                                }
                            }
                            .padding(.init(top: 0, leading: 20, bottom: 0, trailing: 20))
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $addingCanvas) {
            CanvasCreation(canvasCollection: canvasCollection)
        }
        .sheet(isPresented: $showingInfo) {
            AppInfo()
        }
    }
}

#Preview {
    ContentView()
}

struct ButtonView: View {
    var name: String
    
    var body: some View {
        ZStack {
            Image("druze-default")
                .resizable()
                .frame(maxWidth: .infinity)
                .aspectRatio(contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            VStack {
                Text(name)
            }
            .padding(10)
        }
            .foregroundColor(Color.black)
            .font(.custom("RoundedMplus1c-Black", size: 20))
            .padding(10)
            .frame(maxWidth: .infinity, maxHeight: 300)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct CanvasCreation: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var canvasCollection: CanvasCollectionModel
    @State var text = ""
    
    var body: some View {
        VStack {
            Text("Give your Bloom a Name!")
                .font(.custom("RoundedMplus1c-Black", size: 30))
                .multilineTextAlignment(.center)
                .padding(20)
            
            Spacer()
            
            TextField("My first Bloom!", text: $text)
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
                canvasCollection.addCanvas(canvasID: "\(UUID().uuidString).json", canvasName: text)
                dismiss()
            } label: {
                Text("Save")
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .font(.custom("RoundedMplus1c-Black", size: 30))
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .background(Color("druze-green"))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .disabled(text.isEmpty ? true : false)
            .opacity(text.isEmpty ? 0.5 : 1)
        }
        .padding()
    }
}

struct AppInfo: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Image("bloom-icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150)
                .padding()
            
            Text("Druze 1.0")
                .font(.custom("RoundedMplus1c-Black", size: 30))
                .multilineTextAlignment(.center)
                .padding(20)
            
            Text("Drew Brown")
                .font(.custom("RoundedMplus1c-Black", size: 30))
                .multilineTextAlignment(.center)
                .padding(20)
            
            Text("12.13.23")
                .font(.custom("RoundedMplus1c-Black", size: 30))
                .multilineTextAlignment(.center)
                .padding(20)
                .opacity(0.5)
            
            Spacer()
            
            Button() {
                dismiss()
            } label: {
                Text("Cool")
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .font(.custom("RoundedMplus1c-Black", size: 30))
            .foregroundStyle(.gray)
            .frame(maxWidth: .infinity)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .padding()
    }
}

