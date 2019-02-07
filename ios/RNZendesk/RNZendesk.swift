//
//  RNZendesk.swift
//  RNZendesk
//
//  Created by David Chavez on 24.04.18.
//  Copyright © 2018 David Chavez. All rights reserved.
//

import UIKit
import Foundation
import ZendeskSDK
import ZendeskCoreSDK

@objc(RNZendesk)
class RNZendesk: RCTEventEmitter {

    override open static func requiresMainQueueSetup() -> Bool {
        return false;
    }

    @objc(constantsToExport)
    override func constantsToExport() -> [AnyHashable: Any] {
        return [:]
    }

    @objc(supportedEvents)
    override func supportedEvents() -> [String] {
        return []
    }


    // MARK: - Public API

    @objc(initialize:)
    func initialize(config: [String: Any]) {
        guard
            let appId = config["appId"] as? String,
            let clientId = config["clientId"] as? String,
            let zendeskUrl = config["zendeskUrl"] as? String else { return }

        Zendesk.initialize(appId: appId, clientId: clientId, zendeskUrl: zendeskUrl)
        Support.initialize(withZendesk: Zendesk.instance)
        let identity = Identity.createAnonymous()
        Zendesk.instance?.setIdentity(identity)
    }

    @objc(identifyJWT:)
    func identifyJWT(token: String?) {
        guard let token = token else { return }
        let identity = Identity.createJwt(token: token)
        Zendesk.instance?.setIdentity(identity)
    }

    @objc(identifyAnonymous)
    func identifyAnonymous() {
        let identity = Identity.createAnonymous()

        Zendesk.instance?.setIdentity(identity)
    }

    @objc(showHelpCenter:)
    func showHelpCenter(with options: [String: Any]) {

        DispatchQueue.main.async {
            let Device_Brand = options["Device_Brand"] as? String;
            let Device_Model = options["Device_Model"] as? String;
            let OS = options["OS"] as? String;
            let OS_Version = options["OS_Version"] as? String;
            let App_Version = options["App_Version"] as? String;
            let Connection = options["Connection"] as? String;
            let Phone_or_Tablet = options["Phone_or_Tablet"] as? String;


            let c2 = ZDKCustomField(fieldId: NSNumber(value: 360016501732), andValue: Device_Brand!)
            let c3 = ZDKCustomField(fieldId: NSNumber(value: 360016554711), andValue: Device_Model!)
            let c4 = ZDKCustomField(fieldId: NSNumber(value: 360016554731), andValue: OS!)
            let c5 = ZDKCustomField(fieldId: NSNumber(value: 360016554911), andValue: OS_Version!)
            let c6 = ZDKCustomField(fieldId: NSNumber(value: 360016554751), andValue: App_Version!)
            let c7 = ZDKCustomField(fieldId: NSNumber(value: 360016502792), andValue: Connection!)
            let c8 = ZDKCustomField(fieldId: NSNumber(value: 360016556691), andValue: Phone_or_Tablet!)

            /*
            config.subject = "iOS Ticket"
            config.tags = ["ios", "mobile"]
            */
            let config = RequestUiConfiguration()
            config.fields = [c2,c3,c4,c5,c6,c7,c8] as! [ZDKCustomField]
            let helpCenter = HelpCenterUi.buildHelpCenterOverviewUi(withConfigs: [config])


            let nvc = UINavigationController(rootViewController: helpCenter)
            UIApplication.shared.keyWindow?.rootViewController?.present(nvc, animated: true, completion: nil)
        }
    }

    @objc(showNewTicket:)
    func showNewTicket(with options: [String: Any]) {
        DispatchQueue.main.async {
            let config = RequestUiConfiguration()
            if let tags = options["tags"] as? [String] {
                config.tags = tags
            }
            let requestScreen = RequestUi.buildRequestUi(with: [config])

            let nvc = UINavigationController(rootViewController: requestScreen)
            UIApplication.shared.keyWindow?.rootViewController?.present(nvc, animated: true, completion: nil)
        }
    }
}
