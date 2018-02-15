//
//  P2PServiceHandler.swift
//  CardGame
//
//  Created by Muhammad Afroz on 1/23/17.
//  Copyright © 2017 Muhammad Afroz. All rights reserved.
//

import UIKit
import MultipeerConnectivity


@objc public protocol P2PServiceHandlerDelegate: class {
    
    func didConnectedTo(_ serviceHandler:P2PServiceHandler,to peer:MCPeerID)
    func didFailToConnect(_ serviceHandler:P2PServiceHandler, with peer: MCPeerID)
    func connecting(_ serviceHandler:P2PServiceHandler,to peer:MCPeerID)
    func didRecieve(_ serviceHandler:P2PServiceHandler, data:[String: Any])
    @objc optional func didCancelBrowserViewController(_ serviceHandler:P2PServiceHandler, browser: MCBrowserViewController)
    @objc optional func didFinshedPickingBrowserViewController(_ serviceHandler:P2PServiceHandler, browser: MCBrowserViewController)
    
    @objc optional func serviceHandler(_ serviceHandler:P2PServiceHandler, _ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID)
    
    @objc optional func serviceHandler(_ serviceHandler:P2PServiceHandler, _ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress)
   
    @objc optional func serviceHandler(_ serviceHandler:P2PServiceHandler, _ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?)
    
}

open class P2PServiceHandler: NSObject {
    
    
    public static let sharedInstance :P2PServiceHandler = {
        let instance = P2PServiceHandler()
        return instance
        }()
    
    var peerID : MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    var serviceName = "AZP2P"
    
    public weak var delegate: P2PServiceHandlerDelegate?
    
    //MARK: - Setup Connection Session
    
    public func setupConnection(serviceName: String) {
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
        self.serviceName = serviceName
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: serviceName, discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
        
    }
    public func joinSession(vc: UIViewController, mcBrowser: MCBrowserViewController?) {
        if mcBrowser == nil {
            let browser = MCBrowserViewController(serviceType: serviceName , session: mcSession)
            browser.delegate = self
            vc.present(browser, animated: true)
        }
        else {
            mcBrowser?.delegate = self
            vc.present(mcBrowser!, animated: true)
        }
    }
    
    public func disconnectSession() {
        mcSession.disconnect()
    }
    
    //MARK: - SendData to other Peer
    public func sendData(data: [String: Any]) {
        
        if mcSession.connectedPeers.count>0 {
            do {
                //let dic :[String: [Any]] = [key:array]
                
                let message : Data = NSKeyedArchiver.archivedData(withRootObject: data) as Data
                
                try mcSession.send(message as Data, toPeers: mcSession.connectedPeers, with: .reliable);
            } catch  {
                
            }
        }
    }
}

//MARK: - Connection Service Manager Delegate

extension P2PServiceHandler: MCSessionDelegate {
    
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        self.delegate?.serviceHandler?(self, session, didReceive: stream, withName: streamName, fromPeer: peerID)
    }
    
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        self.delegate?.serviceHandler?(self, session, didStartReceivingResourceWithName: resourceName, fromPeer: peerID, with: progress)
    }
    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        self.delegate?.serviceHandler?(self, session, didFinishReceivingResourceWithName: resourceName, fromPeer: peerID, at: localURL, withError: error)
    }
    
    public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            self.delegate?.didConnectedTo(self, to: peerID)

        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            self.delegate?.connecting(self, to: peerID)
        case MCSessionState.notConnected:
            session.disconnect()
            self.delegate?.didFailToConnect(self, with: peerID)
            print("Not Connected: \(peerID.displayName)")
        }
    }
    public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let dic = NSKeyedUnarchiver.unarchiveObject(with: data) as! [String:Any]
        self.delegate?.didRecieve(self, data: dic)
    }
    
}
extension P2PServiceHandler: MCBrowserViewControllerDelegate {
    
    public func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
        self.delegate?.didFinshedPickingBrowserViewController?(self, browser: browserViewController)
    }
    public func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
        self.delegate?.didCancelBrowserViewController?(self, browser: browserViewController)
    }
}
extension P2PServiceHandler: MCNearbyServiceBrowserDelegate {
    public func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        self.mcAdvertiserAssistant.stop()

    }
    
    public func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        self.mcAdvertiserAssistant.start()
        
    }
}
