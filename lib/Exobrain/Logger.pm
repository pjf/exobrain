package Exobrain::Logger;
use v5.10.0;
use Log::Log4perl;

use Moose;
use Method::Signatures;
use Exobrain::Config;

# ABSTRACT: Simple Log4Perl access
# VERSION

=head1 DESCRIPTION

Inspired by MooseX::Log::Log4perl and provides a thin wrapper to Log::Log4perl.

Simply using the module will automatically log to the Exobrain log. Via Exobrain:

  use Exobrain;

  my $exobrain->new;
  $exobrain->log->info("Such logging!");

or inside your own exobrain component

  use Exobrain::Logger;
  
  my $logger = Exobrain::Logger->new;
  $logger->log->info("Very log!");

All standard Log4perl methods are available.

=cut

has log => (
    is => 'ro',
    isa => 'Log::Log4perl::Logger',
    lazy => 1,
    builder => '_build_log',
);

method _build_log() {
  my $config = Exobrain::Config->new;

  # In reality this whole lot could be loaded from a log.conf, but the above may be simpler.
  my $log_conf = qq(
    log4perl.rootLogger                  = $config->{Logger}{level}, Exobrain
    log4perl.appender.Exobrain           = Log::Log4perl::Appender::File
    log4perl.appender.Exobrain.utf8      = 1
    log4perl.appender.Exobrain.filename  = $config->{Logger}{file}
    log4perl.appender.Exobrain.mode      = append
    log4perl.appender.Exobrain.layout    = Log::Log4perl::Layout::PatternLayout
    log4perl.appender.Exobrain.layout.ConversionPattern = %d %p %m %n
  );

  Log::Log4perl->init_once(\$log_conf);
  return Log::Log4perl->get_logger();
}

method setup() {
    my $config = 
        "[Logger]\n" .
        "file       = $ENV{HOME}/ubic/log/exobrain/exobrain.log\n" .
        "level      = INFO\n";

    my $filename = Exobrain::Config->write_config('Logger.ini', $config);
}

1;
