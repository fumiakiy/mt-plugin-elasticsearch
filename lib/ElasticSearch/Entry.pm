package ElasticSearch::Entry;
use strict;
use warnings;

use MT;
use JSON::XS;
use HTTP::Request;
use HTTP::Request::Common qw( PUT );

my $endpoint = 'http://localhost:9200/my_blog/post/';

sub entry_post_save {
    my ( $cb, $entry, $original ) = @_;
    my $app    = MT->instance;

    my $ua = MT->new_ua;
    my $data = JSON::XS::encode_json({
        'author' => $entry->author->nickname
        , 'created_on' => $entry->created_on
        , 'body' => $entry->text . $entry->text_more
        , 'title' => $entry->title
    });

    my $request = HTTP::Request->new( PUT => $endpoint . $entry->id );
    $request->content( $data );
    $app->log(
        {   message  => $data,
            level    => MT::Log::INFO(),
            class    => 'system',
            category => 'elasticsearch'
        }
    );
    my $response = $ua->request( $request );
    $app->log(
        {   message  => $response->content,
            level    => MT::Log::INFO(),
            class    => 'system',
            category => 'elasticsearch'
        }
    );
    return;
}
