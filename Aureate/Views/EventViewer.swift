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

    @Binding var isShowing: Bool
    var theEvent: EKEvent

    init(event: EKEvent, isShowing: Binding<Bool>) {

        theEvent = event

        _isShowing = isShowing
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
    return Coordinator(isShowing: $isShowing)
}

class Coordinator : NSObject, UINavigationControllerDelegate, EKEventEditViewDelegate {

    @Binding var isVisible: Bool

    init(isShowing: Binding<Bool>) {
        _isVisible = isShowing
    }

    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        switch action {
        case .canceled:
            isVisible = false
        case .saved:
            do {
                try controller.eventStore.save(controller.event!, span: .thisEvent, commit: true)
            }
            catch {
                print("Event couldn't be created")
            }
            isVisible = false
        case .deleted:
            isVisible = false
        @unknown default:
            isVisible = false
        }
    }
}}
