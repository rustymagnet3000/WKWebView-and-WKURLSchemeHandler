import UIKit
import WebKit


class WKschemeViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var webView: WKWebView!
    let resource: URL = URL(string: "rm://www.httpbin.org/")!
    
    override func loadView() {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        configuration.dataDetectorTypes = [.all]
        let customSchemeHandler = YDWKURLSchemeHandler()
        configuration.setURLSchemeHandler(customSchemeHandler, forURLScheme: "rm")

        webView = WKWebView(frame: .zero, configuration: configuration)
        view = webView
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myRequest = URLRequest(url: resource)
        self.webView.load(myRequest)
    }
    
    
}

