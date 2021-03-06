//
//  ViewControllerResolver.swift
//  iOS-DollarCostAveraging
//
//  Created by Marina McPeak on 2022-05-03.
//

import SwiftUI

/*
 `UIViewControllerRepresentable` is a protocol to manage a `UIViewController`
 with the SwiftUI Interface
*/
final class ViewControllerResolver: UIViewControllerRepresentable {

    let onResolve: (UIViewController) -> Void

    // `onResolve` will escape the scope of the functions it's passed too
    init(onResolve: @escaping (UIViewController) -> Void) {
        self.onResolve = onResolve
    }

    func makeUIViewController(context: Context) -> ParentResolverViewController {
        ParentResolverViewController(onResolve: onResolve)
    }

    func updateUIViewController(_ uiViewController: ParentResolverViewController, context: Context)
    {}
}

class ParentResolverViewController: UIViewController {

    let onResolve: (UIViewController) -> Void

    init(onResolve: @escaping (UIViewController) -> Void) {
        self.onResolve = onResolve
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Use init(onResolve:) to instantiate ParentResolverViewController.")
    }

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)

        if let parent = parent {
            onResolve(parent)
        }
    }
}



