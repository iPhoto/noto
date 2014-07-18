//
//  sendgrid.m
//

#import "sendgrid.h"
#import "AFNetworking.h"

NSString * const sgDomain = @"https://api.sendgrid.com/";
NSString * const sgEndpoint = @"api/mail.send.json";

@interface sendgrid ()

@property (strong, nonatomic) NSString *baseURL;

@end

@implementation sendgrid

+ (instancetype)user:(NSString *)apiUser andPass:(NSString *)apiKey{
    //public method that creates the mail object and returns that object
    
    sendgrid *message = [[sendgrid alloc] initWithUser:apiUser andPass:apiKey];
    
    return message;
}


-(id)initWithUser:(NSString *)apiUser andPass:(NSString *)apiKey{
    //private method that creates the mail object
    self = [super init];
    if (self) {
        self.apiUser = apiUser;
        self.apiKey =  apiKey;
        self.headers = [NSMutableDictionary new];
        [self setInlinePhoto:false];
    }
    return self;
}

- (void) attachImage:(UIImage *)img {
    //attaches image to be posted
    if (self.imgs == NULL)
        self.imgs = [[NSMutableArray alloc] init];
    [self.imgs addObject:img];
}


- (NSString *)headerEncode:(NSMutableDictionary *)header{
    //Converts NSDictionary of Header arguments to JSON string
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:header
                                                       options:0
                                                         error:&error];
    NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    
    if (!jsonData)
        NSLog(@"JSON error: %@", error);
    
    
    return JSONString;
    
}

- (void)addCustomHeader:(id)value withKey:(id)key{
    //Adds custom header arguments to header dictionary
    
    [self.headers setObject:value forKey:key];
}

- (void)sendWithWeb
{
    [self sendWithWebUsingSuccessBlock:^(id responseObject) {
        NSLog(@"Success: %@", responseObject);
    } failureBlock:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)sendWithWebUsingSuccessBlock:(void(^)(id responseObject))successBlock failureBlock:(void(^)(NSError *error))failureBlock
{
    [self configureHeader];
    
    //Posting Paramters to server using AFNetworking 2.0
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestOperation *operation = [manager POST:self.baseURL parameters:[self parametersDictionary] constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //if image attachment exists it will post it
        for (int i = 0; i < self.imgs.count; i++)
        {
            UIImage *img = [self.imgs objectAtIndex:i];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [[NSDate alloc] init];
            NSString *formattedDate = [dateFormatter stringFromDate:date];
            
            // TODO: this is bad; we should not assume that there will be at most 1 image
            NSString *filename = [NSString stringWithFormat:@"%@.jpeg", formattedDate];
            NSString *name = [NSString stringWithFormat:@"files[%@.jpeg]", formattedDate];
            NSLog(@"name: %@, Filename: %@", name, filename);
            
            // TODO: this is bad; we shouldn't assume that users want their images compressed
            NSData *imageData = UIImageJPEGRepresentation(img, 0.8);
            [formData appendPartWithFileData:imageData name:name fileName:filename mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(error);
    }];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSNumber *progress = [NSNumber numberWithFloat:((CGFloat) totalBytesWritten / totalBytesExpectedToWrite)];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AFHTTPRequestProgress" object:nil userInfo:[NSDictionary dictionaryWithObject:progress forKey:@"AFHTTPRequestProgress"]];
    }];
}

#pragma mark - Private Methods

- (void)configureHeader
{
    //Items to add to Header and convert to json
    if(self.tolist !=nil){
        [self.headers setObject:self.tolist forKey:@"to"];
        self.to=[self.tolist objectAtIndex:0];
    }
    
    
    if(self.headers !=nil)
        self.xsmtpapi = [self headerEncode:self.headers];
}

- (NSDictionary *)parametersDictionary
{
    //Building up Parameter Dictionary
    NSMutableDictionary *parameters =[NSMutableDictionary dictionaryWithDictionary:@{@"api_user": self.apiUser,
                                                                                     @"api_key": self.apiKey, //required
                                                                                     @"subject":self.subject, //required
                                                                                     @"from":self.from,       //required
                                                                                     @"to":self.to,           //required
                                                                                     @"text":self.text       //required
                                                                                     }];
    
    
    //optional parameters
    if (self.html != nil)
        [parameters setObject:self.html forKey:@"html"];
    
    if (self.xsmtpapi != nil)
        [parameters setObject:self.xsmtpapi forKey:@"x-smtpapi"];
    
    if(self.bcc != nil)
        [parameters setObject:self.bcc forKey:@"bcc"];
    
    if(self.toName != nil)
        [parameters setObject:self.toName forKey:@"toname"];
    
    if(self.fromName != nil)
        [parameters setObject:self.fromName forKey:@"fromname"];
    
    if(self.replyto != nil)
        [parameters setObject:self.replyto forKey:@"replyto"];
    
    if(self.date != nil)
        [parameters setObject:self.date forKey:@"date"];
    
    if(self.inlinePhoto)
    {
        for (int i = 0; i < self.imgs.count; i++)
        {
            
            NSString *filename = [NSString stringWithFormat:@"image_%d.jpeg", i];
            NSString *key = [NSString stringWithFormat:@"content[image_%d.jpeg]", i];
            NSLog(@"name: %@, Filename: %@", key, filename);
            [parameters setObject:filename forKey:key];
            
        }
    }
    
    
    return parameters;
}

#pragma mark - Setter / Getter Overrides

- (NSString *)baseURL
{
    if (!_baseURL) {
        self.baseURL = [NSString stringWithFormat: @"%@%@",sgDomain, sgEndpoint];
    }
    
    return _baseURL;
}

@end
