# Introduction

This plugin will allow you to check if your HD Homerun is currently tuned to any channels.  This could 
be useful if you want to upgrade for example a Plex server that is currently recording.  One glance
in nagios could tell you if recording is in progress.

# Example

bash check_hdhomerun.sh -f <response text> -i <hdhomerun_id> -t <tuner> -c <command> -s <subcommand> -x <additonal subcommands> -y <additonal subcommands> -z <additonal subcommands>

bash check_hdhomerun.sh -f none -i HDHR_ID -t 2 -c get -s status -x vchannel -y lockkey

Example of tuner not busy: 
	
status: ch=none lock=none ss=0 snq=0 seq=0 bps=0 pps=0

Example of tuner busy:
	
status: ch=8vsb:527000000 lock=8vsb ss=54 snq=82 seq=100 bps=5373792 pps=460
vchannel: 2.1
lockkey: 192.168.33.30
	
# Requirements

* hdhomerun-config

# Installation

Install and test hdhomerun-config
```
# apt install hdhomerun-config
# hdhomerun_config discover
hdhomerun device abcd1234 found at 192.168.0.37
```

```
Install check_hdhomerun plugin
# cd /tmp
# git clone https://github.com/mzac/check_hdhomerun.git
```

Copy the check_hdhomerun.sh into your CustomScriptDir or wherever you have your scripts

# Configuration for Icinga2

```
object CheckCommand "check-hdhomerun" {
	import "plugin-check-command"

	command = [ CustomScriptDir + "/check_hdhomerun.sh" ]

	arguments = {
		"-i" = "$address$"
	}
}

object HostGroup "hdhomerun" {
  display_name = "hdhomerun"
}

apply Service "HDHomerun Tuner" {
	import "generic-service"
	check_command = "check-hdhomerun"
	
	enable_notifications = false
	
	assign where "hdhomerun" in host.groups
}
```

```
object Host "hr1" {
  import "generic-host"

  address = "192.168.0.37"

  groups = [ "hdhomerun" ]
}
```
