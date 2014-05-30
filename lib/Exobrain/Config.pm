package Exobrain::Config;
use strict;
use warnings;
use autodie;
use parent 'Config::Tiny';
use Hash::Merge::Simple qw(merge);
use File::XDG;
use File::Path qw(make_path);

# ABSTRACT: Reads exobrain config

=head1 SYNOPSIS

    my $config = $exobrain->config;         # Preferred
    my $config = Exobrain::Config->new;     # Acceptable

=head1 DESCRIPTION

This reads configuration files for exobrain. This first reads
the contents of the user's XDG config directory for exobrain
(commonly F<~/.config/exobrain>) in alphabetical order,
and then the F<~/.exobrainrc> file, if it exists. Data read
later will override data earlier in the set.

=head1 ENVIRONMENT

If the C<EXOBRAIN_CONFIG> environment variable is set, it will
be used as the configuration directory to be used. In this case,
the user's F<~/.exobrainrc> file is I<not> read.

=cut

# VERSION

sub new {
    my ($class) = @_;

    my @config_files;

    if ($ENV{EXOBRAIN_CONFIG}) {
        # Read directory from environment variable
        @config_files = glob("$ENV{EXOBRAIN_CONFIG}/*");
    }
    else {
        # Use defaults, including ~/.exobrainrc if exists

        my $config_dir = File::XDG->new(name => 'exobrain')->config_home;
        @config_files = glob("$config_dir/*");

        push(@config_files,"$ENV{HOME}/.exobrainrc") if -f "$ENV{HOME}/.exobrainrc";
    }

    my $config = {};

    foreach my $file (@config_files) {

        my $indiv_config = $class->read($file);

        $indiv_config or die "Cannot read config - " . Config::Tiny->errstr;

        # Merge Each each individual config into our main one.

        $config = merge( $config, $indiv_config );

    }

    # This may change in the future, but for now we're still
    # acting a Config::Tiny object.
    return bless($config,$class);
}

=method write_config

    Exobrain::Config->write_config('Example.ini', $contents);

Writes the contents of a string to the config file specified in
the first argument, in the appropriate Exobrain config directory.
(Usually F<~/.config/exobrain>, which will be created if it does
not exist.)

Returns the filename written to on success.
Raises an exception on failure.

=cut

sub write_config {
    my ($class, $file, $contents) = @_;

    my $config_file;

    if ($ENV{EXOBRAIN_CONFIG}) {
        $config_file = "ENV{EXOBRAIN_CONFIG}/$file";
    }
    else {
        my $config_dir = File::XDG->new(name => 'exobrain')->config_home;

        # Make our config dir if it doesn't exist.
        if (not -e $config_dir) {
            make_path("$config_dir");
        }

        $config_file = "$config_dir/$file";
    }

    open(my $fh, '>', $config_file);

    print {$fh} $contents;

    close($fh);

    return $config_file;
}

1;
