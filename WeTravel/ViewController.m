//
//  ViewController.m
//  vistara
//
//  Created by Amrit Ghose on 11/11/18.
//  Copyright © 2018 Akanksha. All rights reserved.
//

#import "ViewController.h"
#import "ViewController2.h"
@interface ViewController ()<NSXMLParserDelegate>

@property (nonatomic, retain) NSMutableData* responseData;
@property (nonatomic, retain) NSString* parserHeader;
@property (nonatomic, retain) NSString* SequenceNumber;
@property (nonatomic, retain) NSString* SecurityToken;
@property (nonatomic, retain) NSString* SessionId;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self serviceForSecurity_Autjenticate];
    //  [self ServiceforAir_MultiAvailibility];
    
}

-(void)serviceForSecurity_Autjenticate
{
    NSString * soapString = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:wbs=\"http://xml.amadeus.com/ws/2009/01/WBS_Session-2.0.xsd\" xmlns:vls=\"http://xml.amadeus.com/VLSSLQ_06_1_1A\"><soapenv:Header><wbs:Session><wbs:SessionId></wbs:SessionId><wbs:SequenceNumber/><wbs:SecurityToken/></wbs:Session></soapenv:Header><soapenv:Body><vls:Security_Authenticate><vls:userIdentifier><vls:originIdentification><vls:sourceOffice>DELUK08DT</vls:sourceOffice></vls:originIdentification><vls:originatorTypeCode>U</vls:originatorTypeCode><vls:originator>111WS</vls:originator></vls:userIdentifier><vls:dutyCode><vls:dutyCodeDetails><vls:referenceQualifier>DUT</vls:referenceQualifier><vls:referenceIdentifier>SU</vls:referenceIdentifier></vls:dutyCodeDetails></vls:dutyCode><vls:systemDetails><vls:workstationId/><vls:organizationDetails><vls:organizationId>UK</vls:organizationId></vls:organizationDetails><vls:idQualifier/></vls:systemDetails><vls:passwordInfo><vls:dataLength>9</vls:dataLength><vls:dataType>E</vls:dataType><vls:binaryData>dmlzdGFyYTAy</vls:binaryData></vls:passwordInfo></vls:Security_Authenticate></soapenv:Body></soapenv:Envelope>"];
    
    
    //  NSLog(@"soapString %@",soapString);
    
    NSString *msgLength = [NSString stringWithFormat:@"%li", [soapString length]];
    
    NSString *urlString = [NSString stringWithFormat: @"https://nodeA1.test.webservices.amadeus.com"];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    [req addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req addValue:@"http://webservices.amadeus.com/1ASIWGRPUK/VLSSLQ_06_1_1A" forHTTPHeaderField:@"SOAPAction"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [soapString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"error %@",connectionError);
        }else{
            NSLog(@"data %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        }
        
        
        
        
        NSString *responseString = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
        NSLog(@"respose%@",responseString);
        NSError *error = nil;
        NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error: &error];
        NSXMLParser *xmlparsing = [[NSXMLParser alloc] initWithData:data];
        NSLog(@"jsonData ====%@",JSON);
        NSLog(@"xmlparsing =====%@",xmlparsing);
        [xmlparsing setDelegate:(id)self];
        BOOL STATUS = [xmlparsing parse];
        
        if (STATUS)
        {
            NSLog(@"YES");
        }
        else
        {
            NSLog(@"NO");
        }
    }];
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if ([self.parserHeader isEqualToString:@"awss:SessionId"]){
        self.SessionId = string;
        NSLog(@"SessionId ====%@",self.SessionId);
    }
    if ([self.parserHeader isEqualToString:@"awss:SequenceNumber"]){
        self.SequenceNumber = string;
        NSLog(@"SequenceNumber ====%@",self.SequenceNumber);
    }
    if ([self.parserHeader isEqualToString:@"awss:SecurityToken"]){
        self.SecurityToken = string;
        NSLog(@"SecurityToken ====%@",self.SecurityToken);
    }
    
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.parserHeader = elementName;
    NSLog(@"elementName is here %@",elementName);
    NSLog(@"attributeDict is here %@",attributeDict);
    
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    // [SVProgressHUD dismiss];
    UIAlertView *TryAgainAlert = [[UIAlertView alloc]
                                  initWithTitle:@"iDeals"
                                  message:@"Opps... Something went wrong, please try again after some time!"
                                  delegate:self
                                  cancelButtonTitle:@"OK"otherButtonTitles:nil];
    [TryAgainAlert show];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"show2"]){
        ViewController2 *controller = (ViewController2 *)segue.destinationViewController;
        controller.SequenceNumber = self.SequenceNumber;
        controller.SessionId = self.SessionId;
        controller.SecurityToken = self.SecurityToken;
    }
}

@end
