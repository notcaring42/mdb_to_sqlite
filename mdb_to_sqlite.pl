use strict;
use warnings;

my $mdb_name = "flanders.mdb";
my $outdb_name = "flanders.db";

# Generate the schema
print "Generating schema...\n";
`mdb-schema $mdb_name | sqlite3 $outdb_name`;
print "Schema has been generated.\n";

# Copy data from tables
my @tables = split "\n", `mdb-tables -1 $mdb_name`;
for (@tables) {
    print "Exporting data from table $_...\n";
    `mdb-export $mdb_name $_ >> out.csv`;
    `sqlite3 -separator "," $outdb_name '.import out.csv $_'`;
    `rm out.csv`;
}
print "$mdb_name has been exported to $outdb_name.\n";
