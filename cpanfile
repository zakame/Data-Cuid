requires 'perl', '5.008001';

requires 'Exporter',    '5.57';
requires 'List::Util',  '0';
requires 'Time::HiRes', '0';

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Sub::Util',  '0';
};

