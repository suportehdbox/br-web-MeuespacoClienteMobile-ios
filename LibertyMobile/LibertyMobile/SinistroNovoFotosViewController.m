//
//  SinistroNovoFotosViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SinistroNovoFotosViewController.h"
#import "Util.h"
#import "SinistroNovoAddTableViewCell.h"
#import "LibertyMobileAppDelegate.h"

typedef enum {
	LMClaimPhotoActionButtonTakePhoto = 0,
	LMClaimPhotoActionButtonChooseFromLibrary,
} LMClaimPhotoActionButton;


@implementation SinistroNovoFotosViewController

@synthesize listaTableView;
@synthesize event;
@synthesize managedObjectContext;
@synthesize editable;
@synthesize uiAlertView;
@synthesize uiActionSheet;
@synthesize sectionToAddPhoto;
@synthesize webViewString;

#define SECTION_MENSAGEM            0
#define SECTION_MEU_VEICULO         1
#define SECTION_OUTROS_VEICULOS     2
#define SECTION_LOCAL_ACIDENTE      3
#define SECTION_DOCUMENTOS          4

#define SECTION_TOTAL               5

#define MAX_PHOTOS                  4

static const CGFloat PHOTO_IMAGE_VIEW_X_COORDINATE_START = 20;
static const CGFloat PHOTO_IMAGE_VIEW_HORIZONTAL_OFFSET = 64.0;
static const CGFloat PHOTO_IMAGE_VIEW_Y_COORDINATE_START = 4;
static const CGFloat PHOTO_IMAGE_VIEW_VERTICAL_OFFSET = 0;
static const CGFloat PHOTO_IMAGE_VIEW_WIDTH = 57.0;
static const CGFloat PHOTO_IMAGE_VIEW_HEIGHT = 47.0;

