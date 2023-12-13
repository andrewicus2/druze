//
//  CanvasSaving.swift
//  Druze
//
//  Created by drew on 12/12/23.
//

import SwiftUI
import UIKit

public extension View {
    @MainActor
    func snapshot(scale: CGFloat? = nil) -> UIImage? {
        let renderer = ImageRenderer(content: self)
        renderer.scale = scale ?? UIScreen.main.scale
        return renderer.uiImage
    }
}
