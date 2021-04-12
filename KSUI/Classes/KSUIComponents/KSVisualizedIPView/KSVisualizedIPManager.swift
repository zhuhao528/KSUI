//
//  KSVisualizedIPManager.swift
//  ARDemo
//
//  Created by Levi Han on 2020/9/29.
//

import Foundation

class KSVisualizedIPManager: NSObject {
   
    static let shared: KSVisualizedIPManager = KSVisualizedIPManager()
    
    private var map: [String:KSVisualizedIPView] = [String:KSVisualizedIPView]()
    
    func register(_ v: KSVisualizedIPView, forKey key: String) {
        map[key] = v
    }
    
    func ipViewForKey(_ key: String) -> KSVisualizedIPView? {
        return map[key]
    }
    
}
