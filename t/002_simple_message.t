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
my $url = $server->url_base();
#~ my $url = "http://127.0.0.1:10037";
my $received_message;
my $known_fields = {"text" => 1};
 
my $handle_request_phase1 = sub {
    my ($request, $response) = @_;
		if($request->method eq "POST")
		{
			if($request->header("Content-Type") eq "application/json")
			{
				#~ diag("Content type is JSON");
				my $decoded_content = decode('UTF-8', $request->content, Encode::FB_CROAK);
				my $json = decode_json($decoded_content);
				if(defined($json))
				{
					foreach my $field (keys %$json)
					{
						unless($known_fields->{$field})
						{
							$response->code("400"); $response->message("Bad Request");
							my $reply_json = encode_json({
								error => {
									code => 400,
									message => "Invalid JSON payload received. Unknown name \"somerubbush\" at 'message': Cannot find field.",
									status => "INVALID_ARGUMENT",
									details => [
										{
											'@type' => "type.googleapis.com/google.rpc.BadRequest",
											fieldViolations => [
												{
													field => "message",
													description => "Invalid JSON payload received. Unknown name \"$field\" at 'message': Cannot find field."
												}
											]
										}
									]
								}
							});
							$response->content(encode("utf8", $reply_json));
							return;
						}
					}
					diag(dump($json));
				}
				else { $response->code("400"); $response->message("Bad Request"); }
			}
			else { $response->code("415"); $response->message("Unsupported Media Type"); }
		}
		else { $response->code("405"); $response->message("Method Not Allowed"); }
};
$server->start_mock_server($handle_request_phase1);

my $room;
ok(lives { $room = Google::Chat::WebHooks->new(room_webhook_url => $url); }, "Object created with valid URL") or note($@);
isa_ok($room, 'Google::Chat::WebHooks');
my $response;
ok(lives {
	$response = $room->simple_message("test");
	$response = undef unless $response;
}, "Simple message doesn't die") or note($@);
ok(defined($response), "Method returns something");
ok(ref($response) eq "HASH", "Method returns a hash ref");
ok($response->{'result'} == 1, "Result was successful") or note(dump($response));
ok($response->{'message'} eq 'success', "Result message is correct") or note(dump($response));

# Connection refused
$room->room_webhook_url("https://127.0.0.100:35723"); # hopefully nothing running here
ok(lives { 
	$response = $room->simple_message("test");
	diag(dump($response));
}, "Times out nicely when connection refused") or note($@);
ok(defined($response), "Method returns something");
ok(ref($response) eq "HASH", "Method returns a hash ref");
ok($response->{'result'} == 0, "Result was unsuccessful") or note(dump($response));
ok(defined($response->{'message'}), "Result has a message") or note(dump($response));

# Server not responding
$room->room_webhook_url("https://192.0.2.0:35723"); # RFC5737 test addresses
$room->timeout(3);
ok(lives { 
	$response = $room->simple_message("test");
	diag(dump($response));
}, "Times out nicely when connection refused") or note($@);
ok(defined($response), "Method returns something");
ok(ref($response) eq "HASH", "Method returns a hash ref");
ok($response->{'result'} == 0, "Result was unsuccessful") or note(dump($response));
ok(defined($response->{'message'}), "Result has a message") or note(dump($response));

done_testing();
