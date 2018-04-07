package Tenma::PSU;

use strict;

use Device::SerialPort;
use Time::HiRes qw(usleep nanosleep);

sub new {
    my $class = shift;
    return bless {}, $class;
}

sub connect {
    my $self = shift;
    my $path = shift;
    $self->{path} = $path;
    $self->{port} = new Device::SerialPort($path);

    if (!$self->{port}) {
        return 0;
    }

    $self->{port}->baudrate(9600);
    return 1;
}

sub setCurrent {
    my $self = shift;
    my $current = shift;
    my $d = sprintf("ISET1:%5.3f", $current);
    $self->swrite($d);
}

sub getCurrent {
    my $self = shift;
    $self->swrite("ISET1?");
    return $self->sread(5) - 0;
}

sub getActualCurrent {
    my $self = shift;
    $self->swrite("IOUT1?");
    return $self->sread(5) - 0;
}

sub setVoltage {
    my $self = shift;
    my $voltage = shift;
    my $d = sprintf("VSET1:%05.2f", $voltage);
    $self->swrite($d);
}

sub getVoltage {
    my $self = shift;
    $self->swrite("VSET1?");
    return $self->sread(5) - 0;
}

sub getActualVoltage {
    my $self = shift;
    $self->swrite("VOUT1?");
    return $self->sread(5) - 0;
}

sub outputOn {
    my $self = shift;
    $self->swrite("OUT1");
}

sub outputOff {
    my $self = shift;
    $self->swrite("OUT0");
}

sub beepOn {
    my $self = shift;
    $self->swrite("BEEP1");
}

sub beepOff {
    my $self = shift;
    $self->swrite("BEEP0");
}

sub getStatus {
    my $self = shift;
    $self->swrite("STATUS?");
    my $status = $self->sread(1);
    my $ch0mode = $status & 0x01;
    my $ch1mode = ($status & 0x02) >> 1;
    my $tracking = ($status & 0x0C) >> 2;
    my $beep = ($status & 0x10) >> 4;
    my $lock = ($status & 0x20) >> 5;
    my $output = ($status & 0x40) >> 6;
    return ($status, $ch0mode, $beep, $lock, $output);
}

sub recallSetting {
    my $self = shift;
    my $setting = shift;
    my $data = sprintf("RCL%d", $setting);
    $self->swrite($data);
}

sub saveSetting {
    my $self = shift;
    my $setting = shift;
    my $data = sprintf("SAV%d", $setting);
    $self->swrite($data);
}

sub ovpOn {
    my $self = shift;
    $self->swrite("OVP1");
}

sub ovpOff {
    my $self = shift;
    $self->swrite("OVP0");
}

sub ocpOn {
    my $self = shift;
    $self->swrite("OCP1");
}

sub ocpOff {
    my $self = shift;
    $self->swrite("OCP0");
}

sub swrite {
    my $self = shift;
    my $data = shift;
    if (!$self->{port}) {
        if (!$self->connect($self->{path})) {
            return;
        }
    }
    $self->{port}->read(255);
    $self->{port}->write($data);
    usleep(50000);
}

sub sread {
    my $self = shift;
    my $len = shift;
    if (!$self->{port}) {
        if (!$self->connect($self->{path})) {
            return "";
        }
    }
    my $data = "";
    my $count = 0;
    my $now = time();
    while ($count < $len) {
        if (!$self->{port}) {
            if (!$self->connect($self->{path})) {
                print "Unable to connect\n";
                return "";
            }
        }
        if (time() - $now > 5) {
            $self->{port}->close();
            if (!$self->connect($self->{path})) {
                return "";
            }
        }
        my ($c, $d) = $self->{port}->read(1);
        if ($c > 0) {
            $count += $c;
            $data .= $d;
        }
    }
    return $data;
}

1;
