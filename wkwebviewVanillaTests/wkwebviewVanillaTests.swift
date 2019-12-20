import XCTest
import WebKit
@testable import wkwebviewVanilla

// weird trick: https://www.natashatherobot.com/ios-testing-view-controllers-swift/
// https://www.vadimbulavin.com/unit-testing-async-code-in-swift/

class wkwebviewVanillaTests: XCTestCase {
    
    var wkSchemeVC: YDWKschemeVC!
    var wkVanillaVC: WKViewController!
    var storyboard: UIStoryboard!
    
    override func setUp() {
        super.setUp()
        print("[*]\tUnit Test setup...")
        let bundle = Bundle(for: self.classForCoder)
        storyboard = UIStoryboard(name: "Main", bundle: bundle)
    }

//--------------------------------------------------------------------------------------------

    func checkWebview(exp: XCTestExpectation) {
        
        guard wkSchemeVC.webView.isLoading == true else {
            exp.fulfill()
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.10, execute: {
            self.checkWebview(exp: exp)
            })
    }
    
    func testWKSchemeVCLifeCycle() {
        let didFinish = self.expectation(description: "WK")
        didFinish.expectedFulfillmentCount = 1
        
        wkSchemeVC = storyboard.instantiateViewController(withIdentifier: "YDWKschemeSB") as? YDWKschemeVC
        guard let vc = wkSchemeVC else{
            fatalError("can't unwrap \(String(describing: wkSchemeVC))")
        }
         
        let _ = vc.view
        checkWebview(exp: didFinish)
        
        print("[*] Wait about to invoke")
        wait(for: [didFinish], timeout: 5)
    }

//--------------------------------------------------------------------------------------------

    func testVanillaWK() {
       
        wkVanillaVC = storyboard.instantiateViewController(withIdentifier: "YDWKvanillaSB") as? WKViewController
        
        guard let vc = wkVanillaVC else{
            fatalError("can't unwrap \(String(describing: wkVanillaVC))")
        }
        
        let _ = vc.view
        
        guard let wk = vc.webView else{
            fatalError("can't unwrap webview")
        }
        
        keyValueObservingExpectation(for: wk, keyPath: "loading", handler: { (observedObject, change) in

            if let old = change["old"] as? Bool, let new = change["new"] as? Bool {
                print("[*] isLoading\n\t\tOld:\t\(String(old))\n\t\tNew:\t\(String(new))")
                if new == false {
                    return true
                }
            }
            
            return false
        })

        print("[*] Wait about to invoke")
        waitForExpectations(timeout: 5, handler: nil)
    }
}
