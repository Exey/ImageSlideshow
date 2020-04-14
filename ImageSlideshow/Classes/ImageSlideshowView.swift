//
//  ImageSlideshow.swift
//
//
//  Created by Exey Panteleev on 18.09.2019.
//  Copyright © 2019 Exey Panteleev. All rights reserved.
//

import SwiftUI

/*
 Usage
 
 ImageSlideshowView(source: self.$viewModel.images)

 */
struct ImageSlideshowView: UIViewRepresentable {
    
    @Binding var source: [KingfisherSource]

    var slideshow: ImageSlideshow? = ImageSlideshow()

    func makeUIView(context _: UIViewRepresentableContext<ImageSlideshowView>) -> ImageSlideshow {
        // slideshow

        slideshow?.slideshowInterval = 0
        slideshow?.circular = true
        slideshow?.contentScaleMode = UIViewContentMode.scaleAspectFill

        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor(hex: 0x666666)

        slideshow?.pageIndicator = pageControl
        slideshow?.pageIndicatorPosition = PageIndicatorPosition(horizontal: .left(padding: 8), vertical: .customBottom(padding: 14))
        slideshow?.activityIndicator = DefaultActivityIndicator()

        slideshow?.setImageInputs(source)

        return slideshow!
    }

    final class Coordinator: NSObject, UISearchBarDelegate {

        var slideshow: ImageSlideshow?

        init(slideshow: ImageSlideshow?) {
            self.slideshow = slideshow
            super.init()

            let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
            slideshow?.addGestureRecognizer(recognizer)
        }

        @objc func didTap() {
            // Create Second UIWindow
            /*
             Place it in SceneDelegate or someWhere
             var window2VC: UIViewController?
             var window2: UIWindow?
             var mainWindow: UIWindow? // Your first UIWindow
             */
            window2VC = slideshow!.createFullScreenController()
            window2 = UIWindow(windowScene: mainWindowScene!)
            window2?.rootViewController = window2VC!
            window2VC!.view.alpha = 0.0
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.window2VC?.view.alpha = 1.0
            }, completion: nil)
            window2?.makeKeyAndVisible()
            mainWindow?.isHidden = true
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(slideshow: slideshow)
    }

    func updateUIView(_ uiView: ImageSlideshow, context _: UIViewRepresentableContext<ImageSlideshowView>) {

        uiView.setImageInputs(source)
    }
}

