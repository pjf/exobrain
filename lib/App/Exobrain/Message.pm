package App::Exobrain::Message;
use v5.10.0;
use Moose;
use warnings;

has namespace => ( isa => 'Str', required => 1 );
has timestamp => ( isa => 'Int'                );   # Seconds from epoch
has source    => ( isa => 'Str', required => 1 );
has data      => (               required => 1 ); 

1;
