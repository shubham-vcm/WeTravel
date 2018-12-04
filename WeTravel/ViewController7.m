//
//  ViewController7.m
//  vistara
//
//  Created by Amrit Ghose on 19/11/18.
//  Copyright © 2018 Akanksha. All rights reserved.
//

#import "ViewController7.h"
#import "ViewController8.h"


@interface ViewController7 ()
@property (nonatomic, retain) NSMutableData* responseData;
@property (nonatomic, retain) NSString* parserHeader;
@end

@implementation ViewController7
@synthesize SequenceNumber,SecurityToken,SessionId,_departureLbl,_departureDate,_departureTimeLbl,_departureTerminal,_arrivalLbl,_arrivalDate,_arrivalTimeLbl,_arrivalTerminal,_flightPnr,_guestName;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * soapString = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:link=\"http://wsdl.amadeus.com/2010/06/ws/Link_v1\" xmlns:wbs=\"http://xml.amadeus.com/ws/2009/01/WBS_Session-2.0.xsd\" xmlns:hsf=\"http://xml.amadeus.com/HSFREQ_07_3_1A\"><soapenv:Header><wbs:Session><wbs:SessionId>%@</wbs:SessionId><wbs:SequenceNumber>%@</wbs:SequenceNumber><wbs:SecurityToken>%@</wbs:SecurityToken></wbs:Session></soapenv:Header><soapenv:Body><DocIssuance_IssueTicket><optionGroup><switches><statusDetails><indicator>ET</indicator></statusDetails></switches></optionGroup></DocIssuance_IssueTicket></soapenv:Body></soapenv:Envelope>",self.SessionId,self.SequenceNumber,self.SecurityToken ];
    
    
    NSLog(@"soapString 7====%@",soapString);
    
    NSString *msgLength = [NSString stringWithFormat:@"%li", [soapString length]];
    
    NSString *urlString = [NSString stringWithFormat: @"https://nodeA1.test.webservices.amadeus.com/"];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    [req addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req addValue:@"http://webservices.amadeus.com/1ASIWGRPUK/TTKTIQ_15_1_1A" forHTTPHeaderField:@"SOAPAction"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [soapString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"error7 %@",connectionError);
        }else{
            NSLog(@"data 7===== %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        }
        
        NSXMLParser *xmlparsing = [[NSXMLParser alloc] initWithData:data];
        [xmlparsing setDelegate:(id)self];
        BOOL STATUS = [xmlparsing parse];
        
        if (STATUS)
        {
            NSLog(@"YES");
            [self updateUI];
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

-(void)updateUI{
    
    NSMutableDictionary* flightDictionary = [[NSMutableDictionary alloc]init];
    flightDictionary = [[NSUserDefaults standardUserDefaults]valueForKey:@"flightDetails"];
    dispatch_async(dispatch_get_main_queue(), ^{
    self._departureLbl.text = [flightDictionary objectForKey:@"departureLocation"];
    self._arrivalLbl.text = [flightDictionary objectForKey:@"arrivalLocation"];
    self._departureDate.text = [self dateFormatter:[flightDictionary objectForKey:@"departureDate"]];
    self._arrivalDate.text = [self dateFormatter:[flightDictionary objectForKey:@"arrivalDate"]];
    self._departureTerminal.text = [@"Terminal "stringByAppendingString:[flightDictionary objectForKey:@"departureTerminal"]];
    self._arrivalTerminal.text = [@"Terminal "stringByAppendingString:[flightDictionary objectForKey:@"arrivalTerminal"]];
    self._departureTimeLbl.text = [self ConvertTimeFormate:[flightDictionary objectForKey:@"departureTime"]];
    self._arrivalTimeLbl.text = [self ConvertTimeFormate:[flightDictionary objectForKey:@"arrivalTime"]];
           });
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"show8"]){
        ViewController8 *controller = (ViewController8 *)segue.destinationViewController;
        controller.SequenceNumber = self.SequenceNumber;
        controller.SessionId = self.SessionId;
        controller.SecurityToken = self.SecurityToken;
    }
}
-(NSString*)ConvertTimeFormate:(NSString*)timeStr{
    
    NSString * firstChar = [timeStr substringToIndex:NSMaxRange([timeStr rangeOfComposedCharacterSequenceAtIndex:1])];
    NSString *secondChar = [timeStr substringWithRange:NSMakeRange(2,2)];
    
    NSString *firstLetter = [firstChar substringToIndex:1];
    
    int firstTime;
    
    // This code is because we don't need to show "0"
    if ([firstLetter isEqualToString:@"0"])
    {
        firstLetter = [firstChar substringFromIndex:1];
    }
    else
    {
        firstLetter = firstChar;
    }
    
    firstTime = [firstLetter intValue];
    NSString * finalTime;
    if (firstTime>=12) {
        if (firstTime==12)
        {
            finalTime = [[[[NSString stringWithFormat:@"%i", firstTime]stringByAppendingString:@":"]stringByAppendingString: secondChar] stringByAppendingString:@" PM"];
           
            
        }
        else
        {
            firstTime -= 12;
            finalTime = [[[[NSString stringWithFormat:@"%i", firstTime]stringByAppendingString:@":"]stringByAppendingString: secondChar] stringByAppendingString:@" PM"];
        }
    }
    else
    {
        finalTime = [[[[NSString stringWithFormat:@"%i", firstTime]stringByAppendingString:@":"]stringByAppendingString: secondChar] stringByAppendingString:@" AM"];
        
    }
    
    return finalTime;
}

-(NSString*)dateFormatter:(NSString*)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MMM"];
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    return formattedDateString;
    
    
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
