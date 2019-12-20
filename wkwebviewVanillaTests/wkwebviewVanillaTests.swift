import XCTest
import WebKit
@testable import wkwebviewVanilla

class wkwebviewVanillaTests: XCTestCase {
//--------------------------------------------------------------------------------------------
//MARK: Properties
    var wkSchemeVC: YDWKschemeVC!
    var wkVanillaVC: YDWKVanillaVC!
    var storyboard: UIStoryboard!

//--------------------------------------------------------------------------------------------
//MARK: Boiler Plate code
    override func setUp() {
        super.setUp()
        print("[*]\tUnit Test setup...")
        let bundle = Bundle(for: self.classForCoder)
        storyboard = UIStoryboard(name: "Main", bundle: bundle)
    }

//--------------------------------------------------------------------------------------------
//MARK: genericExpecation
    
    func genericExpectation(sbName:String) {
        let raw_vc = storyboard.instantiateViewController(withIdentifier: sbName) as? YDWKVanillaVC
        guard let vc = raw_vc else{
            fatalError("can't unwrap \(String(describing: raw_vc))")
        }
        
        let _ = vc.view     // <-- required to lifecycle the UIViewController
        
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
        waitForExpectations(timeout: 10, handler: nil)
    }
//--------------------------------------------------------------------------------------------
//MARK: testFunctions
    func testVanillaWK() {
        for _ in 1...10 {
            genericExpectation(sbName: "YDWKvanillaSB")
        }
    }
    
    func testURLSchemeWK() {
        for _ in 1...10 {
            genericExpectation(sbName: "YDWKschemeSB")
        }
    }
}
