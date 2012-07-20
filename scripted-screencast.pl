#!/usr/bin/env perl
use v5.10;
use strict;
use warnings;
use autodie;

# stuff we need
use Cwd qw/getcwd/;
use File::Slurp qw/read_file/;
use IO::Prompt qw/prompt hand_print/;
use Term::ANSIColor qw/colored/;
STDOUT->autoflush(1);
STDERR->autoflush(1);

# get command arguments and static data
my ( $file, $video, @rec_options ) = @ARGV;
unless ( defined($file) && defined($video) && -r $file ) {
  die "Usage: $0 <shell-file> <video-output-file>\n";
}
my $hostname = `hostname`;
chomp $hostname;

# fork screen recorder to background
if ( my $pid = fork ) { # parent

  # setup
  local $SIG{INT} = sub { kill 15, $pid; wait; exit };
  1 until prompt( "Type 'start' to start\n", -w => 'start', '-tty' );
  system("clear");

  # iterate commands
  for my $cmd ( read_file( $file, { chomp => 1 } ) ) {

    # ignore comments
    next if $cmd =~ /^#/;

    # fake a prompt and typing
    print cmd_prompt();
    prompt( -echo => '', -nl => '', '-tty' );
    hand_print( { -speed => 0.25 }, "$cmd" );
    prompt( -echo => '', -nl => '', '-tty' );
    say '';

    # special case chdir or pass through to system
    if ( $cmd =~ /^cd (.*)/ ) {
      chdir $1;
    }
    else {
      system($cmd);
    }
  }

  # teardown
  print cmd_prompt();
  prompt('-tty');
  say "Ending recording; please wait for recorder to shut down...";
  kill 15, $pid;
  wait;
  say "Done";
}
else { # child
  open STDIN,  "<", "/dev/null";
  open STDOUT, ">", "/dev/null";
  open STDERR, ">", "/dev/null";
  exec("recordmydesktop -o $video --on-the-fly-encoding @rec_options");
}

# fake my personal command prompt
sub cmd_prompt {
  my $error = shift;
  ( my $cwd = getcwd ) =~ s/\Q$ENV{HOME}\E/~/;
  return
      colored( "▪", $error ? 'bold red' : 'bold green' ) . " ["
    . colored( "david\@$hostname", 'cyan' ) . "] "
    . $cwd . "\n\$ ";
}

