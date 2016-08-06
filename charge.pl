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

my $tenma = Tenma::PSU->new;

# Replace this with the path to your Tenma PSU 
$tenma->connect("/dev/board/tenma/72-2535");

$tenma->setVoltage(3);
$tenma->setCurrent(2.2);
$tenma->outputOn();

$SIG{INT}  = sub { 
    $tenma->outputOff(); 
    $tenma->outputOff(); 
    $tenma->outputOff(); 
    die "Byebye"; 
};

my $peak = 0;

while (1) {
    $tenma->setCurrent(2.2);

    my $i = 0;
    while ($i < 5) {
        $i++;
        sleep (1);
        print "\r1C: " . $tenma->getActualVoltage() . "V " . $tenma->getActualCurrent() . "A $i     ";
    }

    $tenma->setCurrent(0);
    my $vb = $tenma->getActualVoltage();
    if ($vb > $peak) {
        $peak = $vb;
    }
    print "\nCharge: $vb Peak: $peak DV: " . ($vb - $peak) . "\n";
    if (($vb - $peak) <= -0.02) {
        print "Charge complete\n";
        $tenma->outputOff();
        $tenma->outputOff();
        exit(0);
    }

}
