package Cache::FastMmap::Tie;

use strict;
use 5.8.1;
our $VERSION = '0.01_02';

use base 'Cache::FastMmap';
use Class::Inspector;
use Best [ [ qw/YAML::XS YAML::Syck YAML/ ], qw/LoadFile/ ];

sub TIEHASH{
    my ($class, $params_hash) = @_;
    if (my $yaml_file = delete $params_hash->{yaml_file}) {
        $params_hash = LoadFile("$yaml_file") or die "Can't open `$yaml_file':$@ ",__LINE__;
        
        ############################
        #use Data::Dumper;
        #print '#DEBUG#', Dumper $params_hash;
    }
    my $self = $class->new(%{$params_hash});
    $self->{_tie_var} = {};
    return $self;
}

sub STORE { shift->set(@_) } # ( Key => Value )

sub FETCH { shift->get(@_) } # ( Key )

sub DELETE{ shift->remove(@_) } # ( Key )

sub CLEAR { shift->clear }

sub EXISTS { # ( Key )
    my $self = shift;
    $self->STORE(@_) ? return $self->STORE(@_) : return
}

sub FIRSTKEY {
    my $self = shift;
    @{$self->{_tie_var}->{get_keys_0}} = $self->get_keys(0);
    shift @{$self->{_tie_var}->{get_keys_0}};
}

sub NEXTKEY { # ( prevKey )
    my $self = shift;
    shift @{$self->{_tie_var}->{get_keys_0}};
}

#sub DESTROY {}



1;
__END__

=head1 NAME

Cache::FastMmap::Tie - Using Cache::FastMmap as hash 

=head1 SYNOPSIS

    use Cache::FastMmap::Tie;
    my $fc = tie my %hash, 'Cache::FastMmap::Tie', {
        share_file => "file_name",
        cache_size => "1k",
        expire_time=> "10m",
    };

    $hash{ABC} = 'abc'; # $fc->set('ABC', 'abc');
    $hash{abc_def} = [qw(ABC DEF)];
    $hash{xyz_XYZ} = {aaa=>'AAA',BBB=>[qw(ccc DDD),{eee=>'FFF'}],xxx=>'YYY'};

    print $hash{ABC}; # $fc->get('ABC');

    for ( keys %hash ) { # $fc->get_keys(0);
        print $hash{$_}, "\n"; # $fc->get($_);
    }

or 

    my $cf = tie my %hash, 'Cache::FastMmap::Tie', {yaml_file=>'yaml.txt'}

example (yaml.txt)

    expire_time: 1m
    cache_size: 10k

=head1 DESCRIPTION

Tie for Cache::FastMmap. Read `perldoc perltie`

=head1 AUTHOR

Yuji Suzuki E<lt>yuji.suzuki.perl@gmail.comE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Cache::FastMmap>

=cut
