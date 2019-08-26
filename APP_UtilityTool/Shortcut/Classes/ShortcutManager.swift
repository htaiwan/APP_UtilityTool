//
//  ShortcutManager.swift
//  APP_Utility
//
//  Created by Alex Cheng on 2019/8/23.
//  Copyright © 2019 Chien-Tai Cheng. All rights reserved.
//

import Foundation
import Intents
import IntentsUI

public class ShortcutManager: NSObject {

    public static let shared = ShortcutManager()
    private var vc: UIViewController?

    private override init(){}

    public func addShortcutsButton(to view: UIView, in vc:UIViewController, with intent: INIntent?) {
        guard let intent = intent,
              let shortcut = INShortcut(intent: intent) else { return }

        self.vc = vc
        let button = INUIAddVoiceShortcutButton(style: .whiteOutline)
        button.shortcut = shortcut
        button.delegate = self

        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        button.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        button.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        button.addTarget(self, action: #selector(addToSiri(shortcutButton:)), for: .touchUpInside)
    }

    // MARK: - Target Action

    @objc func addToSiri(shortcutButton sender: INUIAddVoiceShortcutButton) {
        guard let shortcut = sender.shortcut else { return }
        let viewController = INUIAddVoiceShortcutViewController(shortcut: shortcut)
        viewController.delegate = self
        self.vc?.modalPresentationStyle = .formSheet
        self.vc?.present(viewController, animated: true, completion: nil)
    }

}

extension ShortcutManager: INUIAddVoiceShortcutViewControllerDelegate {

    // MARK: INUIAddVoiceShortcutViewControllerDelegate

    public func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {

        self.vc?.dismiss(animated: true, completion: nil)
    }

    public func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        self.vc?.dismiss(animated: true, completion: nil)
    }

}

extension ShortcutManager: INUIAddVoiceShortcutButtonDelegate {

    // MARK: INUIAddVoiceShortcutButtonDelegate

    public func present(_ addVoiceShortcutViewController: INUIAddVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        addVoiceShortcutViewController.delegate = self
        self.vc?.present(addVoiceShortcutViewController, animated: true, completion: nil)
    }

    /// - Tag: edit_phrase
    public func present(_ editVoiceShortcutViewController: INUIEditVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        editVoiceShortcutViewController.delegate = self
        self.vc?.present(editVoiceShortcutViewController, animated: true, completion: nil)
    }

}

extension ShortcutManager: INUIEditVoiceShortcutViewControllerDelegate {

    // MARK: INUIEditVoiceShortcutViewControllerDelegate

    public func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {

        controller.dismiss(animated: true, completion: nil)
    }

    public func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
        controller.dismiss(animated: true, completion: nil)
    }

    public func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

}
