#!/usr/bin/perl -w
use strict;
use warnings;
use Time::HiRes qw(tv_interval gettimeofday);
use File::Slurp;
use Functions qw(save getHtml parse getPageNumbers loadConf get__EVENTVALIDATION get__VIEWSTATE);
my $conf = loadConf();
# my $async = HTTP::Async->new;

sub serial_run {
    my ( $county, $pages ) = @_;
    $pages++;
    my ($__EVENTVALIDATION, $__VIEWSTATE ) = ("","");
    my $html = "";
    foreach my $page (0..$pages){
        warn $page if($page % 100 == 0);
        eval{
            $html = getHtml($county,$page , $__EVENTVALIDATION , $__VIEWSTATE);           
            my $xml = XML::XPath->new($html);
          
            $__EVENTVALIDATION = get__EVENTVALIDATION($xml);
            $__VIEWSTATE = get__VIEWSTATE($xml);

            my $data = parse($xml, $conf->{counties}->{$county});
            save($data);
                
        } or do {
            warn @$;
            warn "$page:$county";
          
        };
    }
}

sub run {
    foreach my $county(sort {$conf->{counties}->{$a} cmp $conf->{counties}->{$b}} keys %{$conf->{counties}}){
       serial_run($county,getPageNumbers($county)); 
    }
}
