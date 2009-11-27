? extends 'Base'

<? block code => q{
has 'foo' => (
    is          => 'ro',
    isa         => 'Str',
    default     => 'foo',
);

sub baz {
    return 'baz';
}
} ?>;
