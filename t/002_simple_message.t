use Test2::Bundle::More;
use Test2::Tools::Class;
use Test2::Tools::ClassicCompare qw/is is_deeply isnt like unlike cmp_ok/;
use Test2::Tools::Exception qw/dies lives/;
use strict;
use warnings;
use Google::Chat::WebHooks;
use Test::HTTP::MockServer;
use Data::Dump qw(dump);
use JSON;
use Encode qw(decode encode);

my $server = Test::HTTP::MockServer->new();
#~ my $url = $server->url_base();
my $url = "http://127.0.0.1:10037";
my $received_message;
 
#~ my $handle_request_phase1 = sub {
    #~ my ($request, $response) = @_;
		#~ if($request->method eq "POST")
		#~ {
			#~ if($request->header("Content-Type") eq "application/json")
			#~ {
				#~ diag("Content type is JSON");
				#~ my $decoded_content = decode('UTF-8', $request->data, Encode::FB_CROAK);
				#~ my $json = decode_json($decoded_content);
				#~ if(defined($json))
				#~ {
					#~ diag("Got some JSON");
				#~ }
				#~ else { $response->code("400"); $response->message("Bad Request"); }
			#~ }
			#~ else { $response->code("415"); $response->message("Unsupported Media Type"); }
		#~ }
		#~ else { $response->code("405"); $response->message("Method Not Allowed"); }
#~ };
#~ $server->start_mock_server($handle_request_phase1);

my $room;
ok(lives { $room = Google::Chat::WebHooks->new(room_webhook_url => $url); }, "Object created with valid URL") or note($@);
isa_ok($room, 'Google::Chat::WebHooks');
my $response;
ok(lives {
	$response = $room->simple_message("test");
	diag(dump($response));
	$response = undef unless $response;
}, "Simple message doesn't die") or note($@);
ok(defined($response), "Method returns something");
ok(ref($response) eq "HASH", "Method returns a hash ref");
ok($response->{'result'} == 1, "Result was successful");
ok($response->{'message'} eq 'success', "Result message is correct");

done_testing();
