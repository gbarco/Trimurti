#!/usr/bin/perl

use FindBin;
use lib $FindBin::Bin;

# ====== VISHNU =============================================================
use strict;
use warnings;
use utf8;
our $VERSION = "0.01";

# ============================================================================
use Config::Simple;
use Getopt::Long;
use Log::Log4perl qw/:easy/;
# ============================================================================

# ============================================================================
# MAIN
# ============================================================================
sub main {
	#(plugin:)?((?:s3|file|scp|rsync|ssh|telnet|http|ftp|https|ftps|sftp)://)+((?:[a-zA-Z0-9\._-]+\.[a-zA-Z]{2,6})|(?:[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:(?:[0-9]+))?(/[a-zA-Z0-9\&amp;%_\./-~-]*)?
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