package Trimurti::Shiva::Credentials;

use lib '../../';
# ============================================================================
# Handles configuration 
# ============================================================================
use strict;
use warnings;
use Carp qw( croak );

# ============================================================================
use Config::General;

# ============================================================================
require Exporter;
use vars qw($VERSION @ISA @EXPORT);

@ISA = qw(Exporter);
@EXPORT = qw(read_credentials);

# ============================================================================
my $config_file = ".credentials";

# ============================================================================
sub read_credentials {
	#might want to determine root project directory...
	my $config_file = shift || '.credentials';
	my $credentials_reader =  new Config::General(
																		-ConfigFile => $config_file,
																		-IncludeRelative => 1,
																		-AutoTrue=>1,
																		) || croak( 'Trimurti::Shiva::Credentials failed to load credentials file $config_file.' );
	my $config = $credentials_reader->{config};
	
	return $config;
}

1;