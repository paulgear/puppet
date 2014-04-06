# collectd-bcache

This script collects [bcache](http://bcache.evilpiepirate.org/) SSD caching statistics and outputs it to STDOUT in a [Collectd Exec plugin](https://collectd.org/wiki/index.php/Plugin:Exec) compatible format.

## Usage

### Collectd

```
<Plugin exec>
    Exec "user:group" "/path/to/collectd-bcache"
</Plugin>
```

### Command-line (for testing)

```
$ ./collectd-bcache
PUTVAL "hostname.tld/bcache-bcache0/df_complex-dirty_data" interval=1 N:1258291
PUTVAL "hostname.tld/bcache-bcache0/cache_ratio-five_minute" interval=1 N:84.3373493976
PUTVAL "hostname.tld/bcache-bcache0/cache_ratio-hour" interval=1 N:49.3021427167
PUTVAL "hostname.tld/bcache-bcache0/cache_ratio-day" interval=1 N:80.6194966055
PUTVAL "hostname.tld/bcache-bcache0/cache_ratio-total" interval=1 N:82.8734501185
PUTVAL "hostname.tld/bcache-bcache0/requests-bypass_hits" interval=1 N:0
PUTVAL "hostname.tld/bcache-bcache0/requests-bypass_misses" interval=1 N:0
PUTVAL "hostname.tld/bcache-bcache0/requests-hits" interval=1 N:70
PUTVAL "hostname.tld/bcache-bcache0/requests-miss_collisions" interval=1 N:0
PUTVAL "hostname.tld/bcache-bcache0/requests-misses" interval=1 N:13
PUTVAL "hostname.tld/bcache-bcache0/requests-readaheads" interval=1 N:0
PUTVAL "hostname.tld/bcache-bcache0/bytes-bypassed" interval=1 N:0
```
