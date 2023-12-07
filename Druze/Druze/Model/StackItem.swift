//
//  StackItem.swift
//  Dragging Text
//
//  Created by drew on 11/24/23.
//

import SwiftUI


// Holds each Stack Item View

// Does not conform to Codable??

struct StackItem: Identifiable, Equatable, Codable, View {
    var id = UUID().uuidString
//    var view: AnyView
    var type: String
    

    var image: Data?
    var shape: String?
    var text: String?
    
    
    
    var body: some View {
        ZStack {
            if let contentI = image {
                if let uiImage = UIImage(data: contentI) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    //                        .foregroundStyle(stackItem.backgroundColor)
                    //                        .frame(width: stackItem.width)
                } 
//                            } else if let contentI = stackItem.image {
//                                contentI
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .frame(width: stackItem.width)
//                                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                            } else if let contentT = stackItem.text {
//                                contentT
//                                    .lineLimit(1)
//                                    .font(.custom(stackItem.textBold ? "RoundedMplus1c-Black" : "RoundedMplus1c-Regular", size: 500))
//                                    .minimumScaleFactor(0.01)
//                                    .foregroundStyle(stackItem.textColor)
//                                    .padding(20)
//                                    .frame(width: stackItem.width)
//                                    .background(stackItem.backgroundColor)
//                                    .clipShape(RoundedRectangle(cornerRadius: 25))
//                
//                            }
            } 
//            else if let contentT = text {
//                Text(text)
//                    .lineLimit(1)
//                    .font(.custom(stackItem.textBold ? "RoundedMplus1c-Black" : "RoundedMplus1c-Regular", size: 500))
//
//            }
            
        }
    }
    
    // Equatable - Drew
    static func ==(st1: StackItem, st2: StackItem) -> Bool {
        return st1.id == st2.id
    }
    
    // Gesture Properties
    
    var offset: CGSize = .zero // extension to make it codable
    var lastOffset: CGSize = .zero
    var scale: Double = 1
    var lastScale: Double = 1
    var rotation: Double = 0
    var lastRotation: Double = 0
        
    var width: Double = 200
    var lastWidth: Double = 200
    
    var height: Double = 200
    var lastHeight: Double = 200
    
    var textBody: String = "Lorem Ipsum"
    
    var backgroundColor: String = "black"
    var textColor: String = "white"
    var textBold: Bool = true
    
    var hapticScale: Double = 1

}
