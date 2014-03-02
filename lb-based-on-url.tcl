# Author: Radoslaw Tomaszewski 
# Purpose: Balance traffic based on URI.

when CLIENT_ACCEPTED {
    set DEFAULT_POOL [LB::server pool]
}

when HTTP_REQUEST {
    set DEBUG 0
    set LOG_PREFIX [IP::client_addr]
    set URI [string tolower [HTTP::uri]]

    if { $DEBUG } { log local0. "$LOG_PREFIX: HTTP\:\:uri eq [string tolower [HTTP::uri]]" }

    switch -glob $URI {
        "/test*"         { set MYPOOL "pool-vip-80-url1" }
        "/integration*"  { set MYPOOL "pool-vip-80-url2" }
        "/production*"   { set MYPOOL "pool-vip-80-url3" }
        default          { set MYPOOL $DEFAULT_POOL }
    }

    pool $MYPOOL
    if { $DEBUG } { log local0. "$LOG_PREFIX: sent request to pool $MYPOOL" }

    unset DEBUG
    unset LOG_PREFIX
    unset URI
    unset DEFAULT_POOL
    unset MYPOOL
}
