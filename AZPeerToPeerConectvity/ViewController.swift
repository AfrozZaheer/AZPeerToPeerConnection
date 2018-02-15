//
//  ViewController.swift
//  AZPeerToPeerConectvity
//
//  Created by Muhammad Afroz on 9/6/17.
//  Copyright © 2017 AfrozZaheer. All rights reserved.
//

import UIKit
import AZPeerToPeerConnection
import MultipeerConnectivity

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var toolbar: UIToolbar!
    
    var messages = [String]()
    
    var cellIdentifier = "SenderCell"
    let connection = P2PServiceHandler.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        connection.delegate = self
        connection.setupConnection(serviceName: "AZP2Ptest")

        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        textField.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    @IBAction func presentMCBrowser(_ sender: Any) {
        
        connection.joinSession(vc: self, mcBrowser: nil) // nil == default mcbrowsr
    }
    @IBAction func sendText(_ sender: Any) {
        connection.sendData(data: ["message": textField.text ?? "defaultValue"])
        messages.append(textField.text!)
        cellIdentifier = CellIdetifier.sender.rawValue
        let index = IndexPath(row: messages.count - 1, section: 0)
        tableView.insertRows(at: [index], with: .automatic)
    }
}
extension ViewController: P2PServiceHandlerDelegate {
    func didConnectedTo(_ serviceHandler: P2PServiceHandler, to peer: MCPeerID) {
        
    }
    
    func didFailToConnect(_ serviceHandler: P2PServiceHandler, with peer: MCPeerID) {
        
    }
    
    func connecting(_ serviceHandler: P2PServiceHandler, to peer: MCPeerID) {
        
    }
    
    func didRecieve(_ serviceHandler: P2PServiceHandler, data: [String : Any]) {
        
        DispatchQueue.main.async {
            if let val = data["message"] {
                self.cellIdentifier = CellIdetifier.reciever.rawValue
                self.messages.append(val as! String)
                let index = IndexPath(row: self.messages.count - 1, section: 0)
                self.tableView.insertRows(at: [index], with: .automatic)

            }
        }
    }
}
extension ViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField != self.textField {
            textField.inputAccessoryView = toolbar
        }
    }
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ChatTableViewCell

            cell.lblText.text = messages[indexPath.row]
            return cell

//        }
//        else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdetifier.reciever.rawValue) as! ChatTableViewCell
//
//            cell.lblText.text = "Hi how are you. I'm testing this aap which use local text message"
//            return cell
//
//        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
}


enum CellIdetifier: String {
    case sender = "SenderCell",
    reciever = "RecieverCell"
}












