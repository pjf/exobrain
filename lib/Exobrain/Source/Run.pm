package Exobrain::Source::Run;
use Moose::Role;

# ABSTRACT: Role for sources which run 'continously'

with 'Exobrain::Source';

requires('run');
excludes('poll');

1;
