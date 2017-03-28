//
//  AppDelegate.swift
//  kb LED Menu
//
//  Created by Rodrigo Tavares on 26/03/17.
//  Copyright © 2017 Rodrigo Tavares. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system().statusItem(withLength: -2)
    let serviceProvider = ServiceProvider()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        toggleLed(1)
        serviceProvider.ledsOn = true
        
        NSApplication.shared().servicesProvider = serviceProvider
        
        NSUpdateDynamicServices()
        
        if let button = statusItem.button {
            setButtonAppearance(button: button, closeMode: false)
        }

        NSEvent.addGlobalMonitorForEvents(matching: NSEventMask.flagsChanged) { (theEvent) -> Void in
            if (theEvent.modifierFlags.contains(NSEventModifierFlags.option)) {
                if let button = self.statusItem.button {
                    self.setButtonAppearance(button: button, closeMode: true)
                }
            } else {
                if let button = self.statusItem.button {
                    self.setButtonAppearance(button: button, closeMode: false)
                }
            }
        }
        
    }
    
    func setButtonAppearance(button: NSStatusBarButton, closeMode: Bool) {
        if !closeMode {
            button.image = NSImage(named: (serviceProvider.ledsOn) ? "statusIconToggleOn" : "statusIconToggleOff")
            button.toolTip = "Toggle Scroll Lock"
            button.action = #selector(statusButtonClick);
        } else {
            button.image = NSImage(named: (serviceProvider.ledsOn) ? "statusIconQuitOn" : "statusIconQuitOff")
            button.toolTip = "Close app"
            button.action = #selector(self.exitApp);
        }
    }
    
    func statusButtonClick(sender: AnyObject) {
        serviceProvider.toggleScrLk()
        if let button = self.statusItem.button {
            self.setButtonAppearance(button: button, closeMode: false)
        }
    }

    func exitApp(sender: AnyObject) {
        NSApplication.shared().terminate(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    class ServiceProvider: NSObject {
        var ledsOn:Bool = false
        
        @objc func toggleScrLock(_ pasteboard: NSPasteboard, userData: String?, error: AutoreleasingUnsafeMutablePointer<NSString>) {
            toggleScrLk()
        }
        
        func toggleScrLk() {
            ledsOn = !ledsOn
            toggleLed((ledsOn) ? 1 : 0)
        }
    }

}

