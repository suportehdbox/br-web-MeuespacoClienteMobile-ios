//
//  SinistroConsultaViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SinistroConsultaViewController.h"
#import "Util.h"
#import "SinistroNovoViewController.h"


@implementation SinistroConsultaViewController

@synthesize delegate;
@synthesize managedObjectContext;
@synthesize fetchedResultsController;
@synthesize consultaTableView;
@synthesize selectedItem;
@synthesize uiActionSheet;
@synthesize dadosLoginSegurado;

#define DELETE_CLAIM_ALERT_TAG      1

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
	[managedObjectContext release];
	[fetchedResultsController release];
	[uiActionSheet release];
    [selectedItem release];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
//    [Util initCustomNavigationBar:self.navigationController.navigationBar];
    [super viewDidLoad];
    

	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		[Util alertError:error];
	}
    
    [self.navigationController setNavigationBarHidden:NO];
    self.title = @"Meus Sinistros";
   
    [GoogleAnalyticsManager send:@"Comunicação de Acidente: Consulta"];
    
    [Util dropTableBackgroudColor:self.consultaTableView];

//    //Adicionando o botão esquerdo na NavigationBar
//    UIBarButtonItem *closeButton = [Util addCustomButtonNavigationBar:self action:@selector(btnMenu:) imageName:@"19_sinistro-meussinistros-btn-sinistro.png"];
//    self.navigationItem.leftBarButtonItem = closeButton;
//    [closeButton release];
    
    [Util addBackButtonNavigationBar:self action:@selector(btnMenu:)];
    
    // Coloca a imagem de fundo na barra:
    UIImage *imagebg = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:imagebg forBarMetrics:UIBarStyleDefault];

    
    //Adicionando o botão direito na NavigationBar
    UIBarButtonItem *editButton = [Util addCustomButtonNavigationBar:self action:@selector(btnEdit:) imageName:@"btn-editar-lm.png"];
    self.navigationItem.rightBarButtonItem = editButton;
    [editButton release];
    
    [consultaTableView registerNib:[UINib nibWithNibName:@"SinistroConsultaTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CellSinistro"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [[fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
	return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SinistroConsultaTableViewCell *cell = (SinistroConsultaTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellSinistro"];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	// Configure the cell.
	[self configureCell:cell atIndexPath:indexPath];
	return cell;
}

- (void)configureCell:(SinistroConsultaTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Event *event = [fetchedResultsController objectAtIndexPath:indexPath];
	
    cell.lblEnviado.text = [Util fmtNSDateToString:event.submitDateTime dateFormatter:nil];

    NSDateFormatter *dateFormatterSinistro = [[NSDateFormatter alloc] init];
	[dateFormatterSinistro setDateFormat:@"dd/MM/yyyy 'às' HH:mm:ss"];
    NSString *stringFromDate = [dateFormatterSinistro stringFromDate:event.incidentDateTime];
    cell.lblData.text = stringFromDate;
    [dateFormatterSinistro release];

    cell.lblTipo.text = [event eventSubType];

    // TODO: Event Location should be able to return a formatted City, State string
	if (event.eventLocation) {
		// TODO: Clean this mess up
		Address *claimLocation = event.eventLocation;
		if (claimLocation.city != nil && ![claimLocation.city isEqualToString:@""]) {
			cell.lblLocal.text = [NSString stringWithFormat:@"%@", [event.eventLocation city]];
		} else {
			cell.lblLocal.text = @"";
		}
	} else {
		cell.lblLocal.text = @"";
	}
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
	if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        self.selectedItem = indexPath;
        
        Event *event = [fetchedResultsController objectAtIndexPath:indexPath];
        NSString *actionTitle = [event.eventStatus isEqualToString:@"Draft"] ? @"A solicitação ainda não foi enviada, deseja apagar?" : @"Nota: A sua solicitação já foi enviada para a Liberty Seguros. Se você apagar, ela apenas será removida de seu aparelho.";
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] 
                                      initWithTitle:actionTitle 
                                      delegate:self 
                                      cancelButtonTitle:@"Cancelar"
                                      destructiveButtonTitle:@"Remover" 
                                      otherButtonTitles:nil];
        actionSheet.tag = DELETE_CLAIM_ALERT_TAG;
        self.uiActionSheet = actionSheet;
        [actionSheet showInView:self.navigationController.view];
        [actionSheet release];
	}
}

#pragma mark -
#pragma mark UIActionSheet Delegate Methods
// TODO: Currently just a virtual copy of addNewClaim:(id)sender below. Just using it temporarily to test potential new screen flow
// TODO: Clean this method up so that Home & Auto share the controller setup
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	uiActionSheet = nil;
	
    if(actionSheet.tag == DELETE_CLAIM_ALERT_TAG)
    {
        // TODO: Below will be moved to the action sheet delegate method at the bottom of the class
        if (buttonIndex == 0) {
            NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
            [context deleteObject:[fetchedResultsController objectAtIndexPath:self.selectedItem]];
            
            // Save the context.
            NSError *error = nil;
            if (![context save:&error]) {
                [Util alertError:error];
            }
            
            //if there are no claims left, exit edit mode:
            if (self.fetchedResultsController.fetchedObjects.count < 1)
            {
                [self setEditing:NO];
            }
        }
    } 
} 

