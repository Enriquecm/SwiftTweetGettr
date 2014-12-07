
import UIKit

class TweetsTableViewDelegate : NSObject, UITableViewDataSource, UITableViewDelegate {
 
    var tweets = Array<AnyObject>()
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as UITableViewCell
        let tweet = tweets[indexPath.row] as NSDictionary
        
        cell.textLabel?.text = tweet["text"] as? String
        cell.detailTextLabel?.text = tweet["created_at"] as? String
        cell.imageView?.image = UIImage(named: "default")
        Client.fetchImageAtURL(tweet.valueForKeyPath("user.profile_image_url") as String, forImageView: cell.imageView!)
        return cell
    }
        
}