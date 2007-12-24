package Cache::FastMmap::Tie;

use strict;
use 5.8.1;
our $VERSION = '0.01_01';

use UNIVERSAL::require;
use Class::Inspector;
use base 'Cache::FastMmap';

our $yamlmodule;

sub import {
    my $class = shift ;
    $yamlmodule = shift;
    $yamlmodule and $yamlmodule =~/YAML/ 
        and $yamlmodule->use(qw(LoadFile));
}

sub TIEHASH{
    my ($class, $params_hash) = @_;
    
    if ($yamlmodule and my $yaml_file = delete $params_hash->{yaml_file}){
        eval '$params_hash' . qq{ = ${yamlmodule}::LoadFile("$yaml_file")};
        $params_hash or die "Can't open `$yaml_file':$@ ..",__LINE__;
    }elsif ($yaml_file = delete $params_hash->{yaml_file}){
        $params_hash = undef;
        for $yamlmodule( qw(YAML::XS YAML::Syck YAML) ) {
            Class::Inspector->loaded( $yamlmodule ) and 
                eval qq{$params_hash  = $yamlmodule::LoadFile("$yaml_file")};
            $yamlmodule->use() or die $@;
            eval '$params_hash' . qq{ = ${yamlmodule}::LoadFile("$yaml_file")};
            last;
        }
        $params_hash or die "Can't open `$yaml_file':$@ ..$yamlmodule..",__LINE__;
    }

    my $self = $class->new(%{$params_hash});
    $self->{tie} = {};
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
    @{$self->{tie}->{get_keys_0}} = $self->get_keys(0);
    shift @{$self->{tie}->{get_keys_0}};
}

sub NEXTKEY { # ( prevKey )
    my $self = shift;
    shift @{$self->{tie}->{get_keys_0}};
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
