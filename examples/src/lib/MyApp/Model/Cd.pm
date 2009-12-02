? extends 'Base'

<? block code => q{
has 'price' => (
    is          => 'ro',
    isa         => 'Int',
    default     => 0,
);

sub play {
    return 'play music';
}
} ?>;