-(id)initWithEventPhoto:(Event *)eventInit andManagedObjectContext:(NSManagedObjectContext *)theManagedObjectContext andCanEdit:(BOOL)canEdit
{
    if ((self = [super initWithNibName:@"SinistroNovoFotosViewController" bundle:nil])) 
    {
        self.event = eventInit;
        self.managedObjectContext = theManagedObjectContext;
        self.editable = canEdit;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [Util initCustomNavigationBar:self.navigationController.navigationBar];
    
    [self.navigationController setNavigationBarHidden:NO];    
    self.title = @"Fotos";
   
    [Util dropTableBackgroudColor:self.listaTableView];

//    //Adicionando o botÃ£o esquerdo na NavigationBar
//    UIBarButtonItem *sinistroButton = [Util addCustomButtonNavigationBar:self action:@selector(btnSinistroNovo:) imageName:@"05_sinistrosdados-btn-novo.png"];
//    self.navigationItem.leftBarButtonItem = sinistroButton;
//    [sinistroButton release];
    
    [Util addBackButtonNavigationBar:self action:@selector(btnSinistroNovo:)];
    
    // Coloca a imagem de fundo na barra:
    UIImage *imagebg = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:imagebg forBarMetrics:UIBarStyleDefault];
    
    
    // Codigo nescessario neste ponto pois depois no carregamento da celula nÃ£o executa!
    NSString *webViewPath = [[NSBundle mainBundle] pathForResource:@"infoFotos" ofType:@"html"];
    [self setWebViewString: [NSString stringWithContentsOfFile:webViewPath encoding:NSUTF8StringEncoding error:NULL]];
    
    [listaTableView setDelegate:self];
    [listaTableView setDataSource:self];
    
    [listaTableView registerNib:[UINib nibWithNibName:@"SinistroNovoAddTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CellSinistroAdd"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIDeviceOrientationPortraitUpsideDown);
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)viewWillAppear:(BOOL)animated 
{
	[super viewWillAppear:animated];
    [listaTableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return SECTION_TOTAL;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == SECTION_MENSAGEM) {
        return 1;
    }
    else {
        NSArray *photosForSection = [event sortedPhotoArrayForSection:section - 1];

        //Se caso nÃ£o tiver nenhuma foto e o sinistro foi enviado
        if ([photosForSection count] == 0 && !editable) {
            return 1;
        //Se caso tiver alguma foto e o sinistro foi enviado ou o nÃºmero de fotos chegou ao seu mÃ¡ximo
        //entÃ£o esconde o botÃ£o de adicionar mais fotos e mostra as fotos
        } else if (([photosForSection count] > 0 && !editable) || ([photosForSection count] == MAX_PHOTOS)) {
            return 2;
        }
    }
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int iSection = indexPath.section;
    
    if (iSection == SECTION_MENSAGEM)
    {        
        static NSString *CellIdentifierInf = @"CellInf";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierInf];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierInf] autorelease];
            
            UIWebView *iWebCampo = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 300, 118)];
            [iWebCampo setBackgroundColor:[UIColor clearColor]];
            [iWebCampo setUserInteractionEnabled:NO];
            [iWebCampo setOpaque:NO];
            [iWebCampo setScalesPageToFit:NO];
            [iWebCampo loadHTMLString:webViewString baseURL:nil];
            [iWebCampo setAutoresizingMask :UIViewAutoresizingFlexibleBottomMargin
                                             | UIViewAutoresizingFlexibleLeftMargin
                                             | UIViewAutoresizingFlexibleRightMargin
                                             | UIViewAutoresizingFlexibleTopMargin
                                             | UIViewAutoresizingFlexibleWidth ];
            
            [cell.contentView addSubview:iWebCampo];
        }
        
        return cell;
    }
    else if (indexPath.row == 0)
    {
        static NSString *CellIdentifierTitle = @"CellTitle";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierTitle];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierTitle] autorelease];
        }
        
        if (iSection == SECTION_MEU_VEICULO) {
            cell.textLabel.text = @"Meus Ve’culos";
        }
        else if (iSection == SECTION_OUTROS_VEICULOS) {
            cell.textLabel.text = @"Outros Ve’culos";
        }
        else if (iSection == SECTION_LOCAL_ACIDENTE) {
            cell.textLabel.text = @"Local do acidente";
        }
        else if (iSection == SECTION_DOCUMENTOS) {
            cell.textLabel.text = @"Documentos";
        }
        
        cell.textLabel.textColor = [Util getColorHeader];
        cell.userInteractionEnabled = NO;
        
        return cell;
    }
    else  if (indexPath.row == 1)
    {
        static NSString *CellIdentifierFoto = @"CellFoto";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierFoto];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierFoto] autorelease];
        }
        
        //Deleta o ThumbnailImageView da TableViewCell por causa do reusable
        UIView *subview;
        NSEnumerator *enumerator = [cell.subviews objectEnumerator];
        while ((subview = [enumerator nextObject])) {
            if ([subview isKindOfClass:[ThumbnailImageView class]]) {
                [subview removeFromSuperview];
                break;
            }
        }
        
        NSUInteger imageIndex = 0;
        NSArray *photosForSection = [event sortedPhotoArrayForSection:indexPath.section - 1];
        for (id nextPhoto in photosForSection) 
        {
            ThumbnailImageView *photoImageView = [[ThumbnailImageView alloc] init];
            photoImageView.frame = CGRectMake((PHOTO_IMAGE_VIEW_X_COORDINATE_START + PHOTO_IMAGE_VIEW_HORIZONTAL_OFFSET * imageIndex), 
                                              (PHOTO_IMAGE_VIEW_Y_COORDINATE_START + PHOTO_IMAGE_VIEW_VERTICAL_OFFSET), 
                                              PHOTO_IMAGE_VIEW_WIDTH, PHOTO_IMAGE_VIEW_HEIGHT);
            [photoImageView setContentMode:UIViewContentModeScaleAspectFit];
            [photoImageView setImage:[nextPhoto thumbnailImage]];
            [photoImageView setDelegate:self];
            [photoImageView setSectionIndex:indexPath.section - 1];
            [photoImageView setImageIndex:imageIndex];
            [photoImageView setUserInteractionEnabled:YES];
            [cell addSubview:photoImageView];
            [photoImageView release];
            imageIndex++;
        }
        return cell;
    }
    else  if (indexPath.row == 2)
    {
        //M‡ximo de Fotos suportadas
        SinistroNovoAddTableViewCell *cell = (SinistroNovoAddTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellSinistroAdd"];
        return cell;
    }

    return nil;
}


