package SpaceBotWar::Web::User;
use Mojo::Base 'Mojolicious::Controller';

# Web service
sub user {

}



sub login {
    my $self = shift;
    my $name = $self->param('username');
    my $pass = $self->param('password');
    my $from = $self->param('from_url');

    my $schema = $self->schema;

    my $user = $schema->resultset('User')->single({name => $name});
    if ($user and $user->check_password($pass)) {
        $self->humane_flash( 'Welcome Back!' );
        $self->session->{id} = $user->id;
        $self->session->{username} = $name;
    } else {
        $self->humane_flash( 'Sorry unknown username/password combination. Please try again.' );
    }
    $self->app->log->debug("REDIRECT to: $from");
    $self->redirect_to( $from );
}

sub logout {
    my $self = shift;
    $self->session( expires => 1 );
    $self->humane_flash( 'Goodbye' );
    $self->redirect_to( $self->home_page );
}

1;

