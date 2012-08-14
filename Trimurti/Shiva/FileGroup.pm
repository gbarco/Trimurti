package Trimurti::Shiva::FileGroup;

use lib '../../';
# ============================================================================
# Handles configuration 
# ============================================================================
use strict;
use warnings;
use Carp qw( croak );
use File::Glob;

# ============================================================================
use Trimurti::Shiva::Credentials;
use Trimurti::Shiva::FileGroup::SFTP;

# ============================================================================
require Exporter;
use vars qw($VERSION @ISA @EXPORT);

@ISA = qw(Exporter);
@EXPORT = qw(shiva);

# ============================================================================
sub shiva {
	my ( $stash ) = @_;
	
	foreach my $file ( @{$stash->{THIS}->{FILE_GROUP}->{FILES}}) {
		$stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{URI} = $stash->{THIS}->{FILE_GROUP}->{DESTINATION};
		$stash->{THIS}->{FILE_GROUP}->{DESTINATION} =~ m#(?:(s3|file|scp|sftp|ssh|rsync|telnet|http|https|ftp|ftps)://)+((?:[a-zA-Z0-9\._-]+\.[a-zA-Z]{2,6})|(?:[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(?::([0-9]+))?(/[a-zA-Z0-9\&amp;%_\./-~-]*)?#;
		$stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{PROTOCOL} = lc $1;
		$stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{HOST} = lc $2;
		$stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{PORT} = $3;
		$stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{PATH} = $4; #this is case sensitive
		
		my $protocol_dispachers = {
			s3=>\&Trimurti::Shiva::FileGroup::Unimplemented::shiva,
			file=>\&Trimurti::Shiva::FileGroup::Unimplemented::shiva,
			scp=>\&Trimurti::Shiva::FileGroup::Unimplemented::shiva,
			sftp=>\&Trimurti::Shiva::FileGroup::SFTP::shiva,
			ssh=>\&Trimurti::Shiva::FileGroup::Unimplemented::shiva,
			rsync=>\&Trimurti::Shiva::FileGroup::Unimplemented::shiva,
			telnet=>\&Trimurti::Shiva::FileGroup::Unimplemented::shiva,
			http=>\&Trimurti::Shiva::FileGroup::Unimplemented::shiva,
			ftp=>\&Trimurti::Shiva::FileGroup::Unimplemented::shiva,
			ftps=>\&Trimurti::Shiva::FileGroup::Unimplemented::shiva,
			https=>\&Trimurti::Shiva::FileGroup::Unimplemented::shiva,
			_unimplemented=>\&Trimurti::Shiva::FileGroup::Unimplemented::shiva,
		};
		
		my $credentials = Trimurti::Shiva::Credentials::read_credentials( $stash->{THIS}->{FILE_GROUP}->{CREDENTIALS} );
		
		$stash->{THIS}->{FILE}->{NAME} = $file;
		$stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{CREDENTIALS} = $credentials->{ $stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{URI} };
		
		$protocol_dispachers->{$stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{PROTOCOL}}( $stash );		
		
		$stash->{THIS}->{FILE_GROUP}->{DESTINATION} = $stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{URI};
		undef $stash->{THIS}->{FILE}->{NAME};
	}
}

1;