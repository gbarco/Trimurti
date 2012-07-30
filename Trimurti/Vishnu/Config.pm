package Trimurti::Vishnu::Config;

use lib '../../';
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
use File::Basename;

# ============================================================================
require Exporter;
use vars qw($VERSION @ISA @EXPORT);

@ISA = qw(Exporter);
@EXPORT = qw(read_project_config build_stash);

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
	my $config = $config_reader->{config};
	my $project_base = $config_file; $project_base =~ s/\/.*?$//; #keep path
	
	my($filename, $directories) = File::Basename::fileparse($config_file);
	
	$config->{PROJECT}->{BASE} = File::Spec->rel2abs( $directories );
	
	return $config;
}

# STASH Format
#'FILE_GROUPS' => [
#		{
#			'NAME' => 'statics',
#			'FILES' => [
#				'test.html',
#				'test2.html'
#			],
#			'ORDER' => 1,
#			'DESTINATION' => 'www.test.com/build/'
#		},
#		{
#			'NAME' => 'generated',
#			'FILES' => 'test3.html',
#			'ORDER' => 2,
#			'DESTINATION' => 'www.test.com/build/'
#		},
#		{
#			'NAME' => '.tell_people',
#			'RUN' => 'echo \'Built Vishnu test\' | mail gbarcouy@gmail.com'
#		}
#	],
#	'PROJECT' => {
#		'BASE' => 'tests/',
#		'NAME' => 'Vishnu test',
#		'AFTER' => '.tell_people',
#		'GIT_TREEISH' => 'release',
#		'BEFORE' => ''
#	},
#	'CONFIG' => {
#		'statics' => $VAR1->{'FILE_GROUPS'}[0],
#		'PROJECT' => $VAR1->{'PROJECT'},
#		'.tell_people' => $VAR1->{'FILE_GROUPS'}[2],
#		'generated' => $VAR1->{'FILE_GROUPS'}[1]
#	}
#};

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

		#set NAME attribute to all file groups
		$stash->{CONFIG}->{$config_element}->{NAME} = $config_element;
		
		#check for non array files and convert to single element array
		if ( defined $stash->{CONFIG}->{$config_element}->{FILES} && ref $stash->{CONFIG}->{$config_element}->{FILES} ne 'ARRAY' ) {
			$stash->{CONFIG}->{$config_element}->{FILES} = [ $stash->{CONFIG}->{$config_element}->{FILES} ];
		}

		if ( defined $stash->{CONFIG}->{$config_element}->{ORDER} && isdigit $stash->{CONFIG}->{$config_element}->{ORDER} ) {
			#all others are file groups to process
			push @{$stash->{FILE_GROUPS}}, $stash->{CONFIG}->{$config_element}
		} else {
			#put unordered groups apart to add on list tail
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

1;