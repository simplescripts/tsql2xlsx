package TSQLCmd;
use strict;
use warnings;
use Exporter;

our @ISA= qw( Exporter );

our @EXPORT = qw( get_tsql_query get_query_name );

#---- TSQL query comes here ----
my $table1=<<ENDSQL;
select * from dbo.table1 with (nolock);
ENDSQL

my table2 =<<ENDSQL;
 select * from dbo.table2 with (nolock);
ENDSQL

my $table3=<<ENDSQL;
select * from dbo.table3 with (nolock);
ENDSQL

my $table4=<<ENDSQL;
select * from dbo.table4 with (nolock);
ENDSQL

my $table5=<<ENDSQL;
select * from dbo.table5 with (nolock);
ENDSQL

my $table6 =<<ENDSQL;
select * from dbo.table6 with (nolock);
ENDSQL


#---- TSQL query ends here ----


my %queries=(
#---- Update query reference name here ----
    #ExcelWorkBook=>({WorkSheet1=>query1,WorkSheet1=>query1})
    
    WorkBook1=>(
    {
        sheet1=>$table1, 
        sheet2=>$table2,
        sheet3=>$table3,
        sheet4=>$table4,
    }
    ),
    
    WorkBook2=>(
    {
        sheet4=>$table4, 
        sheet5=>$table5,
        sheet6=>$table6,
        }
    ),
    

#---- query reference name ends here ----    
);


sub get_query_name
{
    return keys %queries;
}

sub get_tsql_query
{
    return $queries{+shift};
}


