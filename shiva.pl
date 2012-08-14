#!/usr/bin/perl

use FindBin;
use lib $FindBin::Bin;

# ====== SHIVA ===============================================================
use strict;
use warnings;
use utf8;
our $VERSION = "0.01";

# ============================================================================
use Getopt::Long;
use Log::Log4perl qw/:easy/;
use Trimurti::Shiva::Config;
use Trimurti::Shiva::FileGroup;
# ============================================================================

# ============================================================================
# MAIN
# ============================================================================
sub main {
	my $old_dir =  Cwd::getcwd;
	my $logger = setup_logging();
	$logger -> info('Starting Shiva ' . $VERSION);

	$logger -> info('Reading config file');
	my $config = Trimurti::Shiva::Config::read_project_config('.shiva');
	
	my $stash = Trimurti::Shiva::Config::build_stash( $config );

	chdir( $stash->{PROJECT}->{BASE} );
	
	if ( defined $stash->{CONFIG}->{$stash->{PROJECT}->{BEFORE}} ) {
		$logger -> info('Processing file group BEFORE ' . $stash->{PROJECT}->{BEFORE});
		Trimurti::Shiva::FileGroup::process( $stash->{CONFIG}->{$stash->{PROJECT}->{BEFORE}} ) 
	}
	
	foreach my $file_group ( @{$stash->{FILE_GROUPS}} ) {
		#process non hidden file groups
		if ( $file_group->{NAME} !~ /^\./ ) {
			$logger -> info('Processing file group ' . $file_group->{NAME} );
			$stash->{THIS}->{FILE_GROUP} = $stash->{CONFIG}->{$file_group->{NAME}};
			Trimurti::Shiva::FileGroup::shiva( $stash );
			undef $stash->{THIS}->{FILE_GROUP};
		} else {
			$logger -> info('Skipping hidden file group ' . $file_group->{NAME} );
		}
	}
	
	if ( $stash->{CONFIG}->{$stash->{PROJECT}->{AFTER}} ) {
		$logger -> info('Processing file group AFTER ' . $stash->{PROJECT}->{AFTER});
		Trimurti::Vishnu::FileGroup::vishnu( $stash );
	}
	
	$logger -> info('Will process ' . $config->{PROJECT}->{NAME} );
	
	$logger -> info('Ending Vishnu ' . $VERSION);
	
	chdir( $old_dir );
}

# ============================================================================
# Internals
# ============================================================================

sub setup_logging {
	# ==========================================================================
	# Get logger
	# ==========================================================================
	Log::Log4perl -> easy_init({
		level => $INFO,
		layout => '[%d] [%p] line %L: %m%n',
	});
	my $logger = Log::Log4perl -> get_logger();
	return $logger;
}

# ============================================================================
main( @ARGV ) unless caller();
# ============================================================================