#pragma mark -s Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        [self addClaimPhotoButtonPressed:indexPath.section - 1];
    }
    
    // Deselect the row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SECTION_MENSAGEM) return 130;
    if (indexPath.row == 1) {
        NSArray *photosForSection = [event sortedPhotoArrayForSection:indexPath.section - 1];
        if ([photosForSection count] == 0) {
            return 0.0;
        }
        else {
            return 60.0;
        }
    }
    if (indexPath.row == 2) {
        NSArray *photosForSection = [event sortedPhotoArrayForSection:indexPath.section - 1];
        //MÃ¡ximo de Fotos suportadas
        if ([photosForSection count] == MAX_PHOTOS) {
            return 0.0;
        }
    }
    return tableView.rowHeight;
}


#pragma mark -
#pragma mark UIActionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	uiActionSheet = nil;
	
	if (buttonIndex == LMClaimPhotoActionButtonChooseFromLibrary) {
		[self selectExistingPhoto];
	} else if (buttonIndex == LMClaimPhotoActionButtonTakePhoto) {
		[self takeNewPhoto];
	}	
} 

#pragma mark -
#pragma mark Image Picker Methods

- (void)addClaimPhotoButtonPressed:(NSUInteger)section
{
	self.sectionToAddPhoto = section;
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] 
								  initWithTitle:nil 
								  delegate:self 
								  cancelButtonTitle:@"Cancelar"
								  destructiveButtonTitle:nil 
								  otherButtonTitles:@"Tirar Foto", @"Escolher da biblioteca", nil];
	
	self.uiActionSheet = actionSheet;
	if (self.parentViewController.tabBarController != nil) {
		[actionSheet showInView:self.parentViewController.tabBarController.view];
	} else {
		[actionSheet showInView:self.parentViewController.view];
	}
	[actionSheet release];
}

- (void)takeNewPhoto
{
	NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
	
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [mediaTypes containsObject:@"public.image"]) 
	{
		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
		picker.delegate = self;
		picker.allowsEditing = YES;
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
		[self presentModalViewController:picker animated:YES];
		[picker release];
	} 
	else 
	{
		NSLog(@"No camera available");
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
														message:@"C‰mera n‹o dispon’vel"
													   delegate:self 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		
		self.uiAlertView = alert;
		[alert show];
		[alert release];
	}
}

- (void)selectExistingPhoto
{
	NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
	
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] && [mediaTypes containsObject:@"public.image"]) 
	{
		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
		picker.delegate = self;
		picker.allowsEditing = YES;
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		[self presentModalViewController:picker animated:YES];
		[picker release];
	}
	else 
	{
		NSLog(@"Photo Library not available");
		NSLog(@"No camera available");
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
														message:@"çlbum n‹o dispon’vel"
													   delegate:self 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		
		self.uiAlertView = alert;
		[alert show];
		[alert release];
	}
}

#pragma mark - Image Picker Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
	EventPhoto *eventPhoto = [NSEntityDescription insertNewObjectForEntityForName:@"EventPhoto" inManagedObjectContext:self.managedObjectContext];

    //Update EventPhoto
	[eventPhoto setFullSizeImage:image];
	[eventPhoto setEvent:self.event];
	[eventPhoto setImagePosition:[self determineNextImagePositionForSection:self.sectionToAddPhoto]];
	[eventPhoto setImageSection:[NSNumber numberWithInt:self.sectionToAddPhoto]];
	UIImage *thumbnail = [self thumbnailFromImage:image width:114.0 height:94.0];
	[eventPhoto setThumbnailImage:thumbnail];

	[self.event addEventPhotosObject:eventPhoto];
    //-----------------------------------------------
	
	[self saveState];
	
	[self.view removeFromSuperview];
	[self setView:nil];
	
	[self dismissModalViewControllerAnimated:YES];
	//[picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self.view removeFromSuperview];
	[self setView:nil];
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Custom Image Methods

