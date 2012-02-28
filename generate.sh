#!/bin/bash

OUTPUTDIR=$2
SOURCEDIR=$1
BASEHREF=$3
MAP=`mktemp`

for file in `find $SOURCEDIR -name \*.tmpl|sort` ; do
	. $file
	echo "$LOCATION $PARENT $PAGENAME" >>$MAP
done

for file in `find $SOURCEDIR -name \*.tmpl` ; do
	. $file
	if [ "`echo $LOCATION | cut -d: -f1`" != "http" ] ; then
		cat >$OUTPUTDIR/$LOCATION <<EOF
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
	<base href="$BASEHREF" />
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<link rel="stylesheet" type="text/css" href="andreas01.css" media="screen,projection" />
	<link rel="stylesheet" type="text/css" href="print.css" media="print" />
$EXTRAHEADER
	<title>Toll Bar Primary School - $PAGENAME</title>
</head>

<body>
<div id="wrap">

	<div id="header">
		<h1><img id="frontphoto" src="img/front.jpg" alt="Toll Bar Primary School" /></h1>
	</div>
	

	<div id="rightside">
		<h2 class="hide">Menu:</h2>
		
		<ul class="avmenu">
`./sitemap.tcl $MAP $LOCATION`
		</ul>
            <img src="img/butterfly.png" alt="" />
            <!-- Here's my badge to show support for Toll Bar Primary School. They raise funds with easyfundraising.org.uk -->
            <div style="text-align:center; margin-top: 1em;">
                <a href="http://www.easyfundraising.org.uk/causes/tollbarprimary/?badge=mycause_small-1_572JN5_PD12AS.png&amp;u=PD12AS&amp;urp=PD12AS" class="easyfundraisingBadge"><img src="http://www.easyfundraising.org.uk/images/thanks-for-badging/mycause_small-1_572JN5_PD12AS.png" border="0" alt="School Fundraising Ideas for Toll Bar Primary School"></a>
            </div>
	</div>

	<div id="contentwide2">
EOF
        if [ "$H1OVERRIDE" == "" ] ; then
            echo "	<h2>$PAGENAME</h2>" >>$OUTPUTDIR/$LOCATION
        else
            echo "  <h2>$H1OVERRIDE</h2>" >>$OUTPUTDIR/$LOCATION
        fi

	cat >>$OUTPUTDIR/$LOCATION <<EOF
$CONTENT
	</div>
	
	<div id="footer">
		<p><a href="http://www.ofsted.gov.uk/"><img src="img/ofsted.gif" alt="Ofsted" /></a>
                <img src="img/healthy_schools.jpg" alt="Healthy School" />
                <img src="img/basicskillslogo.jpg" alt="Quality Mark 2" />
                <img src="img/kitemarks_active.jpg" alt="Activemark 2008" />
                <img src="img/bsa.jpg" alt="Basic Skills Agency" />
                <img src="img/lg.jpg" alt="Learning gateways" />
                <img src="img/napta.jpg" alt="National Association of Professional Teaching Assistants" />
                <img src="img/fmsis.jpg" alt="Financial Management Standards in Schools" />
                <img src="img/foodforlife.png" alt="Food For Life Partnership - Bronze Award" />
                <br /><a href="http://www.sustrans.org.uk/what-we-do/bike-it"><img src="img/bikeit.gif" alt="We're a Sustrans Bike It school! | School Mark Bronze 2011/12 | Join the movement" /></a>
                <img src="img/creativepartnerships.jpg" alt="Creative Partnerships" />
                <img src="img/sysport.jpg" alt="South Yorkshire Sport" />
                <img src="img/everyoneswelcome.jpg" alt="Everyone's Welcome" />
                <img src="img/letsgetcooking.png" alt="Let's Get Cooking" />
                <br/><img src="img/olympics.jpg" alt="Living the Olympic and Paralympic values" />
                <img src="img/lppa.jpg" alt="Leading Parent Partnership Award" />
                <img src="img/nationalcollegeforschoolleadership.jpg" alt="National College for School Leadership" />
                <a href="http://www.travelsouthyorkshire.com/onboard/"><img src="img/onboard.jpg" alt="New for schools Everyone's on board Are you? Try it now" /></a>
                </p>
		<p><span>&copy; 2008-2012 <a href="http://www.pling.org.uk/">Chris Northwood</a></span><br />
		<a href="http://andreasviklund.com/templates/" title="Original CSS template design">Original design</a> by <a href="http://andreasviklund.com/" title="Andreas Viklund">Andreas Viklund</a></p>
	</div>

</div>
<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
var pageTracker = _gat._getTracker("UA-427161-5");
pageTracker._trackPageview();
</script>
</body>
</html>
EOF
	fi
	EXTRAHEADER=""
	LOCATION=""
	PAGENAME=""
	PARENT=""
	H1OVERRIDE=""
done
cat $MAP
rm $MAP
