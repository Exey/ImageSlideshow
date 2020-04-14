//
//  FullScreenSlideshowViewController.swift
//  ImageSlideshow
//
//  Created by Petr Zvoníček on 31.08.15.
//

import UIKit

@objcMembers
open class FullScreenSlideshowViewController: UIViewController {
    var slideshow: ImageSlideshow = {
        let slideshow = ImageSlideshow()
        slideshow.zoomEnabled = true
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFit
        slideshow.pageIndicatorPosition = PageIndicatorPosition(horizontal: .center, vertical: .bottom)
        // turns off the timer
        slideshow.slideshowInterval = 0
        // slideshow.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]

        return slideshow
    }()

    /// Close button
    open var closeButton = UIButton()

    /// Close button frame
    open var closeButtonFrame: CGRect?

    /// Closure called on page selection
    open var pageSelected: ((_ page: Int) -> Void)?

    /// Index of initial image
    open var initialPage: Int = 0

    /// Input sources to
    open var inputs: [InputSource]?

    /// Background color
    open var backgroundColor = UIColor.black

    /// Enables/disable zoom
    open var zoomEnabled = true {
        didSet {
            slideshow.zoomEnabled = zoomEnabled
        }
    }

    fileprivate var isInit = true

    open override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = backgroundColor
        slideshow.backgroundColor = backgroundColor

        if let inputs = inputs {
            slideshow.setImageInputs(inputs)
        }

        view.addSubview(slideshow)

        // close button configuration
        closeButton.setImage(UIImage(named: "ic_cross_white", in: Bundle(for: type(of: self)), compatibleWith: nil), for: UIControlState())
        closeButton.addTarget(self, action: #selector(FullScreenSlideshowViewController.close), for: UIControlEvents.touchUpInside)
        view.addSubview(closeButton)

        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        downSwipe.direction = .down
        view.addGestureRecognizer(downSwipe)
    }

    func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .down {
            close()
        }
    }

    open override var prefersStatusBarHidden: Bool {
        return true
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if isInit {
            isInit = false
            slideshow.setCurrentPage(initialPage, animated: false)
        }
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    func hide() {
        let coreApp: CoreAppService = ServiceLocator.assembly.inject()
        coreApp.window2?.isHidden = true
        coreApp.window2VC?.view.isHidden = false
        // mainWindow?.alpha = 1

        /* UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
             coreApp.window2VC?.view.alpha = 0.0
         }, completion: { _ in */
        coreApp.mainWindow?.makeKeyAndVisible()
        // })

        slideshow.slideshowItems.forEach { $0.cancelPendingLoad() }
    }

    open override func viewDidLayoutSubviews() {
        if !isBeingDismissed {
            /* let safeAreaInsets: UIEdgeInsets
             if #available(iOS 11.0, *) {
                 safeAreaInsets = view.safeAreaInsets
             } else {
                 safeAreaInsets = UIEdgeInsets.zero
             } */

            closeButton.frame = closeButtonFrame ?? CGRect(x: 10, y: 10, width: 40, height: 40)
        }
        let f = CGRect(x: view.frame.origin.x, y: view.frame.origin.y - 40, width: view.frame.size.width, height: view.frame.size.height)

        slideshow.frame = f
    }

    func close() {
        // if pageSelected closure set, send call it with current page
        if let pageSelected = pageSelected {
            pageSelected(slideshow.currentPage)
        }
        // window2?.resignKey()

        dismiss(animated: true, completion: nil)
        hide()
    }
}
