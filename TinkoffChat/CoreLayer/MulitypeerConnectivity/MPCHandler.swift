import Foundation
import MultipeerConnectivity

protocol Communicator {
    weak var delegate: CommunicationDelegate? { get set }
    var online: Bool {get set}
    
    func sendMessage(string: String, to peer: MCPeerID, completionHandler:((_ success: Bool, _ error: Error?) -> ()))
}

class MPCHandler: NSObject, Communicator, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate  {
   
    let peerID: MCPeerID = MCPeerID(displayName: UIDevice.current.name)
    var sessions = [String: MCSession]()
    
    var advertiser : MCNearbyServiceAdvertiser!
    var browser: MCNearbyServiceBrowser!
    var online: Bool
    
    weak var delegate: CommunicationDelegate?
    
    init(delegate: CommunicationDelegate) {
        let name = "Test Name"
        self.advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: ["userName": name], serviceType: "tinkoff-chat")
        self.browser = MCNearbyServiceBrowser(peer: peerID, serviceType: "tinkoff-chat")
        self.online = true
        
        super.init()
        self.delegate = delegate
    }
    
    deinit {
        self.advertiser.stopAdvertisingPeer()
        self.browser.stopBrowsingForPeers()
    }
    
    func setupConnectivity() {
        self.advertiser.delegate = self
        self.advertiser.startAdvertisingPeer()
        
        self.browser.delegate = self
        self.browser.startBrowsingForPeers()
    }
    
    func sendMessage(string: String, to peer: MCPeerID, completionHandler: ((Bool, Error?) -> ())) {
        let message = [
            "eventType" : "TextMessage",
            "messageId" : String.generateMessageId(),
            "text" : string
        ]
        
        do {
            if let session = sessions[peer.displayName] {
                let data = try JSONSerialization.data(withJSONObject: message, options: [])
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            }
        } catch {
            print("Unable to send message")
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        let session = MCSession(peer: self.peerID, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        sessions[peerID.displayName] = session
        
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 60)
        delegate?.didFoundUser(userID: peerID.displayName, userName: info?["userName"])
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        delegate?.didLostUser(userID: peerID.displayName)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        let session = MCSession(peer: self.peerID, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        sessions[peerID.displayName] = session

        invitationHandler(true, session)
    }
}

extension MPCHandler: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            if let receivedData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                delegate?.didReceiveMessage(text: receivedData["text"] as! String, fromUser: peerID.displayName, toUser: self.peerID.displayName)
            }
        } catch {
            print("Unable to receive data")
        }
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) { }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) { }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
}
