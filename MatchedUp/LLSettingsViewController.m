//
//  LLSettingsViewController.m
//  MatchedUp
//
//  Created by Len on 1/4/14.
//  Copyright (c) 2014 LL. All rights reserved.
//

#import "LLSettingsViewController.h"

@interface LLSettingsViewController ()
@property (strong, nonatomic) IBOutlet UISlider *maxAgeSlider;
@property (strong, nonatomic) IBOutlet UISwitch *menSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *womenSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *singlesSwitch;
@property (strong, nonatomic) IBOutlet UIButton *logButton;
@property (strong, nonatomic) IBOutlet UIButton *editProfileButton;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;


@end

@implementation LLSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.maxAgeSlider.value = [[NSUserDefaults standardUserDefaults] integerForKey:kLLAgeMaxKey];
    self.menSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kLLMenEnabledKey];
    self.womenSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kLLWomenEnabledKey];
    self.singlesSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kLLSingleEnabledKey];
    
    [self.maxAgeSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.menSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.womenSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.singlesSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.ageLabel.text = [NSString stringWithFormat:@"%i", (int)self.maxAgeSlider.value];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBActions
- (IBAction)logoutButtonPressed:(UIButton *)sender
{
}

- (IBAction)editProfileButtonPressed:(UIButton *)sender
{
}


#pragma mark - Helper Methods
- (void)valueChanged:(id)sender
{
    if (sender == self.maxAgeSlider) {
        [[NSUserDefaults standardUserDefaults] setInteger:(int)self.maxAgeSlider.value forKey:kLLAgeMaxKey];
        self.ageLabel.text = [NSString stringWithFormat:@"%i", (int)self.maxAgeSlider.value];
    } else if (sender == self.menSwitch) {
        [[NSUserDefaults standardUserDefaults] setBool:self.menSwitch.isOn forKey:kLLMenEnabledKey];
    } else if (sender == self.womenSwitch) {
        [[NSUserDefaults standardUserDefaults] setBool:self.womenSwitch.isOn forKey:kLLWomenEnabledKey];
    } else if (sender == self.singlesSwitch) {
        [[NSUserDefaults standardUserDefaults] setBool:self.singlesSwitch.isOn forKey:kLLSingleEnabledKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];

}
@end
