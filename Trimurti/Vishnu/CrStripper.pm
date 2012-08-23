package Trimurti::Vishnu::CrStripper;

use base 'Template::Provider';

sub _template_content {
	my ($self,$path) = @_;
	my ($data,$error,$mod_date) = $self->SUPER::_template_content($path);

	# strip CR from CR+LF pairs
	$data =~ s/\r\n/\n/;

	return wantarray ? ($data,$error,$mod_date) : $data;
}

1;