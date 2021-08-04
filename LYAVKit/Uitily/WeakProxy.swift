//
//  File.swift
//  LYAVKit
//
//  Created by liuming on 2021/8/4.
//

import Foundation
public class WeakProxy<T> where T:AnyObject {
    public weak var weakObj:AnyObject?
    init(_ obj:T) {
        self.weakObj = obj

    }
    
    
}
