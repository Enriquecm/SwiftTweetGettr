
import UIKit

private let kAPIKey = ""
private let kAPISecret = ""
private let kPostMethod = "POST"
private let kGetMethod = "GET"
private let kContentTypeHeader = "Content-Type"
private let kAuthorizationHeader = "Authorization"
private let kOAuthRootURL = "https://api.twitter.com/oauth2/token"
private let kTimelineRootURL = "https://api.twitter.com/1.1/statuses/user_timeline.json?count=30&screen_name="
private let kAuthorizationBody = "grant_type=client_credentials"
private let kAuthorizationContentType = "application/x-www-form-urlencoded;charset=UTF-8"

class Client {
    
    class func fetchAuthorizationToken(#success:() -> Void, failure:(String) -> Void) {
        var tokenRequest = kOAuthRootURL.createURL().createMutableRequest()
        tokenRequest.HTTPMethod = kPostMethod
        tokenRequest.HTTPBody = kAuthorizationBody.data()
        tokenRequest.addValue(kAuthorizationContentType, forHTTPHeaderField: kContentTypeHeader)
        tokenRequest.addValue(authorizationHeader(), forHTTPHeaderField: kAuthorizationHeader)
        
        NSURLConnection.sendAsynchronousRequest(tokenRequest, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if response.isHTTPResponseValid() {
                if let token = data.json()["access_token"] as? String {
                    Authorization.shared.setToken(token)
                    success()
                } else {
                    failure("response has no access_token")
                }
            } else {
                self.handleFailure(failure, error: error, response: response)
            }
        })
    }
    
    class func fetchTweetsForUser(userName:String, success:(Array<AnyObject>) -> Void, failure:(String) -> Void) {
        var tweetRequest = (kTimelineRootURL + userName.stringByRemovingWhitespace()).createURL().createMutableRequest()
        tweetRequest.HTTPMethod = kGetMethod
        tweetRequest.addValue(authorizedHeader(), forHTTPHeaderField: kAuthorizationHeader)
        
        NSURLConnection.sendAsynchronousRequest(tweetRequest, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if response.isHTTPResponseValid() {
                if let results:Array<AnyObject> = data.json() as? Array {
                    success(results)
                }
            } else {
                self.handleFailure(failure, error: error, response: response)
            }
        })
    }
    
    class func fetchImageAtURL(url:String, forCell cell:UITableViewCell) -> Void {
        NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL:  NSURL(string: url)!), queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            if (response.isHTTPResponseValid()) {
                cell.imageView?.image = UIImage(data: data)
            }
        }
    }

    private class func handleFailure(failure:(String) -> Void, error:NSError!, response: NSURLResponse!) -> Void {
        if let actuallyError = error {
            failure(actuallyError.description)
        } else if let actuallyResponse = response {
            failure(actuallyResponse.description)
        } else {
            failure("no response or error")
        }
    }
    
    private class func authorizationHeader() -> String {
        return "Basic " + (kAPIKey + ":" + kAPISecret).base64Encoded()
    }
    
    private class func authorizedHeader() -> String {
        return "Bearer " + Authorization.shared.token()!
    }
    
}
