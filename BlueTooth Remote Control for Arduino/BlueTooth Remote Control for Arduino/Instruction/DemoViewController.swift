//
//  DemoViewController.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 26/12/2021.
//

import UIKit

class DemoViewController: UIPageViewController {
    
    var pages = [UIViewController]()
    
    let prevButton = UIButton()
    let nextButton = UIButton()
    let pageControl = UIPageControl()
    let initialPage = 0
    
    // animations
    var pageControlBottomAnchor: NSLayoutConstraint?
    var skipButtonTopAnchor: NSLayoutConstraint?
    var nextButtonTopAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        style()
        layout()
    }
}

extension DemoViewController {
    
    func setup() {
        dataSource = self
        delegate = self
        
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
        
        let page1 = OnboardingViewController(titleText: "Material",
                                             subtitleText: """
                                                You will need :
                                                - an Arduino
                                                - a bread-board
                                                - a Bluetooth module HM-10
                                                - a led
                                                - a 220 ohms resistor
                                                - a servo motor
                                                - wires
                                                - a photo resist
                                                - a 10kOhms resistor
                                                """)
        
        let page2 = OnboardingViewController(titleText: "Wiring",
                                             subtitleText: """
                                                1 - Connect 5v and ground from Arduino to the bread-board.
                                                2 - Then led from pin 2 to resistor 220Ohms and then to the ground.
                                                3 - Connect the servo motor to 5v and ground, and connect Servo's data pin to pin number 3 on the Arduino.
                                                4 - Connect the Bluetooth Module to 5v and ground. Be careful if you use another module. Sometimes it requires to be connected to 3.3v.
                                                5 - Then connect TX module’s pin to pin 10 and RX module’s pin to pin 9.
                                                """)
        
        let page2bis = OnboardingImageViewController(imageName: "Wiring",
                                             titleText: "Wiring",
                                             subtitleText: """
                                                6 - Connect the photo resist : one pin to 5V and the other one to A0.
                                                7 - Use 10KOhms resistor to connect A0 to the ground.
                                                """)
        
        let page3 = OnboardingViewController(titleText: "Downloading Program",
                                             subtitleText: """
                                            Use the Download Tab to download this program, and open it with Arduino IDE.
                                            """)
        
        let page3bis = OnboardingImageViewController(imageName: "BoutonPrgm", titleText: "Program's order",
                                             subtitleText: """
                                            "LED_OFF" is the order to send to switch the led off.
                                            Other orders are :
                                            - "LED_ON" to switch the led on
                                            - "0", "90", "179" to give this angle to the Servomotor.
                                            - "Servo-" and "Servo+" to decrease or increase the angle by 5 degrees.
                                            """)
        let page4 = OnboardingImageViewController(imageName: "ButtonConfig", titleText: "Create a Profile",
                                             subtitleText: """
                                            Let's create a profile.
                                            - Open the Configuration Tab.
                                            - Then enter orders you want to send in Button's order and button's name in Button's name.
                                            - Configure data's name Arduino will send you. Here first data's name will be "Light" and Second data's name will be "Angle"
                                            - Give a name to your profile in "Save's name" and save it.
                                            """)
        
        let page4bis = OnboardingImageViewController(imageName: "Programmed", titleText: "Create a Profile",
                                             subtitleText: """
                                            It should look like that.
                                            """)
        
        let page5 = OnboardingImageViewController(imageName: "RemoteOpened", titleText: "Loading Profile",
                                             subtitleText: """
                                            Let's use the remote control.
                                            - Open the Remmote Control Tab.
                                            - Clic on Load Profile and choose the profile you want.
                                            - Turn on Arduino.
                                            - Choose the Bluetooth available (usually "HMSoft") and...
                                            """)
        
        let page6 = OnboardingViewController(titleText: "Have fun",
                                             subtitleText: "")
        
        let page6bis = OnboardingImageViewController(imageName: "EditScreen", titleText: "Edit Profile",
                                             subtitleText: """
                                            You can edit profile by swiping from left.
                                            """)
        
        let page6ter = OnboardingImageViewController(imageName: "DelScreen", titleText: "Delete Profile",
                                             subtitleText: """
                                            You can delete profile by swiping from right.
                                            """)
        
        
        let page7 = OnboardingViewController(titleText: "Evolution",
                                             subtitleText: "You can change easily Arduino's program by commands you want to adapt for your personnal use. I hope you will enjoy this programm as much as I enjoyed programming it.")
        
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page2bis)
        pages.append(page3)
        pages.append(page3bis)
        pages.append(page4)
        pages.append(page4bis)
        pages.append(page5)
        pages.append(page6)
        pages.append(page6bis)
        pages.append(page6ter)
        pages.append(page7)
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
    }
    
    func style() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .systemGray2
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage
        
        prevButton.translatesAutoresizingMaskIntoConstraints = false
        prevButton.setTitleColor(.systemGray6, for: .normal)
        prevButton.setTitle("Prev", for: .normal)
        prevButton.addTarget(self, action: #selector(prevTapped(_:)), for: .primaryActionTriggered)
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitleColor(.systemGray6, for: .normal)
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(nextTapped(_:)), for: .primaryActionTriggered)
    }
    
    func layout() {
        view.addSubview(pageControl)
        view.addSubview(nextButton)
        view.addSubview(prevButton)
        
        NSLayoutConstraint.activate([
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 120),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            prevButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            
            
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: nextButton.trailingAnchor, multiplier: 2),
        ])
        
        // for animations
        pageControlBottomAnchor = view.bottomAnchor.constraint(equalToSystemSpacingBelow: pageControl.bottomAnchor, multiplier: 2)
        skipButtonTopAnchor = prevButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2)
        nextButtonTopAnchor = nextButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2)
        
        pageControlBottomAnchor?.isActive = true
        skipButtonTopAnchor?.isActive = true
        nextButtonTopAnchor?.isActive = true
    }
}

