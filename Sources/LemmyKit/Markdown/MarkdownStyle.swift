//
//  SwiftUIView.swift
//  
//
//  Created by 王楚江 on 2022/3/11.
//

import SwiftUI

public struct MarkdownStyle: Hashable {
    public enum Size: Int {
        case normal = 16 //mac
        case el1 = 20 //mac larger
        case el2 = 48 //iphone med
        case el3 = 52 //iphone larger
    }
    
    
    public var padding: Int?
    public var paddingTop: Int?
    public var paddingRight: Int?
    public var paddingLeft: Int?
    public var paddingBottom: Int?
    public var size: Size
    public init(padding: Int = 18, size: Size = .normal) {
        self.padding = padding
        self.size = size
    }
    public init(paddingTop: Int = 18, paddingBottom: Int = 18, paddingLeft: Int = 18, paddingRight: Int = 18, size: Size = .normal) {
        self.paddingTop = paddingTop
        self.paddingBottom = paddingBottom
        self.paddingLeft = paddingLeft
        self.paddingRight = paddingRight
        self.size = size
    }
    public init(padding: Int = 18, paddingTop: Int = 18, paddingBottom: Int = 18, paddingLeft: Int = 18, paddingRight: Int = 18, size: Size = .normal) {
        self.padding = padding
        self.paddingTop = paddingTop
        self.paddingBottom = paddingBottom
        self.paddingLeft = paddingLeft
        self.paddingRight = paddingRight
        self.size = size
    }
}
