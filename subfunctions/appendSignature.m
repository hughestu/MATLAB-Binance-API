function queryString = appendSignature(queryString,skey)

signature = HMAC(skey,queryString);
queryString = [queryString '&signature=' signature];

