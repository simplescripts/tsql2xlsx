use strict;
use DBI;
use Excel::Writer::XLSX;;
use Data::Dumper;
use Config::Simple;
use TSQLCmd qw( get_tsql_query get_query_name );

if(@ARGV!=1){
    print "Any one of the following arguement is required:\n";
    print "$_\n" for get_query_name();
    exit;
}

my $query_name=$ARGV[0];

unless(grep /^$query_name$/, get_query_name()){
    print "Valid arguements are:\n";
    print "$_\n" for get_query_name();
    exit;
}
my $row = 0;
my $workbook = Excel::Writer::XLSX->new( $query_name.'.xlsx' );
$workbook->set_optimization();
my $worksheet;

my $cfg = new Config::Simple('db2xmlx.conf');
my $uid= $cfg->param('uid');
my $pwd= $cfg->param('pwd');
my $db=$cfg->param('database');
my $server=$cfg->param('server');
my $trusted=$cfg->param('trusted');
          
my $dbh = DBI->connect("DBI:ODBC:Driver={SQL Server};Server=$server;Database=$db;Trusted_Connection=$trusted;UID=$uid;PWD=$pwd") || die("\n\nCONNECT ERROR:\n\n$DBI::errstr");
$dbh->{odbc_exec_direct} = 1;
$dbh->do("USE $db");
my $allquery=get_tsql_query($query_name);
for my $query_name (sort keys %$allquery)
{
    $row = 0;
    $worksheet=$workbook->add_worksheet("$query_name");
    generate_xlsx(${$allquery}{$query_name});
}

$dbh->disconnect;

sub generate_xlsx{
    my ($query)= @_; 
    my $sth=$dbh->prepare($query);    
    $sth->execute();
    my @Header=@{$sth->{NAME}};

    write2xlsx(\@Header);
    while ( my $row = $sth->fetchrow_arrayref ){
        write2xlsx($row);
    }
}

sub write2xlsx
{
    my $fields = shift;
    my $col = 0;
        for my $data ( @$fields )
        {
            $worksheet->write_string( $row, $col, "$data" );
            $col++;
        }
        $row++;
}


