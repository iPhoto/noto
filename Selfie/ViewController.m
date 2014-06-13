//
//  ViewController.m
//  Selfie
//
//  Created by Daniel Suo on 6/12/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "ViewController.h"
#import "Mailgun.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *text;
@property (weak, nonatomic) NSString *message;
@end

@implementation ViewController

- (NSString *) message {
    if (!_message) {
        _message = self.text.text;
    }
    
    return _message;
}

- (IBAction)swipeRight:(UISwipeGestureRecognizer *)sender {
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        NSArray *lines = [self.message componentsSeparatedByString:@"\n"];
        NSString *subject = lines[0];
        NSString *body = [[lines subarrayWithRange:NSMakeRange(1, [lines count] - 1)] componentsJoinedByString:@"\n"];
        
        Mailgun *mailgun = [Mailgun clientWithDomain:@"the-leather-apron-club.mailgun.org"
                                              apiKey:@"key-2w1t601cqh-c32-dc45lqmv0fqspphk7"];
        
        [mailgun sendMessageTo:@"Daniel Suo <danielsuo@gmail.com>"
                          from:@"Excited User <someone@sample.org>"
                       subject:subject
                          body:body];
        
        NSLog(@"You got the right guy.");
    }
}


@end
