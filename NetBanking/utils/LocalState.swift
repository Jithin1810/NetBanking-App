//
//  LocalState.swift
//  NetBanking
//
//  Created by JiTHiN on 11/11/24.
//

import Foundation

public class LocalState {
    private enum Key: String {
        case hasOnboarded
    }
    public static var hasOnboarded: Bool {
        get { UserDefaults.standard.bool(forKey: Key.hasOnboarded.rawValue) }
        set(newValue) { UserDefaults.standard.set(newValue, forKey: Key.hasOnboarded.rawValue)}
    }
}
