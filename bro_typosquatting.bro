#Author: Nick Hoffman / securitykitten.github.io / @infoseckitten
#Description:  A bro script to find typosquatted domain names within DNS requests

module TYPOSQUAT;

export {
    redef enum Notice::Type += { Typosquat, };
    const legit_domains: set [string] &redef;
    redef legit_domains = {"google.com","microsoft.com"};
}

event dns_request(c: connection, msg: dns_msg, query: string, qtype: count, qclass: count) {
	local dist: double;
	for ( i in legit_domains ) {
		dist = levenshtein_distance(query,i);
		if ( 0 < dist && dist < 5) {
			NOTICE([$note=Typosquat,
				$msg = fmt("Request to typosquatted domain name %s",query),
				$conn=c]);
				
		}
	}
}
