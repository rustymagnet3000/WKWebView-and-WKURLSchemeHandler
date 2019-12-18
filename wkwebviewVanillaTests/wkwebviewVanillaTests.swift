import XCTest
import WebKit

class wkwebviewVanillaTests: XCTestCase {
    
    var wkSchemeVC: YDWKschemeVC!
    var wkVanillaVC: WKViewController!
    var storyboard: UIStoryboard!
    
    override func setUp() {
        super.setUp()
        print("[*]\tUnit Test time...")
        let bundle = Bundle(for: self.classForCoder)
        storyboard = UIStoryboard(name: "Main", bundle: bundle)
    }
    
        //--------------------------------------------------------------------------------------------
        // MARK: - wkSchemeVC Tests
        // creates a loop of wkSchemeVC instances on the Heap
    
    func testWKSchemeVCLifeCycle() {

        let expectation = XCTestExpectation(description: "testWKSchemeVCLifeCycle")
        expectation.expectedFulfillmentCount = 1
        
        for _ in 1...3 {
            self.wkSchemeVC = self.storyboard.instantiateViewController(withIdentifier: "YDWKschemeSB") as! YDWKschemeVC
            print(self.wkSchemeVC.self!)
            
            print(self.wkSchemeVC.webView as Any)
            
        }
        expectation.fulfill()


        wait(for: [expectation], timeout: 5)
        
        
    }

    func testPerformanceExample() {
        measure {
            // wkVanillaVC = storyboard.instantiateViewController(withIdentifier: "YDWKvanillaSB") as! WKViewController

        }
    }

}
