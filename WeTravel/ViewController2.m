//
//  ViewController2.m
//  vistara
//
//  Created by Amrit Ghose on 13/11/18.
//  Copyright © 2018 Akanksha. All rights reserved.
//

#import "ViewController2.h"
#import "ViewController3.h"
#import "flightListingCell.h"
#import "XMLReader.h"

@interface ViewController2 ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) NSMutableData* responseData;
@property (nonatomic, retain) NSString* parserHeader;
@property (weak, nonatomic) IBOutlet UITableView *_tableView;

@property (weak, nonatomic) IBOutlet UIView *_V1;
@property (weak, nonatomic) IBOutlet UIView *_V2;
@property (weak, nonatomic) IBOutlet UIView *_V3;
@property (weak, nonatomic) IBOutlet UIView *_V4;
@property (weak, nonatomic) IBOutlet UILabel *_lblFlightLocation;

-(NSArray *)arrayBySplittingWithMaximumSize:(NSUInteger)size
                                    options:(NSStringEnumerationOptions) option;


@end
NSMutableDictionary *flightInfo;
NSMutableDictionary* xmlDict;
NSMutableArray * array;
NSMutableDictionary * basicFlightInfo;
NSMutableDictionary * additionalFlightInfo;
NSMutableArray * arrivalDate;
NSMutableArray * arrivalTime;
NSMutableArray * departureDate;
NSMutableArray * departureTime;
NSMutableArray * flightIdentification;
NSMutableArray * marketingCompany;
NSMutableArray * legDuration;
NSMutableArray * numberOfStops;
NSMutableArray * availabilityStatus;
NSMutableArray * flightNumber;
NSMutableArray * departureTerminal;
NSMutableArray * arrivalTerminal;

NSString * selectedDate;
NSString * arrivalLocation;
NSString * departureLocation;

NSMutableDictionary *finalDictionary;
@implementation ViewController2
@synthesize SequenceNumber,SecurityToken,SessionId;


