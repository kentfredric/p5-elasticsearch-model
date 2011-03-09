package ElasticSearch::Model::Role;
use Moose::Role;
use ElasticSearch;
use ElasticSearch::Model::Index;

has es => ( is => 'rw', lazy_build => 1 );

sub _build_es {
    ElasticSearch->new( servers   => '127.0.0.1:9200',
                        transport => 'http',
                        timeout   => 30, );
}

sub deploy {
    my ( $self, %params ) = @_;
    my $t = $self->es->transport;
    foreach my $name ( $self->meta->get_index_list ) {
        my $index = $self->index($name);
        eval { $t->request( { method => 'DELETE', cmd => "/$name", } ); };
        $t->request(
                     { method => 'PUT',
                       cmd    => "/$name",
                       data   => $index->deployment_statement,
                     } );
    }
    return 1;
}

sub request {
    my ( $self, $path, $body ) = @_;

}

1;