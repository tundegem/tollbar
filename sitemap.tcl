#!/usr/bin/tclsh

if {$argc < 2} {
	error "$argv0 map-file node"
}

set fd [open [lindex $argv 0]]
set loc [lindex $argv 1]

while {![eof $fd]} {
	set l [split [gets $fd]]
	set names([lindex $l 0]) [join [lrange $l 2 end]]
	if {![info exists children([lindex $l 1])]} {
		set children([lindex $l 1]) [list]
	}
	if {![info exists children([lindex $l 0])]} {
		set children([lindex $l 0]) [list]
	}
	lappend children([lindex $l 1]) [lindex $l 0]
}
close $fd

foreach page [array names names] {
	set parents($page) [list]
}

foreach {page mchildren} [array get children] {
	foreach child $mchildren {
		lappend parents($child) $page
	}
}

proc do_level {level} {
	global children
	global parents
	global names
	global loc
	foreach child $children($level) {
		if {[string equal $child $loc]} {
			puts "		<li><a class=\"current\" href=\"$child\">$names($child)</a>"
			puts "			<ul>"
			foreach child2 $children($child) {
				puts "				<li><a href=\"$child2\">$names($child2)</a></li>"
			}
			puts "			</ul>"
			puts "		</li>"
		} elseif {[lsearch -exact $parents($loc) $child] > -1} {
			puts "		<li><a href=\"$child\">$names($child)</a>"
			puts "			<ul>"
			do_level $child
			puts "			</ul>"
			puts "		</li>"
		} else {
			puts "		<li><a href=\"$child\">$names($child)</a></li>"
		}
	}
}

do_level "ROOT"