//
//  MainViewController.m
//  Twitter
//
//  Created by Dhanu Agnihotri on 2/26/15.
//  Copyright (c) 2015 ___SocietyTech___. All rights reserved.
//

#import "MainViewController.h"
#import "TweetsViewController.h"
#import "MenuViewController.h"
#import "ProfileViewController.h"
#import "LoginViewController.h"
#import "MentionsViewController.h"

#define SLIDE_TIMING .25
#define PANEL_WIDTH 60

@interface MainViewController () <UIGestureRecognizerDelegate, MenuViewControllerDelegate, LoginViewControllerDelegate>

@property (nonatomic, strong) MenuViewController *menuViewController;
@property (nonatomic, strong) UINavigationController *tweetNavigationController;
@property (nonatomic, strong) UINavigationController *mentionsNavigationController;
@property (nonatomic, strong) UINavigationController *profileNavigationController;
@property (nonatomic, strong) UIViewController *centralViewController;
@property (nonatomic, strong) LoginViewController *loginViewController;

@property (nonatomic, assign) BOOL showingMenuPanel;
@property (nonatomic, assign) BOOL showCenterPanel;

@property (nonatomic, assign) NSInteger menuIndex;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuIndex = 1; //When starting out show the home timeline
    
    TweetsViewController *tweetsViewController = [[TweetsViewController alloc] init];
    self.tweetNavigationController = [[UINavigationController alloc] initWithRootViewController:tweetsViewController];
    
    ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
    profileViewController.user = [User currentUser];
    self.profileNavigationController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
    
    MentionsViewController *mentionsViewController = [[MentionsViewController alloc] init];
    self.mentionsNavigationController = [[UINavigationController alloc] initWithRootViewController:mentionsViewController];

    self.loginViewController = [[LoginViewController alloc] init];
    self.loginViewController.delegate = self;
    
    // Do any additional setup after loading the view from its nib.
    [self setupView];
}

-(void)setupView
{
    // remove menu view, and reset variables, if needed
    if (self.centralViewController != nil)
    {
        [self.centralViewController.view removeFromSuperview];
        self.centralViewController = nil;
    }
    
    // setup center view
    switch(self.menuIndex)
    {
        case 0:self.centralViewController = self.profileNavigationController;
            break;
        case 1:self.centralViewController = self.tweetNavigationController;
            break;
        case 2:self.centralViewController = self.mentionsNavigationController;
            break;
        case 3:self.centralViewController = self.loginViewController;
            break;
        default:
            break;
    }
    
    [self.view addSubview:self.centralViewController.view];
    [self addChildViewController:self.centralViewController];
    
    [self.centralViewController didMoveToParentViewController:self];

    [self setupGestures];
}

- (UIView *)getMenuView
{
    // init view if it doesn't already exist
    if (self.menuViewController == nil)
    {
        self.menuViewController = [[MenuViewController alloc] init];
        self.menuViewController.delegate = self;

        [self.view addSubview:self.menuViewController.view];
        
        [self addChildViewController:self.menuViewController];
        [self.menuViewController didMoveToParentViewController:self];
        
        self.menuViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    self.showingMenuPanel = YES;
    
    // set up view shadows
    [self showCenterViewWithShadow:YES withOffset:-2];
    
    UIView *view = self.menuViewController.view;
    return view;
}

- (void)resetMainView
{
    // remove menu view, and reset variables, if needed
    if (self.menuViewController != nil)
    {
        [self.menuViewController.view removeFromSuperview];
        self.menuViewController = nil;
        
        self.showingMenuPanel = NO;
    }
    
    // remove view shadows
    [self showCenterViewWithShadow:NO withOffset:0];
}

- (void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset
{
    if (value)
    {
        [self.centralViewController.view.layer setCornerRadius:4];
        [self.centralViewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.centralViewController.view.layer setShadowOpacity:0.8];
        
    }
    else
    {
        [self.centralViewController.view.layer setCornerRadius:0.0f];
    }
    [self.centralViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
}

#pragma mark pan gesture methods
- (void)setupGestures
{
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    
    //We should be able to pan anywhere from the view
    [self.centralViewController.view addGestureRecognizer:panRecognizer];
}

-(void)movePanel:(id)sender
{
    [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer*)sender velocityInView:[sender view]];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        UIView *childView = nil;

        if(velocity.x > 0)
        { //we are moving to the left
            if (!self.showingMenuPanel)
            {
                childView = [self getMenuView];
            }
        }

        // Make sure the view you're working with is front and center.
        [self.view sendSubviewToBack:childView];
        [[sender view] bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    }

    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        if (!self.showCenterPanel) {
            [self movePanelToOriginalPosition];
        }
        else
        {
            if (self.showingMenuPanel) {
                [self movePanelRight];
            }
        }
    }

    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        if(velocity.x > 0 || self.showingMenuPanel)
        {// Are you more than halfway? If so, show the panel when done dragging by setting this value to YES (1).
        self.showCenterPanel = abs([sender view].center.x - self.centralViewController.view.frame.size.width/2) > self.centralViewController.view.frame.size.width/2;
        
        // Allow dragging only in x-coordinates by only updating the x-coordinate with translation position.
        [sender view].center = CGPointMake([sender view].center.x + translatedPoint.x, [sender view].center.y);
        [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0,0) inView:self.view];
        
        }
    }
}

- (void)movePanelRight // to show left panel
{
    UIView *childView = [self getMenuView];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.centralViewController.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:nil
                     ];
}

- (void)movePanelToOriginalPosition
{
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.centralViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                            [self resetMainView];
                         }
                     }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma menuviewcontroller delegate
-(void)indexChanged:(MenuViewController *)controller index:(NSInteger)index
{
    self.menuIndex = index;
    [self setupView];
}

#pragma loginviewcontroller delegate
-(void)switchAccount:(LoginViewController *)controller user:(User *)user
{
    NSLog(@"Switch account was called");
}

@end
