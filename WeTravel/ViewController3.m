//
//  ViewController3.m
//  vistara
//
//  Created by Amrit Ghose on 15/11/18.
//  Copyright © 2018 Akanksha. All rights reserved.
//

#import "ViewController3.h"
#import "ViewController4.h"
#import "XMLReader.h"


@interface ViewController3 ()

@property (nonatomic, retain) NSString* parserHeader;

@end

NSMutableDictionary* xmlDict1;
NSMutableDictionary * array1;


@implementation ViewController3
@synthesize SequenceNumber,SecurityToken,SessionId,finalDictionary;



- (void)viewDidLoad {
    [super viewDidLoad];
    xmlDict1 = [[NSMutableDictionary alloc]init];
    array1 = [[NSMutableDictionary alloc]init];
    [self PNR_AddMultiElementsApiCall];
    // Do any additional setup after loading the view.
    
   
}

-(void)PNR_AddMultiElementsApiCall{
    NSString * soapString2 = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:wbs=\"http://xml.amadeus.com/ws/2009/01/WBS_Session-2.0.xsd\" xmlns:pnr=\"http://xml.amadeus.com/PNRADD_16_1_1A\"><soapenv:Header><wbs:Session><wbs:SessionId>%@</wbs:SessionId><wbs:SequenceNumber>%@</wbs:SequenceNumber><wbs:SecurityToken>%@</wbs:SecurityToken></wbs:Session></soapenv:Header><soapenv:Body><PNR_AddMultiElements><pnrActions><optionCode>0</optionCode></pnrActions><travellerInfo><elementManagementPassenger><reference><qualifier>PR</qualifier><number>1</number></reference><segmentName>NM</segmentName></elementManagementPassenger><passengerData><travellerInformation><traveller><surname>Singh</surname><quantity>1</quantity></traveller><passenger><firstName>Akanksha</firstName><type>ADT</type></passenger></travellerInformation></passengerData></travellerInfo><originDestinationDetails><originDestination><origin>%@</origin><destination>%@</destination></originDestination><itineraryInfo><elementManagementItinerary><reference><qualifier>SR</qualifier><number>1</number></reference><segmentName>AIR</segmentName></elementManagementItinerary><airAuxItinerary><travelProduct><product><depDate>%@</depDate></product><boardpointDetail><cityCode>%@</cityCode></boardpointDetail><offpointDetail><cityCode>%@</cityCode></offpointDetail><company><identification>UK</identification></company><productDetails><identification>%@</identification><classOfService>X</classOfService></productDetails></travelProduct><messageAction><business><function>1</function></business></messageAction><relatedProduct><quantity>1</quantity><status>NN</status></relatedProduct><selectionDetailsAir><selection><option>P10</option></selection></selectionDetailsAir></airAuxItinerary></itineraryInfo></originDestinationDetails><dataElementsMaster><marker1/><dataElementsIndiv><elementManagementData><segmentName>FV</segmentName></elementManagementData><ticketingCarrier><carrier><airlineCode>UK</airlineCode></carrier></ticketingCarrier></dataElementsIndiv><dataElementsIndiv><elementManagementData><segmentName>FP</segmentName></elementManagementData><formOfPayment><fop><identification>MS</identification></fop></formOfPayment></dataElementsIndiv><dataElementsIndiv><elementManagementData><segmentName>TK</segmentName></elementManagementData><ticketElement><ticket><indicator>OK</indicator></ticket></ticketElement></dataElementsIndiv><dataElementsIndiv><elementManagementData><reference><qualifier>OT</qualifier><number>1</number></reference><segmentName>SSR</segmentName></elementManagementData><serviceRequest><ssr><type>OTHS</type><companyId>UK</companyId><freetext>design SR exe/DOJ 14aug18/emp no 455</freetext></ssr></serviceRequest></dataElementsIndiv><dataElementsIndiv><elementManagementData><segmentName>SK</segmentName></elementManagementData><serviceRequest><ssr><type>STFS</type><companyId>UK</companyId><freetext>SN-455/DJ-14aug18</freetext></ssr></serviceRequest></dataElementsIndiv><dataElementsIndiv><elementManagementData><segmentName>SK</segmentName></elementManagementData><serviceRequest><ssr><type>STFD</type><companyId>UK</companyId><freetext>op-03/oc-y/rp-09/rc-s</freetext></ssr></serviceRequest></dataElementsIndiv><dataElementsIndiv><elementManagementData><segmentName>FT</segmentName></elementManagementData><tourCode><freeFormatTour><freetext>cord000309</freetext></freeFormatTour></tourCode></dataElementsIndiv><dataElementsIndiv><elementManagementData><reference><qualifier>OT</qualifier><number>1</number></reference><segmentName>AP</segmentName></elementManagementData><freetextData><freetextDetail><subjectQualifier>3</subjectQualifier><type>7</type></freetextDetail><longFreetext>9990056732</longFreetext></freetextData></dataElementsIndiv><dataElementsIndiv><elementManagementData><reference><qualifier>OT</qualifier><number>1</number></reference><segmentName>AP</segmentName></elementManagementData><freetextData><freetextDetail><subjectQualifier>3</subjectQualifier><type>P02</type></freetextDetail><longFreetext>aksingh20feb@gmail.com</longFreetext></freetextData></dataElementsIndiv></dataElementsMaster></PNR_AddMultiElements></soapenv:Body></soapenv:Envelope>",self.SessionId,self.SequenceNumber,self.SecurityToken,[finalDictionary objectForKey:@"departureLocation"],[finalDictionary objectForKey:@"arrivalLocation"] ,[finalDictionary objectForKey:@"departureDate"],[finalDictionary objectForKey:@"departureLocation"],[finalDictionary objectForKey:@"arrivalLocation"],[finalDictionary objectForKey:@"flightIdentification"]];
    
    NSLog(@"soapString 2====%@",soapString2);
    
    NSString *msgLength = [NSString stringWithFormat:@"%li", [soapString2 length]];
    
    NSString *urlString = [NSString stringWithFormat: @"https://nodeA1.test.webservices.amadeus.com/"];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    [req addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req addValue:@"http://webservices.amadeus.com/1ASIWGRPUK/PNRADD_15_1_1A" forHTTPHeaderField:@"SOAPAction"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [soapString2 dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"error %@",connectionError);
        }else{
            xmlDict1 = [XMLReader dictionaryForXMLData:data error:&connectionError];
            NSLog(@"xmlDict is here %@",xmlDict1);
            
            array1 = xmlDict1[@"soapenv:Envelope"][@"soapenv:Body"][@"PNR_Reply"][@"originDestinationDetails"][@"itineraryInfo"][@"flightDetail"];
            
            NSLog(@"array ==== %@",array1);
            NSMutableDictionary * flightDetails = [[NSMutableDictionary alloc]init];
            [flightDetails setValue:array1[@"arrivalStationInfo"][@"terminal"][@"text"] forKey:@"arrivalStationInfo"];
             [flightDetails setValue:array1[@"departureInformation"][@"departTerminal"][@"text"] forKey:@"departureInformation"];
            [[NSUserDefaults standardUserDefaults] setObject:flightDetails forKey:@"terminalDetails"];
            
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
    if([segue.identifier isEqualToString:@"show4"]){
        ViewController3 *controller = (ViewController4 *)segue.destinationViewController;
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
