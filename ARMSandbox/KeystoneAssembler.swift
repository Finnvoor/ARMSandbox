//
//  KeystoneAssembler.swift
//  ARMSandbox
//
//  Created by Finn Voorhees on 03/03/2021.
//

#if os(iOS)
import UIKit
#else
import Cocoa
#endif
import JavaScriptCore

public class KeystoneAssembler: NSObject {
    public static let arm = KeystoneAssembler()
    
    private let jsContext: JSContext
    private let keystone: JSValue
    
    private init(architecture: Architecture = .arm, mode: Mode = .arm) {
        self.jsContext = JSContext()
        let window = JSValue(newObjectIn: self.jsContext)
        self.jsContext.setObject(window, forKeyedSubscript: "window" as NSString)

        if let keystoneURL = Bundle(for: KeystoneAssembler.self).url(forResource: "keystone.min", withExtension: "js"),
           let keystoneSource = try? String(contentsOf: keystoneURL) {
            self.jsContext.evaluateScript(keystoneSource)
        }
        
        self.jsContext.evaluateScript("var keystone = new ks.Keystone(ks.\(architecture.rawValue), ks.\(mode.rawValue))")
        self.keystone = self.jsContext.objectForKeyedSubscript("keystone")
        
        super.init()
    }
    
    public func assemble(source: String) throws -> [UInt8]? {
        let assembledBytes = self.keystone.invokeMethod("asm", withArguments: [source])?.toArray() as? [UInt8]
        if let exception = self.jsContext.exception {
            throw NSError(domain: exception.toString()?.split(separator: "\n").last?.split(separator: "(").first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Unknown Error", code: 0, userInfo: [:])
        } else {
            return assembledBytes
        }
    }
}

public extension KeystoneAssembler {
    enum Architecture: String {
        case arm = "ARCH_ARM"
        case arm64 = "ARCH_ARM64"
    }
    
    enum Mode: String {
        case arm = "MODE_ARM"
        case thumb = "MODE_THUMB"
    }
}
