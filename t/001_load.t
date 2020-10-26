# t/001_load.t - check module loading and create testing directory

use Test2::Bundle::More;
use Test2::Tools::Class;
use Test2::Tools::Exception qw/dies lives/;
use strict;
use warnings;
use Google::Chat::WebHooks;

like(dies { my $object = Google::Chat::WebHooks->new(); }, qr/parameter 'room_webhook_url' must be supplied to new/, "Got exception");
my $room;
ok(lives { $room = Google::Chat::WebHooks->new(room_webhook_url => "notanemptystring"); }) or note($@);
isa_ok($room, 'Google::Chat::WebHooks');

done_testing();
