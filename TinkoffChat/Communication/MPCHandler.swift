import Foundation
import MultipeerConnectivity

protocol Communicator {
    weak var delegate: CommunicationDelegate? { get set }
    var online: Bool {get set}
    
    func sendMessage(string: String, to peer: MCPeerID, completionHandler:((_ success: Bool, _ error: Error?) -> ()))
}

class MPCHandler: NSObject, Communicator, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate  {
   
    let peerID: MCPeerID = MCPeerID(displayName: UIDevice.current.name)
    lazy var session : MCSession = {
        let session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        return session
    }()
    
    var advertiser : MCNearbyServiceAdvertiser!
    var browser: MCNearbyServiceBrowser!
    var online: Bool
    
    weak var delegate: CommunicationDelegate?
    
    init(delegate: CommunicationDelegate) {
        let name = ProfileViewController.profileInfo.name
        self.advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: ["userName": name], serviceType: "tinkoff-chat")
        self.browser = MCNearbyServiceBrowser(peer: peerID, serviceType: "tinkoff-chat")
        self.online = true
        
        super.init()
        self.delegate = delegate
        
        self.advertiser.delegate = self
        self.advertiser.startAdvertisingPeer()
        
        self.browser.delegate = self
        self.browser.startBrowsingForPeers()
    }
    
    deinit {
        self.advertiser.stopAdvertisingPeer()
        self.browser.stopBrowsingForPeers()
    }
    
    func sendMessage(string: String, to peer: MCPeerID, completionHandler: ((Bool, Error?) -> ())) {
        if let message = string.data(using: .utf8) {
            var peers: [MCPeerID] = []
            peers.append(peer)
            do {
                try session.send(message, toPeers: peers, with: .reliable)
            } catch {
                print("Unable to send message")
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 60)
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
        invitationHandler(true, self.session)
    }
}

extension MPCHandler: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("Data")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) { }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) { }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
}
