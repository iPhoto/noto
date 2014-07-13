//
//  Note.h
//  Selfie
//
//  Created by Daniel Suo on 6/30/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "Note.h"

@implementation Note

// TODO: refactor initialization and validation into note creation
- (instancetype) init {
    self = [super init];
    if (self) {
        _toEmail = @"";
        _fromEmail = @"";
        _subject = [NSString stringWithFormat:@"[%@] No Subject", [Utilities appName]];
        _body = [NSString stringWithFormat:@"\n\n%@", [Utilities getSettingsValue:kSettingsSignatureKey]];
    }
    
    return self;
}

- (instancetype) initFromDictionary:(NSDictionary *)dict {
    Note *note = [self initWithToEmail:[dict valueForKey:kQueueNoteDictionaryToEmail]
                             fromEmail:[dict valueForKey:kQueueNoteDictionaryFromEmail]
                               subject:[dict valueForKey:kQueueNoteDictionarySubject]
                                  body:[dict valueForKey:kQueueNoteDictionaryBody]];
    
    NSString *imagePath = [dict valueForKey:kQueueNoteDictionaryImagePath];
    if (imagePath) {
        self.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath]];
    }
    
    return note;
}

- (instancetype) initWithToEmail:(NSString *)toEmail
                      fromEmail:(NSString *)fromEmail
                        subject:(NSString *)subject
                           body:(NSString *)body {
    self = [self init];
    if (self) {
        _toEmail = toEmail;
        _fromEmail = fromEmail;
        _subject = subject;
        _body = body;
    }
    return self;
}

- (instancetype) initWithString:(NSString *) message
                     direction:(SwipeDirection) direction {
    
    self = [self init];
    
    NSString *toEmail = [Utilities getEmailWithDirection:direction];
    NSString *fromEmail = toEmail;
    
    if (toEmail) {
        
        if ([Utilities isEmptyString:message]) {
            self.toEmail = toEmail;
            self.fromEmail = fromEmail;
            return self;
        }
        
        NSMutableString *subject = [[Note getNoteSubject:message] mutableCopy];
        NSMutableString *body;
        NSString *signature = (NSString *)[Utilities getSettingsValue:kSettingsSignatureKey];
        NSString *subjectPrefix = (NSString *)[Utilities getSettingsValue:kSettingsSubjectPrefixKey];
        
        // Build body
        body = [message mutableCopy];
        
        if (![Utilities isEmptyString:signature]) {
            [body appendString:@"\n\n"];
            [body appendString: signature];
        }
        
        if (![Utilities isEmptyString:subjectPrefix]) {
            subject = [[NSString stringWithFormat:@"%@ %@", subjectPrefix, subject] mutableCopy];
        }
        
        return [self initWithToEmail:toEmail fromEmail:fromEmail subject:subject body:body];
    }
    return self;
}

- (void) send {
    [self sendWithCompletionHandler:nil];
}

- (void) sendWithCompletionHandler:(void (^)(UIBackgroundFetchResult)) completionHandler {
    sendgrid *msg = [sendgrid user:SGUsername andPass:SGPassword];
    msg.to = self.toEmail;
    msg.from = self.fromEmail;
    msg.subject = [self.subject substringToIndex:MIN(kMaxSubjectLength, [self.subject length])];
    msg.text = self.body;
    msg.fromName = [Utilities appName];
    
    if (self.image) {
        [msg attachImage:self.image];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // List of all system sounds
    // https://github.com/TUNER88/iOSSystemSoundsLibrary
    AudioServicesPlaySystemSound (1001);
    
    [msg sendWithWebUsingSuccessBlock:^(id responseObject) {
        NSLog(@"Success!: %@", self.subject);
        
        [Radio postNotificationName:kNoteSendSuccessNotification object:nil];
        
        if (completionHandler) {
            completionHandler(UIBackgroundFetchResultNewData);
        }
        
        [self onComplete];
    } failureBlock:^(NSError *error) {
        NSLog(@"Error sending email: %@", error);
        
        [Radio postNotificationName:kNoteSendFailNotification object:nil];
        
        [Queue enqueue:self];
        
        if (completionHandler) {
            completionHandler(UIBackgroundFetchResultFailed);
        }
        
        [self onComplete];
        
        // TODO: Handle Sendgrid error codes here. Send NSNotifications to trigger UI events.
    }];
}

- (NSDictionary *) toDictionary {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]
                          initWithObjects:@[self.toEmail, self.fromEmail, self.subject, self.body]
                          forKeys:@[kQueueNoteDictionaryToEmail, kQueueNoteDictionaryFromEmail, kQueueNoteDictionarySubject, kQueueNoteDictionaryBody]];
    if (self.image) {
        // Get image data. Here you can use UIImagePNGRepresentation if you need transparency
        NSData *imageData = UIImageJPEGRepresentation(self.image, 1);
        
        // Get image path in user's folder and store file with name image_CurrentTimestamp.jpg (see documentsPathForFileName below)
        NSString *imagePath = [self documentsPathForFileName:[NSString stringWithFormat:@"image_%f.jpg", [NSDate timeIntervalSinceReferenceDate]]];
        
        // Write image data to user's folder
        [imageData writeToFile:imagePath atomically:YES];
        
        // Store path in NSUserDefaults
        [dict setObject:imagePath forKey:kQueueNoteDictionaryImagePath];
    }
    
    return dict;
}

// TODO: refactor to respond to notifications
- (void) onComplete {
    [UIApplication sharedApplication].applicationIconBadgeNumber = [Queue count];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (NSString *) documentsPathForFileName:(NSString *)name {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name];
}

// TODO: should make this reusable
+ (NSString *) getNoteSubject:(NSString *) text {
    NSArray *lines = [[Utilities trimWhiteSpace:text] componentsSeparatedByString:@"\n"];
    
    if ([lines count] > 0) {
        return lines[0];
    } else {
        return nil;
    }
}

+ (BOOL) isValidNote:(NSString *) text {
    // Ignores email addresses; just evalutes the text of the note
    return ![Utilities isEmptyString:[Note getNoteSubject:text]];
}

@end
