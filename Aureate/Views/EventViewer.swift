//
//  NewEventGenerator.swift
//  Aureate
//
//  Created by Katherine Palevich on 10/23/21.
// Taken from https://stackoverflow.com/questions/63104171/swiftui-ekeventeditviewcontroller-fields-not-editable

import SwiftUI
import EventKitUI


struct EventViewer: UIViewControllerRepresentable {
    typealias UIViewControllerType = EKEventEditViewController

    @Environment(\.dismiss) var dismiss
    var theEvent: EKEvent

    init(event: EKEvent) {

        theEvent = event

    }


func makeUIViewController(context: UIViewControllerRepresentableContext<EventViewer>) -> EKEventEditViewController {

    let controller = EKEventEditViewController()
    controller.event = theEvent
    controller.eventStore = Events.eventStore
    controller.editViewDelegate = context.coordinator

    return controller
}

func updateUIViewController(_ uiViewController: EventViewer.UIViewControllerType, context: UIViewControllerRepresentableContext<EventViewer>) {
    uiViewController.view.backgroundColor = .red
}


func makeCoordinator() -> Coordinator {
    return Coordinator(dismiss: dismiss)
}

class Coordinator : NSObject, UINavigationControllerDelegate, EKEventEditViewDelegate {

    var dismiss: DismissAction

    init(dismiss: DismissAction) {
        self.dismiss = dismiss
    }

    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        switch action {
        case .canceled:
            dismiss()
        case .saved:
            do {
                try controller.eventStore.save(controller.event!, span: .thisEvent, commit: true)
            }
            catch {
                print("Event couldn't be created")
            }
            dismiss()
        case .deleted:
            dismiss()
        @unknown default:
            dismiss()
        }
    }
}}
