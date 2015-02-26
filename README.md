#Twitter redux

Time spent: 20

### Features

Hamburger menu
- [] Dragging anywhere in the view should reveal the menu.
- [] The menu should include links to your profile, the home timeline, and the mentions view.
- [] The menu can look similar to the LinkedIn menu below or feel free to take liberty with the UI.

Profile page
- [] Contains the user header view
- [] Contains a section with the users basic stats: # tweets, # following, # followers
- [] Optional: Implement the paging view for the user description.
- [] Optional: As the paging view moves, increase the opacity of the background screen. 
- [] Optional: Pulling down the profile page should blur and resize the header image.

Home Timeline
Tapping on a user image should bring up that user's profile page
- [] Optional: Account switching
- [] Long press on tab bar to bring up Account view with animation
- [] Tap account to switch to
- [] Include a plus button to Add an Account
- [] Swipe to delete an account


# Twitter
This is a basic twitter app to read and compose tweets using the [Twitter API](https://apps.twitter.com/).

Time spent: 20

### Features

#### Required

- [X] User can sign in using OAuth login flow
- [X] User can view last 20 tweets from their home timeline
- [X] The current signed in user will be persisted across restarts
- [X] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.  In other words, design the custom cell with the proper Auto Layout settings.  You will also need to augment the model classes.
- [X] User can pull to refresh  
- [X] User can compose a new tweet by tapping on a compose button.
- [X] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
- [X] User can retweet, favorite, and reply to the tweet directly from the timeline feed.

#### Optional

- [X] When composing, you should have a countdown in the upper right for the tweet limit.
- [X] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [X] Retweeting and favoriting should increment the retweet and favorite count.
- [X] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [X] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
- [X] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

### Walkthrough

![Video Walkthrough](twitter.gif)

Libraries:
- SVProgressHUD
- AFNetworking 
- BDBOAuth1Manager
- SVProgressHUD
- twitter-text-objc
- TTTAttributedLabel