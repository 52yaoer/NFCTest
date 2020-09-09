//
//  ViewController.swift
//  NFC test
//
//  Created by Mauro Canhao on 09/09/2020.
//  Copyright © 2020 Mauro Canhao. All rights reserved.
//

import UIKit
import CoreNFC

class ViewController: UIViewController, NFCNDEFReaderSessionDelegate {
    
    var textFromTag = UILabel()
    var readButton = UIButton()
    var imageView = UIImageView()
    
    var nfcSession: NFCNDEFReaderSession?
    var word = "none"

    override func viewDidLoad() {
        super.viewDidLoad()
        textFromTag = createLabel()
        readButton = createButton()
        imageView = createImageView()
        
        applyConstraints()
    }
    
    func createLabel() -> UILabel {
        //Label setup
        let label = UILabel()
        label.backgroundColor = .lightGray
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.text = "Your tag's text"
        label.textAlignment = .center
        return label
    }
    
    func createButton() -> UIButton {
        //Button setup
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 10
        button.clipsToBounds = false
        button.contentMode = .center
        button.setTitle("Read", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.addTarget(self, action: #selector(readTag), for: .touchUpInside)
        return button
    }
    
    func createImageView() -> UIImageView {
        //Label setup
        let image = UIImageView()
        image.backgroundColor = .lightGray
        image.layer.cornerRadius = 15
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }
    
    func applyConstraints () {
        //Apply and activate constraints for autolayout
        view.addSubview(textFromTag)
        textFromTag.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(readButton)
        readButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            //Label's constraints
            textFromTag.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFromTag.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textFromTag.widthAnchor.constraint(equalToConstant: 200),
            textFromTag.heightAnchor.constraint(equalToConstant: 50),
            //Button's constraints
            readButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            readButton.topAnchor.constraint(equalTo: textFromTag.bottomAnchor, constant: 20),
            readButton.widthAnchor.constraint(equalToConstant: 100),
            readButton.heightAnchor.constraint(equalToConstant: 50),
            //Image's constraints
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: textFromTag.topAnchor, constant: -20),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ]
        NSLayoutConstraint.activate(constraints)
       
    }
    
    @objc func readTag(sender: UIButton!) {
      print("Button tapped")
        nfcSession = NFCNDEFReaderSession.init(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        nfcSession?.begin()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("This session was invalidated: \(error.localizedDescription)")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        var result = ""
        for payload in messages[0].records{
            result = String.init(data: payload.payload.advanced(by: 3), encoding: .utf8) ?? "format not supported"
        }
        
        DispatchQueue.main.async {
            self.textFromTag.text = result
            print ("RESULT: \(result)")
            if result == "Dog" {
                print ("IF DOG")
                self.imageView.image = UIImage(named: "dog")
            }
            if result == "Cat" {
                print ("IF CAT")
                self.imageView.image = UIImage(named: "cat")
            }
        }
        
    }

}

