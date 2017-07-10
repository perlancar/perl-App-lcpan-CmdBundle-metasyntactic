package App::lcpan::Cmd::metasyntactic_themes;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;
use Log::ger;

require App::lcpan;

our %SPEC;

$SPEC{handle_cmd} = {
    v => 1.1,
    summary => 'List all Acme::MetaSyntactic theme modules',
    args => {
        %App::lcpan::common_args,
        %App::lcpan::detail_args,
        %App::lcpan::fauthor_args,
    },
};
sub handle_cmd {
    my %args = @_;
    my $res = App::lcpan::modules(%args, namespaces => ['Acme::MetaSyntactic']);
    return $res unless $res->[0] == 200;
    my @fres;
    for my $item (@{ $res->[2] }) {
        my $mod = $args{detail} ? $item->{module} : $item;
        next unless $mod =~ /^Acme::MetaSyntactic::[a-z0-9]/;
        if ($args{detail}) {
            ($item->{theme} = $mod) =~ s/^Acme::MetaSyntactic:://;
        } else {
            $item =~ s/^Acme::MetaSyntactic:://;
        }
        push @fres, $item;
    }
    $res->[2] = \@fres;
    unshift @{ $res->[3]{'table.fields'} }, 'theme';
    $res;
}

1;
# ABSTRACT:
