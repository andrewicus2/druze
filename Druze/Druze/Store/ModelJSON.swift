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
            fatalError("Model saveAsJSON error \(error)")
        }
    }
    
    init(JSONfileName fileName: String) {
        stack = []
        do {
            self = try loadJSON(CanvasBaseModel.self, fileName: fileName)
        } catch {
            // fatalError("Model init error \(error)")
            print("Model init JSONfileName error \(error)")
        }
    }
}
