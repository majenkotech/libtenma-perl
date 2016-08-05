#!/usr/bin/perl

use strict;

use Tenma::PSU;

my $tenma = Tenma::PSU->new;
$tenma->connect("/dev/board/tenma/72-2535");

sweepVoltage(0.02, 3, 0.05);

sub sweepVoltage($$$) {
    my $current = shift;
    my $maxvoltage = shift;
    my $step = shift;
    print "Set Voltage,Actual Voltage,Actual Current\n";

    $tenma->setCurrent($current);
    $tenma->outputOn();
    my $c = 0;
    while ($c <= $maxvoltage) {
        $tenma->setVoltage($c);
        print $tenma->getVoltage() . "," . $tenma->getActualVoltage() . "," . $tenma->getActualCurrent() . "\n";
        $c += $step;
    }
    $tenma->outputOff();
}

sub sweepCurrent($$$) {
    my $voltage = shift;
    my $maxcurrent = shift;
    my $step = shift;
    print "Set Current,Actual Current,Actual Voltage\n";

    $tenma->setVoltage($voltage);
    $tenma->outputOn();
    my $c = 0;
    while ($c <= $maxcurrent) {
        $tenma->setCurrent($c);
        print $tenma->getCurrent() . "," . $tenma->getActualCurrent() . "," . $tenma->getActualVoltage() . "\n";
        $c += $step;
    }
    $tenma->outputOff();
}

