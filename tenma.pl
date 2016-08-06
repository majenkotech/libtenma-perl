#!/usr/bin/env perl

use strict;

use Tenma::PSU;
use Gtk2;
use Glib qw/TRUE FALSE/;

my $tenma = new Tenma::PSU;

$tenma->connect("/dev/board/tenma/72-2535");

my $voltage = $tenma->getVoltage();
my $current = $tenma->getCurrent();

Gtk2->init;

my $window = new Gtk2::Window;
$window->realize();
$window->signal_connect(delete_event => sub { return 0; });
$window->signal_connect(destroy => sub { Gtk2->main_quit; });

my $display = new Gtk2::HBox(0, 0);

my $voltBox = new Gtk2::VBox(0, 0);
my $currentBox = new Gtk2::VBox(0, 0);

$display->add($voltBox);
$display->add($currentBox);

my $setVolts = new Gtk2::Label("Set Voltage");
my $setCurrent = new Gtk2::Label("Set Current");
my $actualVolts = new Gtk2::Label("Actual Voltage");
my $actualCurrent = new Gtk2::Label("Actual Current");

$voltBox->add($setVolts);
$voltBox->add($actualVolts);
$currentBox->add($setCurrent);
$currentBox->add($actualCurrent);

$window->add($display);

$window->set_title("TENMA 72-2535 PSU Control Panel");
$window->show_all();

Glib::Timeout->add(500, \&updateValues);

Gtk2->main;

sub updateValues {
    $setVolts->set_text($voltage . " V");
    $setCurrent->set_text($current . " A");
    $actualVolts->set_text($tenma->getActualVoltage() . " V");
    $actualCurrent->set_text($tenma->getActualCurrent() . " A");
    return TRUE;
}



