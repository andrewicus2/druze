//
//  ModelJSON.swift
//  Created by jht2 on 1/15/22.
//

import SwiftUI

extension CanvasBaseModel {
    func saveAsJSON(fileName: String) {
        do {
            try saveJSON(fileName: fileName, val: self);
        }
        catch {
            fatalError("Canvas saveAsJSON error \(error)")
        }
    }
    
    init(JSONfileName fileName: String, inCanvasName:String) {
        stack = []
        canvasName = inCanvasName
        do {
            self = try loadJSON(CanvasBaseModel.self, fileName: fileName)
        } catch {
            // fatalError("Model init error \(error)")
            print("Canvas init JSONfileName error \(error)")
        }
    }
}

extension CanvasCollection {
    func saveAsJSON(fileName: String) {
        do {
            try saveJSON(fileName: fileName, val: self);
        }
        catch {
            fatalError("Collection saveAsJSON error \(error)")
        }
    }
    
    init(JSONfileName fileName: String) {
        collection = []
        do {
            self = try loadJSON(CanvasCollection.self, fileName: fileName)
        } catch {
            // fatalError("Model init error \(error)")
            print("Model init JSONfileName error \(error)")
        }
    }
}
