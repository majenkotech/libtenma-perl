API
===

Create a new Tenma PSU object:

    use Tenma::PSU;
    my $tenma = new Tenma::PSU;

Connect to a Tenma device:

    $tenma->connect("/dev/ttyACM0");

Set the current and voltage:

    $tenma->setCurrent(<current>);
    $tenma->setVoltage(<voltage>);

Get the currently selected current and voltage (the values set above):

    my $current = $tenma->getCurrent();
    my $voltage = $tenma->getVoltage();

Get the actual measured current and voltage:

    my $current = $tenma->getActualCurrent();
    my $voltage = $tenma->getActualVoltage();

Turn the output on and off:

    $tenma->outputOn();
    $tenma->outputOff();

Turn the beep on and off:

    $tenma->beepOn();
    $tenma->beepOff();

Turn over-current protection on and off:

    $tenma->ocpOn();
    $tenma->ocpOff();

Turn over-voltage protection on and off:

    $tenma->ovpOn();
    $tenma->ovpOff();

Save the settings in a memory slot:

    $tenma->saveSetting(1 ... 5);

Recall the settings from a memory slot:

    $tenma->recallSetting(1 ... 5);

Get the status of the Tenma:

    my ($status, $mode, $beep, $lock, $output) = $tenma->getStatus();
