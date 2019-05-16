//
//  ViewController.m
//  IphoneImages
//
//  Created by Frank Chen on 2019-05-16.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,strong) UIImageView* imageView;
@property (nonatomic,strong) UIButton* button;
@property (nonatomic,strong) NSArray* urlStrings;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    
    NSArray* urlStrings = [[NSArray alloc]initWithObjects:
    @"http://imgur.com/bktnImE.png",
    @"http://imgur.com/zdwdenZ.png",
    @"http://imgur.com/CoQ8aNl.png",
    @"http://imgur.com/2vQtZBb.png",
    @"http://imgur.com/y9MIaCS.png", nil];
    self.urlStrings = urlStrings;
    
    [self loadImageFromWeb:@"http://imgur.com/bktnImE.png"];
}

-(void)loadImageFromWeb:(NSString*)urlString{
    
    NSURL *url = [NSURL URLWithString: urlString]; // 1
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration]; // 2
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration]; // 3
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        NSData* data = [NSData dataWithContentsOfURL:location];
        UIImage* image = [UIImage imageWithData:data];
        
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            self.imageView.image = image;
        }];
        
    }]; // 4
    
    [downloadTask resume]; // 5
}

-(void)setupView{
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    imageView.translatesAutoresizingMaskIntoConstraints = 0;
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    UIButton* button = [[UIButton alloc]initWithFrame:CGRectZero];
    button.translatesAutoresizingMaskIntoConstraints = 0;
    [button setTitle:@"press me to change image" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor blackColor];
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: button];
    self.button = button;
    
    [NSLayoutConstraint activateConstraints:@[
                                              [imageView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:0],
                                              [imageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0],
                                              [imageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0],
                                             [button.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0],
                                              [button.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0],
                                              [button.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor constant:0],
                                              [button.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:0],
                                              ]];
}

-(void)buttonTapped:(UIButton*)sender{
    [self loadImageFromWeb:self.urlStrings[arc4random_uniform(5)]];
}

@end