// MARK: - DataSource

extension DemoViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        if currentIndex == 0 {
            return pages.last               // wrap last
        } else {
            return pages[currentIndex - 1]  // go previous
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]  // go next
        } else {
            return pages.first              // wrap first
        }
    }
}

// MARK: - Delegates

extension DemoViewController: UIPageViewControllerDelegate {
    
    // How we keep our pageControl in sync with viewControllers
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        
        pageControl.currentPage = currentIndex
        animateControlsIfNeeded()
    }
    
    private func animateControlsIfNeeded() {
        let lastPage = pageControl.currentPage == pages.count - 1
        
        if lastPage {
            hideControls()
        } else {
            showControls()
        }
        /*
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
 */
    }
    
    private func hideControls() {
        pageControlBottomAnchor?.constant = -80
        skipButtonTopAnchor?.constant = -80
        nextButtonTopAnchor?.constant = -80
    }
    
    private func showControls() {
        pageControlBottomAnchor?.constant = 16
        skipButtonTopAnchor?.constant = 16
        nextButtonTopAnchor?.constant = 16
    }
}

// MARK: - Actions

extension DemoViewController {
    
    @objc func pageControlTapped(_ sender: UIPageControl) {
        setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true, completion: nil)
        animateControlsIfNeeded()
    }
    
    @objc func skipTapped(_ sender: UIButton) {
        let lastPage = pages.count - 1
        pageControl.currentPage = lastPage
        
        goToSpecificPage(index: lastPage, ofViewControllers: pages)
        animateControlsIfNeeded()
    }
    
    @objc func nextTapped(_ sender: UIButton) {
        pageControl.currentPage += 1
        goToNextPage()
        animateControlsIfNeeded()
    }
    @objc func prevTapped(_ sender: UIButton) {
        pageControl.currentPage -= 1
        goToPreviousPage()
        animateControlsIfNeeded()
    }
}

// MARK: - Extensions

extension UIPageViewController {
    
    func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentPage) else { return }
        
        setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
    }
    
    func goToPreviousPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let prevPage = dataSource?.pageViewController(self, viewControllerBefore: currentPage) else { return }
        
        setViewControllers([prevPage], direction: .forward, animated: animated, completion: completion)
    }
    
    func goToSpecificPage(index: Int, ofViewControllers pages: [UIViewController]) {
        setViewControllers([pages[index]], direction: .forward, animated: true, completion: nil)
    }
}
