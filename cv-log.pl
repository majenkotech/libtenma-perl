#!/usr/bin/perl

####
#
# Single-cell 2200mAh AA fast battery charger
#
# Charges at 1C and every 5 seconds sets the current to 0 to read the
# battery voltage. When the battery voltage drops to 0.02v below the
# peak voltage so far the charge terminates.
#
####

use strict;
use Tenma::PSU;
$|=1;

my $voltage = shift || die "Usage: cv-log.pl <voltage>"; 


my $tenma = Tenma::PSU->new;

# Replace this with the path to your Tenma PSU 
$tenma->connect("/dev/board/tenma/72-2535");

$tenma->setVoltage($voltage);
$tenma->setCurrent(3);
$tenma->outputOn();

$SIG{INT}  = sub { 
    $tenma->outputOff(); 
    $tenma->outputOff(); 
    $tenma->outputOff(); 
    die "Byebye"; 
};

my $peak = 0;

print "Set Current, Set Voltage, Actual Current, Actual Voltage\n";

while (1) {
    sleep(1);
    print $tenma->getCurrent() . ",";
    print $tenma->getVoltage() . ",";
    print $tenma->getActualCurrent() . ",";
    print $tenma->getActualVoltage() . "\n";
}
