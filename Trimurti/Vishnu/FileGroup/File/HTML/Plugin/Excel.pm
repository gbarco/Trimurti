package Trimurti::Vishnu::FileGroup::File::HTML::Plugin::Excel;

use Template::Plugin;
use base qw( Template::Plugin );

use Spreadsheet::ParseExcel::Simple;

sub new {
    my ($class, $context, @params) = @_;
		
    bless {
        _CONTEXT => $context,
        _PARAMS => \@params,
    }, $class;
}

sub excel {
    my ($self, $file) = @_;

		my @data;
		
		my $excel = Spreadsheet::ParseExcel::Simple->read( $file );
		
		foreach my $sheet ($excel->sheets) {
			while ( $sheet->has_data() ) {
        my @data = $sheet->next_row;
			}
		}
		
		return @data;
}

1;