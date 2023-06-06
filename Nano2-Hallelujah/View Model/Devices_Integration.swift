//
//  Devices_Integration.swift
//  Nano2-Hallelujah
//
//  Created by Gabriella Christina Kandinata on 19/05/23.
//

import Foundation
import UIKit
import WatchConnectivity

class Devices_Integration: NSObject, WCSessionDelegate {
    private let session: WCSession

    @Published var wakeUpTime: Date = Date()

    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self

        #if os(iOS)
            print("Connection provider initialized on phone")
        #endif

        #if os(watchOS)
            print("Connection provider initialized on watch")
        #endif

        self.connect()
    }


    func connect() {
        guard WCSession.isSupported() else {
            print("WCSession is not supported")
            return
        }

        session.activate()
        print("activated")
    }

    func send(message: [String : Any]) -> Void {
        session.sendMessage(message, replyHandler: nil) { error in
            print(error.localizedDescription)
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //
    }

    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        //
    }

    func sessionDidDeactivate(_ session: WCSession) {
        //
    }
    #endif


}
