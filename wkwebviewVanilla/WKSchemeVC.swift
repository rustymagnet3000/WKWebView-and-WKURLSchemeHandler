import UIKit
import WebKit


class WKschemeViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var webView: WKWebView!
    let resource: URL = URL(string: Scheme.custom + Endpoint.hostname + Endpoint.path)!
    
    override func loadView() {
        let configuration = WKWebViewConfiguration()
        let customSchemeHandler = YDWKURLSchemeHandler()

        configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        configuration.dataDetectorTypes = [.all]        
        configuration.setURLSchemeHandler(customSchemeHandler, forURLScheme: Scheme.custom)

        
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

