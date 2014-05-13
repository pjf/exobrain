package Exobrain::Logger;
use v5.10.0;
use Log::Log4perl;

use Moose;
use Method::Signatures;

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
  my $logfile = "/home/leon/exobrain.log";       # Load from logger Config file
  my $loglevel = 'INFO';  # Load from logger config file

  # In reality this whole lot could be loaded from a log.conf, but the above may be simpler.
  my $log_conf = qq(
    log4perl.rootLogger                  = $loglevel, Exobrain
    log4perl.appender.Exobrain           = Log::Log4perl::Appender::File
    log4perl.appender.Exobrain.utf8      = 1
    log4perl.appender.Exobrain.filename  = $logfile
    log4perl.appender.Exobrain.mode      = append
    log4perl.appender.Exobrain.layout    = Log::Log4perl::Layout::PatternLayout
    log4perl.appender.Exobrain.layout.ConversionPattern = %d %p %m %n
  );

  Log::Log4perl->init_once(\$log_conf);
  return Log::Log4perl->get_logger();
}

1;