- (UIImage *)thumbnailFromImage:(UIImage *)originalImage width:(float)width height:(float)height {
	UIImage *thumbnail;
	
	UIImageView *mainImageView = [[UIImageView alloc] initWithImage:originalImage];
	BOOL widthGreaterThanHeight = (originalImage.size.width > originalImage.size.height);
	float sideFull = (widthGreaterThanHeight) ? originalImage.size.height : originalImage.size.width;
	CGRect clippedRect = CGRectMake(0, 0, sideFull, sideFull);
	//creating a square context the size of the final image which we will then
	//manipulate and transform before drawing in the original image
	UIGraphicsBeginImageContext(CGSizeMake(width, height));
	CGContextRef currentContext = UIGraphicsGetCurrentContext();
	CGContextClipToRect(currentContext, clippedRect);
	CGFloat scaleFactor = width/sideFull;
	if (widthGreaterThanHeight) {
		//a landscape image â€“ make context shift the original image to the left when drawn into the context
		CGContextTranslateCTM(currentContext, -((originalImage.size.width - sideFull) / 2) * scaleFactor, 0);
	}
	else {
		//a portfolio image â€“ make context shift the original image upwards when drawn into the context
		CGContextTranslateCTM(currentContext, 0, -((originalImage.size.height - sideFull) / 2) * scaleFactor);
	}
	//this will automatically scale any CGImage down/up to the required thumbnail side (length) when the CGImage 
	//gets drawn into the context on the next line of code
	CGContextScaleCTM(currentContext, scaleFactor, scaleFactor);
	// TODO: take a look
	[mainImageView.layer renderInContext:currentContext];
	thumbnail = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	[mainImageView release];
	
	return thumbnail;
}

- (NSNumber *)determineNextImagePositionForSection:(NSUInteger)sectionNumber
{
	NSNumber *nextImagePosition;
	nextImagePosition = [self.event.eventPhotos valueForKeyPath:@"@max.imagePosition"];
	return [NSNumber numberWithInt:[nextImagePosition intValue] + 1];
}

#pragma mark -
#pragma mark Thumbnail Image View Delegate Methods

- (void)thumbnailImageViewWasSelected:(ThumbnailImageView *)thumbnailImageView {
    
	NSArray *photosForSection = [event sortedPhotoArrayForSection:thumbnailImageView.sectionIndex];
	UIImage *fullSizedPhoto = ((EventPhoto *)[photosForSection objectAtIndex:thumbnailImageView.imageIndex]).fullSizeImage;
	
	SinistroNovoFotosDetalheViewController *photoViewController = [[SinistroNovoFotosDetalheViewController alloc] initWithNibName:@"SinistroNovoFotosDetalheViewController" bundle:nil];
    
	[photoViewController setThumbSectionIndex:thumbnailImageView.sectionIndex];
	[photoViewController setThumbImageIndex:thumbnailImageView.imageIndex];
	[photoViewController setDelegate:self];
    [photoViewController setFullSizedImage:fullSizedPhoto];
	[photoViewController setDeleteEnabled:self.editable];
    [[self navigationController] pushViewController:photoViewController animated:YES];
    [photoViewController release];
	
	[thumbnailImageView clearSelection];

}

#pragma mark -
#pragma mark Claim Photo Detail Delegate Methods

- (void)SinistroNovoFotosDetalheViewController:(SinistroNovoFotosDetalheViewController *)controller didPressDelete:(BOOL)pressedDelete {
	if (pressedDelete) {
		
		[self.view removeFromSuperview];
		[self setView:nil];
		
		NSArray *photosForSection = [event sortedPhotoArrayForSection:controller.thumbSectionIndex];
		EventPhoto *eventPhoto = (EventPhoto *)[photosForSection objectAtIndex:controller.thumbImageIndex];
		//delete this object from the data model
		[self.managedObjectContext deleteObject:eventPhoto]; 
		[self saveState];
		[self.navigationController popViewControllerAnimated:YES];
	}
}

#pragma mark -
#pragma mark Core Data stack

- (void)saveState {
	[((LibertyMobileAppDelegate *)[[UIApplication sharedApplication] delegate]) saveState];
}


#pragma mark -s Actions

- (IBAction)btnSinistroNovo:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