- (void)viewDidLoad {
    flightInfo = [[NSMutableDictionary alloc]init];
    [super viewDidLoad];
    [self roundedCorner];
    self._tableView.delegate = self;
    self._tableView.dataSource = self;
    xmlDict = [[NSMutableDictionary alloc]init];
    array = [[NSMutableArray alloc]init];
    arrivalDate = [[NSMutableArray alloc]init];
    arrivalTime = [[NSMutableArray alloc]init];
    departureDate = [[NSMutableArray alloc]init];
    departureTime = [[NSMutableArray alloc]init];
    flightIdentification = [[NSMutableArray alloc]init];
    marketingCompany = [[NSMutableArray alloc]init];
    legDuration = [[NSMutableArray alloc]init];
    numberOfStops = [[NSMutableArray alloc]init];
    availabilityStatus   = [[NSMutableArray alloc]init];
    finalDictionary = [[NSMutableDictionary alloc]init];
    flightNumber = [[NSMutableArray alloc]init];
    departureTerminal = [[NSMutableArray alloc]init];
    arrivalTerminal = [[NSMutableArray alloc]init];
    
    
    selectedDate = @"071218";
    [self ServiceforAir_MultiAvailibility];
    // Do any additional setup after loading the view.
}
-(void)ServiceforAir_MultiAvailibility
{
   
    
    NSString * soapString = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"xmlns:wbs=\"http://xml.amadeus.com/ws/2009/01/WBS_Session-2.0.xsd\"xmlns:sat=\"http://xml.amadeus.com/SATRQT_16_1_1A\"><soapenv:Header><wbs:Session><wbs:SessionId>%@</wbs:SessionId><wbs:SequenceNumber>%@</wbs:SequenceNumber><wbs:SecurityToken>%@</wbs:SecurityToken></wbs:Session></soapenv:Header><soapenv:Body><sat:Air_MultiAvailability><sat:messageActionDetails><sat:functionDetails><sat:actionCode>48</sat:actionCode></sat:functionDetails></sat:messageActionDetails><sat:requestSection><sat:availabilityProductInfo><sat:availabilityDetails><sat:departureDate>%@</sat:departureDate></sat:availabilityDetails><sat:departureLocationInfo><sat:cityAirport>BOM</sat:cityAirport></sat:departureLocationInfo><sat:arrivalLocationInfo><sat:cityAirport>DEL</sat:cityAirport></sat:arrivalLocationInfo></sat:availabilityProductInfo><sat:availabilityOptions><sat:typeOfRequest>18</sat:typeOfRequest></sat:availabilityOptions></sat:requestSection></sat:Air_MultiAvailability></soapenv:Body></soapenv:Envelope>",self.SessionId,self.SequenceNumber,self.SecurityToken,selectedDate ];
    
    NSLog(@"soapString 1====%@",soapString);
    
    NSString *msgLength = [NSString stringWithFormat:@"%li", [soapString length]];
    
    NSString *urlString = [NSString stringWithFormat: @"https://nodeA1.test.webservices.amadeus.com/"];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    [req addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req addValue:@"http://webservices.amadeus.com/1ASIWGRPUK/SATRQT_16_1_1A" forHTTPHeaderField:@"SOAPAction"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [soapString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"error %@",connectionError);
        }else{
          
            xmlDict = [XMLReader dictionaryForXMLData:data error:&connectionError];
            NSLog(@"xmlDict is here %@",xmlDict);
           
            array = xmlDict[@"soapenv:Envelope"][@"soapenv:Body"][@"Air_MultiAvailabilityReply"][@"singleCityPairInfo"][@"flightInfo"];
        
            NSDictionary * addi = [[NSDictionary alloc]init];
            for (int i= 0; i< array.count; i++){
                addi = [array[i] objectForKey:@"basicFlightInfo"];
                [arrivalDate addObject: addi[@"flightDetails"][@"arrivalDate"][@"text"]];
                [arrivalTime addObject: addi[@"flightDetails"][@"arrivalTime"][@"text"]];
                [departureDate addObject: addi[@"flightDetails"][@"departureDate"][@"text"]];
                [departureTime addObject: addi[@"flightDetails"][@"departureTime"][@"text"]];
                [legDuration addObject: array[i][@"additionalFlightInfo"][@"flightDetails"][@"legDuration"][@"text"]];
                 [arrivalTerminal addObject: array[i][@"additionalFlightInfo"][@"arrivalStation"][@"terminal"][@"text"]];
                 [departureTerminal addObject: array[i][@"additionalFlightInfo"][@"departureStation"][@"terminal"][@"text"]];
                arrivalLocation = addi[@"arrivalLocation"][@"cityAirport"][@"text"];
                departureLocation = addi[@"departureLocation"][@"cityAirport"][@"text"];
                
               
                NSString* val = array[i][@"additionalFlightInfo"][@"flightDetails"][@"numberOfStops"][@"text"];
                int value = [val integerValue];
                NSMutableArray * infoOnclass = [[NSMutableArray alloc]init];
                infoOnclass = array[i][@"infoOnClasses"];
                
                for (int i = 0; i < infoOnclass.count; i++){
                   NSString* serviceClass = infoOnclass[i][@"productClassDetail"][@"serviceClass"][@"text"];
                    if ([serviceClass rangeOfString:@"X"].location == NSNotFound) {
                      
                    } else {
                        NSString* Status = infoOnclass[i][@"productClassDetail"][@"availabilityStatus"][@"text"];
                        [availabilityStatus addObject:Status];
                        break;
                       // [availabilityStatus addObject:@"S"];
                    }
                }
               
                [numberOfStops addObject: [self totalStop:value]];
                NSString * flightNo = addi[@"flightIdentification"][@"number"][@"text"];
                [flightNumber addObject:flightNo];
                NSString * identificationNo = addi[@"marketingCompany"][@"identifier"][@"text"];
                [flightIdentification addObject: [[identificationNo stringByAppendingString:@" "]stringByAppendingString:flightNo]];

                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self._tableView reloadData];
                  self._lblFlightLocation.text = [[departureLocation stringByAppendingString:@"-"]stringByAppendingString:arrivalLocation];
                // Your UI update code here
            });
            
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
  //  if ([self.parserHeader isEqualToString:@"flightInfo"]){
//        flightInfo = attributeDict;
//        NSLog(@"flightInfo ====%@",flightInfo);
 //   }
    
//    NSLog(@"elementName is here %@",elementName);
//    NSLog(@"attributeDict is here %@",attributeDict);
    
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
    if([segue.identifier isEqualToString:@"show3"]){
        ViewController3 *controller = (ViewController3 *)segue.destinationViewController;
        controller.SequenceNumber = self.SequenceNumber;
        controller.SessionId = self.SessionId;
        controller.SecurityToken = self.SecurityToken;
        controller.finalDictionary = finalDictionary;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    flightListingCell *cell = (flightListingCell *)[tableView dequeueReusableCellWithIdentifier:@"flightListingCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"flightListingCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell._departureTime.text = [self ConvertTimeFormate:[departureTime objectAtIndex:indexPath.row]];
    cell._arrivalTime.text = [self ConvertTimeFormate:[arrivalTime objectAtIndex:indexPath.row]];
    cell._duration.text = [self ConvertDurationFormate:[legDuration objectAtIndex:indexPath.row]];
    cell._flighNo.text = [flightIdentification objectAtIndex:indexPath.row];
    cell._flightType.text = [numberOfStops objectAtIndex:indexPath.row];
    
    cell._btnAvailability.layer.cornerRadius = 14; 
    cell._btnAvailability.clipsToBounds = YES;
    if ([[availabilityStatus objectAtIndex:indexPath.row] isEqualToString:@"S"]){
          [cell._btnAvailability setTitle:@"STANDBY" forState:UIControlStateNormal];
        cell._btnAvailability.backgroundColor = UIColor.orangeColor;
        cell.btnWidth.constant =  75;
    }
    else{
    [cell._btnAvailability setTitle:@"CNF Availibility" forState:UIControlStateNormal];
    }
    return cell;
}


// Default is 1 if not implemented
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}




