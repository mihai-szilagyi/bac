package Functions;

use strict;
use warnings;

use Exporter 'import';
use JSON::XS;
use LWP::UserAgent;
use HTTP::Request;
use HTML::Scrubber;
use XML::XPath;
use XML::XPath::XMLParser;
use TryCatch;
use Log::Log4perl;
use Parallel::Loops;
use HTTP::Async;
use Time::HiRes qw(tv_interval gettimeofday);
our @EXPORT_OK = qw(save getHtml parse getPageNumbers loadConf get__EVENTVALIDATION get__VIEWSTATE);
use Encode;
use Data::Dumper;
# init logging 
Log::Log4perl->init("log.conf");
my $log = Log::Log4perl->get_logger("Functions");

my $maxProcs = 5;
my $pl = Parallel::Loops->new($maxProcs);
my $ua = LWP::UserAgent->new;
my @keys = ("id", "name", "local_rank","global_rank", "school", "is_previous","form","speciality",
                "romanian_competence","romanian_written","romanian_appeal","romanian_final",
                "maternal_language","modern_language","modern_language_grade", "profile","choice","digital","media","final_result",            
                "maternal_competence","maternal_written","maternal_appeal","maternal_final",
                "profile_written","profile_appeal","profile_final",
                "choice_written","choice_appeal","choice_final"); 

my @default = (
    0 =>
        {
           'class' => 1,
           'value' => 1,
           'id'    => 1
        }
    );
my $uri = "http://127.0.0.1:5984/bac_2015/_bulk_docs";
my $scrubber = HTML::Scrubber->new( allow => [ qw[ table td option html br input head body] ], default => \@default);

sub loadConf {
    my $filename = 'conf.json';

    my $json_text = do {
       open(my $json_fh, "<:encoding(UTF-8)", $filename)
          or die("Can't open \$filename\": $!\n");
       local $/;
       <$json_fh>
    };

    my $conf = decode_json($json_text);
    return $conf;
}

=head2 parse
    convert the data from the html table into an array of hashes    
=cut
sub parse {
    my ($xp, $county ) = @_;
    # my $t0 = [gettimeofday];
    my $nodeset = $xp->find('//table[@class="mainTable"]/td[@class="tdBac"]');
    my $index = 0;
    my @data = ();

    my $hash = {};
    foreach my $td ($nodeset->get_nodelist) {
        $hash->{$keys[$index]} = $td->string_value;
        $index++;
    
        if($index == 30){
            $index = 0;
            $hash->{county} = $county;
            $hash->{_id} = $hash->{global_rank};
            $hash->{_id} =~ s/^\s+|\s+$//g ;
            push @data, $hash;
            $hash = {};
        }
    }

    # $log->error(tv_interval($t0));
    return \@data;
}

=head2 getPageNumbers
    return the available pages for a county
=cut
sub getPageNumbers{
    my $county_id = shift;
    
    $log->error("county id is $county_id");
    my $html = getHtml($county_id);
    my $xml = XML::XPath->new($html);
    my $page_nr_node = $xml->find('//option[last()]');
    my $page_nr = 1;

    foreach ($page_nr_node->get_nodelist) {
        $page_nr = $_->getAttribute('value');        
        last;
    }

    $log->error("county page nr for $county_id is $page_nr");
    return $page_nr;
}

=head2 get__VIEWSTATE
    return the __VIEWSTATE for a page
=cut
sub get__VIEWSTATE{ 
    my $xml = shift;
    my $viewstate = 1;

    try {
        my $input = $xml->find('//input[@id="__VIEWSTATE"]');
        
        foreach ($input->get_nodelist) {
            $viewstate = $_->getAttribute('value');        
            last;
        }
    } catch($err) {
        warn (Dumper $err);
    };
    return $viewstate;
}

=head2 __EVENTVALIDATION
    return the __EVENTVALIDATION for a page
=cut
sub get__EVENTVALIDATION {
    my $xml = shift;   
    my $eventvalidation = 1;

    try{
        my $input = $xml->find('//input[@id="__EVENTVALIDATION"]');
        
        foreach ($input->get_nodelist) {
            $eventvalidation = $_->getAttribute('value');        
            last;
        }
    } catch($err) {
        warn (Dumper $err);
    }
    return $eventvalidation;
}

=head2 getHtml
    get the html as string 
=cut 
sub getHtml {
    my ( $county_id , $page , $__EVENTVALIDATION , $__VIEWSTATE) = @_;
    
    my $html = "";
    my $uri = "http://bacalaureat.edu.ro/Pages/JudetRezultAlfa.aspx?jud=$county_id"; 
    
    if($page){
        my $params = {
            'ctl00$ContentPlaceHolderBody$DropDownList2' => $page,
            '__EVENTVALIDATION' => $__EVENTVALIDATION,
            '__VIEWSTATE'   => $__VIEWSTATE
        };
        $html = $ua->post($uri, $params )->content;
    }else{
        $html = $ua->get($uri)->content;
    }
    
    my $str = $scrubber->scrub(decode_utf8 $html);
    $str =~ s/&nbsp;/ /g;
    $str =~ s/<br \/>/ /g;

    return $str;

}

=head2 save
    access method to save to couch db
=cut
sub save {
    my ($data) = @_;
    my $json = encode_json({ "docs" => $data});
    my $req = HTTP::Request->new( 'POST', $uri );
    $req->header( 'Content-Type' => 'application/json' );
    $req->content( $json );
    $ua->request($req);
    
}

1;