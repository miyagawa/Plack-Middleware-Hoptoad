use strict;
use Plack::Test;
use HTTP::Request::Common;
use Plack::Middleware::Hoptoad;
use Test::More;

my $app = sub { die "Oops" };
$app = Plack::Middleware::Hoptoad->wrap($app, api_key => "test");

my $xml;
local *AnyEvent::HTTP::http_post = sub {
    (my $url, $xml) = @_;
    my $cv = pop;
    $cv->send("Blah");
};

test_psgi $app, sub {
    my $cb = shift;
    $cb->(GET "/");

    like $xml, qr/Oops/;
};

done_testing;



