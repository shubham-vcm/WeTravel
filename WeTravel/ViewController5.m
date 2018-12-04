//
//  ViewController5.m
//  vistara
//
//  Created by Amrit Ghose on 19/11/18.
//  Copyright © 2018 Akanksha. All rights reserved.
//

#import "ViewController5.h"
#import "ViewController6.h"


@interface ViewController5 ()
@property (nonatomic, retain) NSMutableData* responseData;
@property (nonatomic, retain) NSString* parserHeader;
@end

@implementation ViewController5
@synthesize SequenceNumber,SecurityToken,SessionId;


- (void)viewDidLoad {
    [super viewDidLoad];
    
     NSString * soapString = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:link=\"http://wsdl.amadeus.com/2010/06/ws/Link_v1\" xmlns:wbs=\"http://xml.amadeus.com/ws/2009/01/WBS_Session-2.0.xsd\" xmlns:taut=\"http://xml.amadeus.com/TAUTCQ_04_1_1A\"><soapenv:Header><wbs:Session><wbs:SessionId>%@</wbs:SessionId><wbs:SequenceNumber>%@</wbs:SequenceNumber><wbs:SecurityToken>%@</wbs:SecurityToken></wbs:Session></soapenv:Header><soapenv:Body><Ticket_CreateTSTFromPricing><psaList><itemReference><referenceType>TST</referenceType><uniqueReference>1</uniqueReference></itemReference></psaList></Ticket_CreateTSTFromPricing></soapenv:Body></soapenv:Envelope>",self.SessionId,self.SequenceNumber,self.SecurityToken ];
    
    
    NSLog(@"soapString 5====%@",soapString);
    
    NSString *msgLength = [NSString stringWithFormat:@"%li", [soapString length]];
    
    NSString *urlString = [NSString stringWithFormat: @"https://nodeA1.test.webservices.amadeus.com/"];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    [req addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req addValue:@"http://webservices.amadeus.com/1ASIWGRPUK/TAUTCQ_04_1_1A" forHTTPHeaderField:@"SOAPAction"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [soapString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"error5 %@",connectionError);
        }else{
            NSLog(@"data 5===== %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        }
        
        NSXMLParser *xmlparsing = [[NSXMLParser alloc] initWithData:data];
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
    if([segue.identifier isEqualToString:@"show6"]){
        ViewController6 *controller = (ViewController6 *)segue.destinationViewController;
        controller.SequenceNumber = self.SequenceNumber;
        controller.SessionId = self.SessionId;
        controller.SecurityToken = self.SecurityToken;
    }
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