#pragma mark -s Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Event *event = [fetchedResultsController objectAtIndexPath:indexPath];
	
    SinistroNovoViewController *viewTela = [[SinistroNovoViewController alloc] init];
    viewTela.managedObjectContext = self.managedObjectContext;
    viewTela.event = event;
    viewTela.dadosLoginSegurado = self.dadosLoginSegurado;
    [self.navigationController pushViewController:viewTela animated:YES];
    [viewTela release];

    // Deselect the row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}


// TODO: Clean this method up
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
	reorderingTableRows = YES;
	NSUInteger fromRow = fromIndexPath.row;
    NSUInteger toRow = toIndexPath.row;
	
	//NSLog(@"Moving rows %d -> %d", fromRow, toRow);
	
	NSArray *objects = self.fetchedResultsController.fetchedObjects;
	
	// Reset all values
	// Prototype HACK/shortcut for setting sortValue
	NSUInteger i, count = [objects count];
	for (i = 0; i < count; i++) {
		Event *event = [objects objectAtIndex:i];
		event.sortValue = [NSNumber numberWithInt:i];
		//NSLog(@"%@ was %@", event.title, event.sortValue);
	}
	
	if(fromRow < toRow) { //Moving Lower
		for (i = 0; i < count; i++) {
			Event * event = [objects objectAtIndex:i];
			if (i == fromRow) {
				event.sortValue = [NSNumber numberWithInt:toRow];
				//NSLog(@"Relocating %@ to %@", event.title, event.sortValue);
			}
			else {
				if (i <= toRow && i > fromRow) {
					event.sortValue = [NSNumber numberWithInt:i-1];
					//NSLog(@"Lowering %@ to %@", event.title, event.sortValue);
				}					
			}
		}
	}
	else {// Moving higher
		for (i = count; i > 0; i--) {
			int index = i - 1;
			Event * event = [objects objectAtIndex:index];
			if (index == fromRow) {
				event.sortValue = [NSNumber numberWithInt:toRow];
				//NSLog(@"Relocating %@ to %@", event.title, event.sortValue);
			}
			else {
				if (index >= toRow && index < fromRow) {
					event.sortValue = [NSNumber numberWithInt:i];
					//NSLog(@"Raising %@ to %@", event.title, event.sortValue);
				}					
			}
		}
	}
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - Fetched Results Controller

/**
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)fetchedResultsController
{
	if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
	
	// Create and configure a fetch request with the Event entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortValueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sortValue" ascending:YES];
	NSSortDescriptor *sortDateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createDateTime" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortValueDescriptor, sortDateDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Edit the section name key path and cache name if appropriate.
	// nil for section name key path means "no sections".
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
	self.fetchedResultsController = aFetchedResultsController;
	fetchedResultsController.delegate = self;
	
	// Memory management.
	[aFetchedResultsController release];
	[fetchRequest release];
	[sortValueDescriptor release];
	[sortDateDescriptor release];
	[sortDescriptors release];
 	
	return fetchedResultsController;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.consultaTableView setEditing:editing animated:animated];

    if (editing) {
        [self.navigationItem.leftBarButtonItem setEnabled:FALSE];
        
        //Adicionando o botão direito na NavigationBar
        UIBarButtonItem *okButton = [Util addCustomButtonNavigationBar:self action:@selector(btnOk:) imageName:@"btn-ok-lm.png"];
        self.navigationItem.rightBarButtonItem = okButton;
        [okButton release];
    }
    else {
        [self.consultaTableView setEditing:NO animated:YES];
        
        [self.navigationItem.leftBarButtonItem setEnabled:TRUE];
        
        //Adicionando o botão direito na NavigationBar
        UIBarButtonItem *editButton = [Util addCustomButtonNavigationBar:self action:@selector(btnEdit:) imageName:@"btn-editar-lm.png"];
        self.navigationItem.rightBarButtonItem = editButton;
        [editButton release];

		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		// Save the context.
		NSError *error = nil;
		if (![context save:&error]) {
			[Util alertError:error];
		}
    }
}

#pragma mark - Delegate Fetched Results Controller

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	if (!reorderingTableRows) {
        [self.consultaTableView beginUpdates];
	}
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    if (!reorderingTableRows) {
        UITableView *tableView = self.consultaTableView;
        SinistroConsultaTableViewCell *cell = (SinistroConsultaTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
        
        switch(type) {
                
            case NSFetchedResultsChangeInsert:
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeUpdate:
                [self configureCell:cell atIndexPath:indexPath];
                break;
                
            case NSFetchedResultsChangeMove:
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
	switch(type) {
			
		case NSFetchedResultsChangeInsert:
			[self.consultaTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.consultaTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
	if (!reorderingTableRows) {
        [self.consultaTableView endUpdates];
	}
	reorderingTableRows = NO;
}

#pragma mark - Actions

- (IBAction)btnMenu:(id)sender {
	[self.delegate backSinistroConsultaViewController];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnEdit:(id)sender {
    [self setEditing:TRUE animated:TRUE];
}

- (IBAction)btnOk:(id)sender {
    [self setEditing:FALSE animated:TRUE];
}

@end
