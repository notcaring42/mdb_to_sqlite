#!/usr/bin/perl -w
use strict;
use warnings;
use Getopt::Long;

my $auto_overwrite = '';
my $help = '';
GetOptions ('auto-overwrite!' => \$auto_overwrite,
            'help!' => \$help);

# Make sure we have two arguments
my $num_args = $#ARGV + 1;
if ($num_args != 2 || $help) {
    print "Wrong number of arguments (got $num_args, need 2)\n" 
      if (!$help);
    print "Usage: mdb_to_sqlite.pl [--auto-overwrite] MDB_FILE OUT_FILE\n";
    exit;
}
my ($mdb_name, $outdb_name) = @ARGV;

# If the file exists...
if (-e $outdb_name) {
    if ($auto_overwrite) {
        print "$outdb_name will be overwritten.\n";
        `rm $outdb_name`;
    }
    else {
        my $overwrite;

        # Ask user whether they want to overwrite the file
        # Keep looping until we get a valid answer
        while (1) {
            print "$outdb_name exists! Overwrite? (Y/N) ";
            $overwrite = <STDIN>;

            last if $overwrite =~ m/^(y|n)$/i;

            print "Didn't understand input...\n";
        }

        if ($overwrite =~ m/^y$/i) {
            print "$outdb_name will be overwritten.\n";
            `rm $outdb_name`;
        }
        elsif ($overwrite =~ m/^n$/i) {
            print "Aborting...\n";
            exit;
        }
    }
}

# Generate the schema, initializing the database
print "Generating schema...\n";
`mdb-schema $mdb_name | sqlite3 $outdb_name`;
print "Schema has been generated.\n";

# Export the data from each table
my @tables = split "\n", `mdb-tables -1 $mdb_name`;
for (@tables) {
    print "Exporting data from table $_...\n";
    `mdb-export $mdb_name $_ >> out.csv`;
    `sqlite3 -separator "," $outdb_name '.import out.csv $_'`;
    `rm out.csv`;
}
print "$mdb_name has been exported to $outdb_name.\n";
