//
//  CustomWebViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 16/04/18.
//  Copyright © 2018 Liberty Seguros. All rights reserved.
//

#import "CustomWebViewController.h"
#import "ExtendParcelViewController.h"
@interface CustomWebViewController (){
    NSString *url;
    NSURLRequest *currentUrlRequest;
    NSString *title;
    BOOL shouldDelegateWebView;
 
}

@end

@implementation CustomWebViewController

- (id)initWithUrl:(NSString*)url;
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self = [storyboard instantiateViewControllerWithIdentifier:@"CustomWebViewController"];
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    if (self) {
        [self setUrl:url];
        shouldDelegateWebView = false;
        title = NSLocalizedString(@"AssistenciaVidro", @"");
    }
    return self;
}
- (id)initWithUrlRequest:(NSURLRequest*)urlRequest;
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self = [storyboard instantiateViewControllerWithIdentifier:@"CustomWebViewController"];
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    if (self) {
        currentUrlRequest = urlRequest;
        shouldDelegateWebView = true;
        title = NSLocalizedString(@"PagamentoOnline", @"");
    }
    return self;
}

- (id)initWithLocalFileRequest:(NSURLRequest*)urlRequest;
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self = [storyboard instantiateViewControllerWithIdentifier:@"CustomWebViewController"];
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    if (self) {
        currentUrlRequest = urlRequest;
        shouldDelegateWebView = true;
        title = NSLocalizedString(@"PDF", @"");
    }
    return self;
}


- (id)initWithAssistWithRequest:(NSURLRequest*)urlRequest;
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self = [storyboard instantiateViewControllerWithIdentifier:@"CustomWebViewController"];
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    if (self) {
        currentUrlRequest = urlRequest;
        shouldDelegateWebView = true;
        title = NSLocalizedString(@"Assistencia24hs", @"");
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    if(currentUrlRequest != nil){
        [_webview loadRequest:currentUrlRequest];
        [_webview.scrollView setBounces:NO];
    }else{
        [_webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
    if(shouldDelegateWebView){
        [_webview setDelegate:self];
    }
    
    [self.view.window setRootViewController:self];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = title;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setUrl:(NSString*) toload{
    url = toload;

}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [_activity startAnimating];
    [_activity setHidden:NO];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [_activity stopAnimating];
    [_activity setHidden:YES];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [_activity stopAnimating];
    [_activity setHidden:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"URL %@", [[request URL] absoluteString]);
    if ([[[request URL] absoluteString]  containsString:@"?status=pagok"]) {
    
        dispatch_async(dispatch_get_main_queue(),^{
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNull null] forKey:@"payment"];
            [[NSNotificationCenter defaultCenter] postNotificationName: PaymentExtendedObserver object:nil userInfo:userInfo];
        });
        
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }else if([[[request URL] absoluteString]  containsString:@"?status=cancel"]){
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Operação foi cancelada" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [controller addAction:[UIAlertAction actionWithTitle:@"Fechar" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           [self.navigationController popViewControllerAnimated:YES];
        }]];
        [self presentViewController:controller animated:YES completion:nil];
        
        return NO;
    }else if([[[request URL] absoluteString]  containsString:@"#quit"]){
        
        [self.navigationController popViewControllerAnimated:YES];
        
        return NO;
    }

    return YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSURL *urlPath = [info valueForKey:UIImagePickerControllerReferenceURL];
    UIImage *cameraImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    NSData *myData = UIImagePNGRepresentation(cameraImage);
//    [self.webview loadData:myData MIMEType:@"image/png" textEncodingName:nil baseURL:nil];
//    [self.picker dismissViewControllerAnimated:YES completion:nil];
 }


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
