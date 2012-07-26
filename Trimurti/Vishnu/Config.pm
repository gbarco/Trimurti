package Trimurti::Vishnu::Config;

# ============================================================================
# Handles configuration 
# ============================================================================
use strict;
use warnings;
use Carp qw( croak );

# ============================================================================
use Config::General;
use Getopt::Long;
use Log::Log4perl qw/:easy/;
use POSIX qw(isdigit);

# ============================================================================
require Exporter;
use vars qw($VERSION @ISA @EXPORT);

@ISA = qw(Exporter);
@EXPORT = qw(read_project_config);

# ============================================================================
my $config_file = ".vishnu";

# ============================================================================
sub read_project_config {
	#might want to determine root project directory...
	my $config_file = shift || '.vishnu';
	my $config_reader =  new Config::General(
																		-ConfigFile => $config_file,
																		-IncludeRelative => 1,
																		-AutoTrue=>1,
																		) || croak( 'Trimurti::Vishnu::Config failed to load config file $config_file.' );
	
	return $config_reader->{config};
}

sub build_stash {
	my $config = shift;
	my $stash;
	
	# CONFIG ===================================================================
	$stash->{CONFIG} = $config;
	# PROJECT ==================================================================
	$stash->{PROJECT} = $config->{PROJECT};
	# FILE_GROUPS ==============================================================
	my @unsort_file_groups; #store file groups with no order to be added at bottom of order
	foreach my $config_element ( keys %{$stash->{CONFIG}} ) {
		next if ( $config_element ) eq 'PROJECT'; #this is not an file group

		if ( defined $stash->{CONFIG}->{$config_element}->{ORDER} && isdigit $stash->{CONFIG}->{$config_element}->{ORDER} ) {
			#all others are file groups to process		
			push @{$stash->{FILE_GROUPS}}, $stash->{CONFIG}->{$config_element}
		} else {
			push @unsort_file_groups, $stash->{CONFIG}->{$config_element};
		}
	}
	#sort file groups by defined order or else
	@{$stash->{FILE_GROUPS}} = sort { $a->{ORDER} <=> $b->{ORDER} } @{$stash->{FILE_GROUPS}};
	#add unsort file groups at bottom
	push @{$stash->{FILE_GROUPS}}, @unsort_file_groups;
	#release temp space
	undef @unsort_file_groups;
	# FILE_GROUPS ==============================================================
	
	return $stash;
}