package Google::Chat::WebHooks;
use strict;
use warnings;
use LWP::UserAgent;
use Class::Tiny qw(room_webhook_url _ua);
use Carp;

BEGIN {
    $VERSION     = '0.01';
}

sub BUILD
{	
	my ($self, $args) = @_;
	
	$self->_ua = LWP::UserAgent->new;
	$self->_ua->timeout(10);
	$self->_ua->env_proxy;
	
	croak "parameter 'room_webhook_url' must be supplied to new" unless $self->room_webhook_url;
}

#################### subroutine header end ####################

			#~ my $msg_json = "{\"text\": \"$msg\"}";
			#~ my $req = HTTP::Request->new('POST', $gc_hook);
			#~ $req->header('Content-Type' => 'application/json');
			#~ $req->content($msg_json);
			#~ my $response = $ua->request($req);
			#~ if($response->code !~ /^[2|3]/)
			#~ {
				#~ my $json = decode_json($response->decoded_content());
				#~ print Dumper $json;
				#~ exit 2;
			#~ }

#################### main pod documentation begin ###################

=head1 SYNOPSIS

  use Google::Chat::WebHooks;

  my $room = Google::Chat::WebHooks->new(room_webhook_url => 'https://chat.googleapis.com/v1/spaces/someid/messages?key=something&token=something');
  $room->simple_text("This is a message");
  $room->simple_text("Message with some *bold*");

=head1 DESCRIPTION

Google::Chat::WebHooks - Send notifications to Google Chat Rooms as provided by G-Suite. Does not work with Google Hangouts as used with your free Google account. Cannot receive messages - for that you need a bot. I'm sure I'll write that module some day. 

=head1 USAGE

Just create an object, passing the webhook URL of the room to which you want to send notifications. Then fire away. If you need help setting up a webhook for your room, see L<https://developers.google.com/hangouts/chat/how-tos/webhooks>.

=over 3
=item new(room_webhook_url => value)

Create a new instance of this class, passing in the webhook URL to send messages to. This argument is mandatory. Failure to set it upon creation will result in the method croaking. 

=item simple_text(string)

Send a message to the room. L<Basic formatting is available|https://developers.google.com/hangouts/chat/how-tos/webhooks>.

=item room_webhook_url(), room_webhook_url(value)

Get/set the URL of the room. 

=back
=head1 BUGS & SUPPORT

Please log them L<on GitHub|https://github.com/realflash/perl-google-chat-webhoooks/issues>.

=head1 AUTHOR

    I Gibbs
    CPAN ID: IGIBBS
    igibbs@cpan.org
    https://github.com/realflash/perl-google-chat-webhoooks

=head1 COPYRIGHT

This program is free software licensed under the...

	The General Public License (GPL)
	Version 3

The full text of the license can be found in the
LICENSE file included with this module.

=cut

#################### main pod documentation end ###################


1;
# The preceding line will help the module return a true value

