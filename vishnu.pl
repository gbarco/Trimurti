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

