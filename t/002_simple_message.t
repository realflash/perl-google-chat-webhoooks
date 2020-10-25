use Test2::Bundle::More;
use Test2::Tools::Class;
use Test2::Tools::ClassicCompare;
use Test2::Tools::Exception qw/dies lives/;
use strict;
use warnings;
use Google::Chat::WebHooks;
use Test::HTTP::MockServer;
 
my $server = Test::HTTP::MockServer->new();
my $url = $server->url_base();
 
my $handle_request_phase1 = sub {
    my ($request, $response) = @_;
		if($request->method eq "POST")
		{
			diag("Got POST request")
		}
		else
		{
			$response->code("405");
			$response->message("Method Not Allowed");
		}
};
$server->start_mock_server($handle_request_phase1);

my $room;
ok(lives { $room = Google::Chat::WebHooks->new(room_webhook_url => $url); }, "Object created with valid URL");
isa_ok($room, 'Google::Chat::WebHooks');
my $response;
ok(lives { $response = $room->simple_message("test"); }, "Simple message doesn't die");
isnt($response, undef, "Method returns something");

done_testing();
