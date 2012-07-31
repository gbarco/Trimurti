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
			@titles = $sheet->next_row if ( $sheet->has_data() );
			
			while ( $sheet->has_data() ) {
        my @row = $sheet->next_row;
				my $row;
				for( my $i=0; $i < @row; $i++ ) {
					$row->{$titles[$i]} = $row[$i];
				}
				push @data, $row;
			}
		}
		
		return @data;
}

1;