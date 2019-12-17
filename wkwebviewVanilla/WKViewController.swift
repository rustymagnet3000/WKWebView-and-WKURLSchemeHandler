import UIKit
import WebKit

class WKViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    var webView: WKWebView!
    let resource: URL = URL(string: Scheme.normal + Endpoint.hostname + Endpoint.path)!
    
    override func loadView() {
        let configuration = WKWebViewConfiguration()
        let dataStore = WKWebsiteDataStore.nonPersistent()
        configuration.websiteDataStore = dataStore
        configuration.dataDetectorTypes = [.all]
            
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.customUserAgent = "Vanilla WKWebKit UserAgent"
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
        view = webView
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    //MARK: WKnavigationDelegate
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        ydHandleError(error: error)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        ydHandleError(error: error)
    }
    
    func ydHandleError(error: Error) {
        print("[*] ydHandleError: \(error.localizedDescription)")

    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {

        
        if let response = navigationResponse.response as? HTTPURLResponse {
            print("response \(response.statusCode) ")
            if response.statusCode == 401 {
                // handle Unauthorized request
            }
        }

        print("[*] WKNavigationResponse \(navigationResponse.response as? HTTPURLResponse)") // WKNavigationResponse always nil
        
        decisionHandler(.allow)
        return
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let a = webView.url?.absoluteString {
            print("[*] \(a)")
        }
    }
    
    //MARK: WKUIDelegate
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print("[*] runJavaScriptAlertPanelWithMessage called")
        let alertController = UIAlertController(title: message, message: nil,
                                                preferredStyle: UIAlertController.Style.alert);
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) {
            _ in completionHandler()}
        );
        
        self.present(alertController, animated: true, completion: {});
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myRequest = URLRequest(url: resource)
        self.webView.load(myRequest)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            print("[*] progress -> "  + String(webView.estimatedProgress))
        }
        if keyPath == "title" {
            if let title = webView.title {
                print("[*] title -> " + title)
            }
        }
    }
}