#pragma mark - TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  //  NSLog(@"Section:%d Row:%d selected and its data is %@",indexPath.section,indexPath.row,cell.textLabel.text);
    
    [finalDictionary setValue:arrivalLocation forKey:@"arrivalLocation"];
    [finalDictionary setValue:departureLocation forKey:@"departureLocation"];
    [finalDictionary setValue:departureDate[indexPath.row] forKey:@"departureDate"];
    [finalDictionary setValue:arrivalDate[indexPath.row] forKey:@"arrivalDate"];
    [finalDictionary setValue:arrivalTerminal[indexPath.row] forKey:@"arrivalTerminal"];
    [finalDictionary setValue:departureTerminal[indexPath.row] forKey:@"departureTerminal"];
    [finalDictionary setValue:flightNumber[indexPath.row] forKey:@"flightIdentification"];
    [finalDictionary setValue:arrivalTime[indexPath.row] forKey:@"arrivalTime"];
    [finalDictionary setValue:departureTime[indexPath.row] forKey:@"departureTime"];
     [[NSUserDefaults standardUserDefaults] setObject:finalDictionary forKey:@"flightDetails"];
    
   
    [self performSegueWithIdentifier:@"show3" sender:indexPath];

}

-(void)roundedCorner{
    self._V1.layer.cornerRadius = 15;
    self._V2.layer.cornerRadius = 15;
    self._V3.layer.cornerRadius = 15;
    self._V4.layer.cornerRadius = 15;
    
    self._V1.layer.borderColor = UIColor.brownColor.CGColor;
    self._V2.layer.borderColor = UIColor.brownColor.CGColor;
    self._V3.layer.borderColor = UIColor.brownColor.CGColor;
    self._V4.layer.borderColor = UIColor.brownColor.CGColor;
}

-(NSString* )totalStop:(int )stops{
    switch (stops){
        case 0:
            return @"Non-Stop";
        case 1:
            return @"Connecting Flight";
        default:
            return @"";

    }
}


-(NSString*)ConvertDurationFormate:(NSString*)time{
    
    NSString * firstChar = [time substringToIndex:NSMaxRange([time rangeOfComposedCharacterSequenceAtIndex:1])];
    NSString *secondChar = [time substringWithRange:NSMakeRange(2,2)];
    
    NSString *firstLetter = [firstChar substringToIndex:1];
    NSString *secondLetter = [secondChar substringToIndex:1];
    
    // This code is because we don't need to show "0"
    if ([firstLetter isEqualToString:@"0"])
    {
        firstLetter = [firstChar substringFromIndex:1];
    }
    else
    {
        firstLetter = firstChar;
    }
    
    if ([secondLetter isEqualToString:@"0"])
    {
        secondLetter = [secondChar substringFromIndex:1];
    }
    else
    {
        secondLetter = secondChar;
    }
    NSString * finalTime = [[[firstLetter stringByAppendingString:@"h "]stringByAppendingString:secondLetter]stringByAppendingString:@"m"];
     NSLog(@"%@h %@m",firstLetter,secondLetter);
    
    return finalTime;
    
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
            finalTime = [[[[NSString stringWithFormat:@"%i", firstTime]stringByAppendingString:@":"]stringByAppendingString: secondChar] stringByAppendingString:@" pm"];
            NSLog(@"%d:%@ pm",firstTime,secondChar);
            
        }
        else
        {
            firstTime -= 12;
            finalTime = [[[[NSString stringWithFormat:@"%i", firstTime]stringByAppendingString:@":"]stringByAppendingString: secondChar] stringByAppendingString:@" pm"];
            NSLog(@"%d:%@ pm",firstTime-12,secondChar);
        }
    }
    else
    {
          finalTime = [[[[NSString stringWithFormat:@"%i", firstTime]stringByAppendingString:@":"]stringByAppendingString: secondChar] stringByAppendingString:@" am"];
        NSLog(@"%@:%@ am",firstLetter,secondChar);
    
    }
    
    return finalTime;
}
@end
