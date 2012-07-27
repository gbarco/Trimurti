#!/usr/bin/perl

# ====== VISHNU =============================================================
use strict;
use warnings;
use utf8;
our $VERSION = "0.01";

# ============================================================================
use Config::Simple;
use Getopt::Long;
use Log::Log4perl qw/:easy/;
use Trimurti::Vishnu::Config;
use Trimurti::Vishnu::FileGroup;
use Data::Dumper;
# ============================================================================

# ============================================================================
# MAIN
# ============================================================================
sub main {
	my $logger = setup_logging();
	$logger -> info('Starting Vishnu ' . $VERSION);

	$logger -> info('Reading config file');
	my $config = Trimurti::Vishnu::Config::read_project_config('tests/.vishnu');

	$logger -> info('Building stash');
	my $stash	= Trimurti::Vishnu::Config::build_stash( $config );
	
	print Data::Dumper::Dumper( $stash );
	
	if ( defined $stash->{CONFIG}->{$stash->{PROJECT}->{BEFORE}} ) {
		$logger -> info('Processing file group BEFORE ' . $stash->{PROJECT}->{BEFORE});
		Trimurti::Vishnu::FileGroup::process( $stash->{CONFIG}->{$stash->{PROJECT}->{BEFORE}} ) 
	}
	
	foreach my $file_group ( @{$stash->{FILE_GROUPS}} ) {
		#process non hidden file groups
		if ( $file_group->{NAME} !~ /^\./ ) {
			$logger -> info('Processing file group ' . $file_group->{NAME} );
			$stash->{THIS}->{FILE_GROUP} = $stash->{CONFIG}->{$file_group->{NAME}};
			Trimurti::Vishnu::FileGroup::vishnu( $stash );
			undef $stash->{THIS}->{FILE_GROUP};
		} else {
			$logger -> info('Skipping hidden file group ' . $file_group->{NAME} );
		}
	}
	
	if ( $stash->{CONFIG}->{$stash->{PROJECT}->{AFTER}} ) {
		$logger -> info('Processing file group AFTER ' . $stash->{PROJECT}->{AFTER});
		Trimurti::Vishnu::FileGroup::vishun( $stash->{CONFIG}->{$stash->{PROJECT}->{AFTER}} ) 
	}
	
	$logger -> info('Will process ' . $config->{PROJECT}->{NAME} );
	
	$logger -> info('Ending Vishnu ' . $VERSION);
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

