#!/usr/bin/perl -w
#----------------------------------------------------------------------------
# Description:
# Create the DSP Detail status html.
#----------------------------------------------------------------------------
# Revision History:
# 09/01/2018	Jay Gu		Release 2.0 :simplified the scripts and add the flexibility
#----------------------------------------------------------------------------

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time());
$mon++;
$year+=1900;

open HANDLE,"temp.txt";
open HTMLWRITE,">dsp_ipl_status_new.html";
open HTMLADD,">>dsp_ipl_status_new.html";
##############################define the standard variate########################################################
my @temp_array;
my $i=0;
my $WHITE_DEFAULT=White;
my $GREEN_OK="#92D050";
my $YELLOW_WARNING=Yellow;
my $RED_CRITICAL="#FF0000";
my $comments_1="ready";
my $comments_2="Time<5,waiting>0";
my $comments_3="5<Time<10,waiing>0";
my $comments_4="Time>10,waiting>0";
my $comments_5="Time<10,waiting>0";
my $comments_6="10<Time<60,waiting>0";
my $comments_7="Time>60,waiting>0";
my $head=qq{
	<html><head><meta http-equiv="content-type" content="text/html; charset=GBK"><meta http-equiv="refresh" content="10"><title>Dispatcher Detail Report</title></head><body><h3>Dispatcher Detail Report</h3><style>.detail_balbe {font-size: 18px; }
		body {                                                                                            
			width: 600px;                                                                                 
			margin: 40px auto;                                                                            
			font-family: 'trebuchet MS', 'Lucida sans', Arial;                                            
			font-size: 14px;                                                                              
			color: #444;                                                                                  
		}                                                                                                 
		table {                                                                                           
			*border-collapse: collapse; /* IE7 and lower */                                               
			border-spacing: 0;                                                                            
		}                                                                                                 
		.bordered {                                                                                       
			border: solid #ccc 1px;                                                                       
			-moz-border-radius: 6px;                                                                      
			-webkit-border-radius: 6px;                                                                   
			border-radius: 6px;                                                                           
			-webkit-box-shadow: 0 1px 1px #ccc;                                                           
			-moz-box-shadow: 0 1px 1px #ccc;                                                              
			box-shadow: 0 1px 1px #ccc;                                                                   
		}                                                                                                 
		.bordered tr:hover {                                                                              
			background: #fbf8e9;                                                                          
			-o-transition: all 0.1s ease-in-out;                                                          
			-webkit-transition: all 0.1s ease-in-out;                                                     
			-moz-transition: all 0.1s ease-in-out;                                                        
			-ms-transition: all 0.1s ease-in-out;                                                         
			transition: all 0.1s ease-in-out;                                                             
		}                                                                                                 
		.bordered td, .bordered th {                                                                      
			border-left: 1px solid #ccc;                                                                  
			border-top: 1px solid #ccc;                                                                   
			padding: 10px;                                                                                
			text-align: left;                                                                             
		}                                                                                                 
		.bordered th {                                                                                    
			background-color: #dce9f9;                                                                    
			background-image: -webkit-gradient(linear, left top, left bottom, from(#ebf3fc), to(#dce9f9));
			background-image: -webkit-linear-gradient(top, #ebf3fc, #dce9f9);                             
			background-image:    -moz-linear-gradient(top, #ebf3fc, #dce9f9);                             
			background-image:     -ms-linear-gradient(top, #ebf3fc, #dce9f9);                             
			background-image:      -o-linear-gradient(top, #ebf3fc, #dce9f9);                             
			background-image:         linear-gradient(top, #ebf3fc, #dce9f9);                             
			-webkit-box-shadow: 0 1px 0 rgba(255,255,255,.8) inset;                                       
			-moz-box-shadow:0 1px 0 rgba(255,255,255,.8) inset;                                           
			box-shadow: 0 1px 0 rgba(255,255,255,.8) inset;                                               
			border-top: none;                                                                             
			text-shadow: 0 1px 0 rgba(255,255,255,.5);                                                    
		}                                                                                                 
		.bordered td:first-child, .bordered th:first-child {                                              
			border-left: none;                                                                            
		}                                                                                                 
		.bordered th:first-child {                                                                        
			-moz-border-radius: 6px 0 0 0;                                                                
			-webkit-border-radius: 6px 0 0 0;                                                             
			border-radius: 6px 0 0 0;                                                                     
		}                                                                                                 
		.bordered th:last-child {                                                                         
			-moz-border-radius: 0 6px 0 0;                                                                
			-webkit-border-radius: 0 6px 0 0;                                                             
			border-radius: 0 6px 0 0;                                                                     
		}                                                                                                 
		.bordered th:only-child{                                                                          
			-moz-border-radius: 6px 6px 0 0;                                                              
			-webkit-border-radius: 6px 6px 0 0;                                                           
			border-radius: 6px 6px 0 0;                                                                   
		}                                                                                                 
		.bordered tr:last-child td:first-child {                                                          
			-moz-border-radius: 0 0 0 6px;                                                                
			-webkit-border-radius: 0 0 0 6px;                                                             
			border-radius: 0 0 0 6px;                                                                     
		}                                                                                                 
		.bordered tr:last-child td:last-child {                                                           
			-moz-border-radius: 0 0 6px 0;                                                                
			-webkit-border-radius: 0 0 6px 0;                                                             
			border-radius: 0 0 6px 0;                                                                     
		}                                                                                                 
										</style> 
		<table class="bordered" style="margin:auto" border="1"><tbody><tr><th>Client</th><th>LastComplete</th><th>NoComplete(Min)</th><th>LastPrepare</th><th>NoPrepare(Min)</th><th>Function</th><th>Waiting</th><th>Comments</th></tr> 
	};
##############################handle the temp.txt########################################################
while (my $temp=<HANDLE>){
	$temp_array[$i]=$temp;
	$i++;
}
print HTMLWRITE "$head\n";
close HTMLWRITE;

while (@temp_array){
	&handle_temp;
}
#########define the handle sub process########################################################
sub handle_temp {
	my $server=shift(@temp_array);
	my @server_code=split(/\t/,$server);
	my $server_name=$server_code[2];
	my $last_complete=$server_code[5];
	my $nocomplete=$server_code[6];
	my $last_prepare=$server_code[7];
	my $noprepare=$server_code[8];
	my @all_function;
	my @all_waiting;
	my $function;
	my $count_function=11;
	my $count_waiting=15;
	my $j;
	my $k;
	my $real_color;
	my $real_comments;
	for ($j=0;defined($server_code[$count_function]);$j++) {
		$all_function[$j]=$server_code[$count_function];
		$count_function+=5;
	}
	for ($k=0;defined($server_code[$count_waiting]);$k++) {
		$all_waiting[$k]=$server_code[$count_waiting];
		$count_waiting+=5;
	}
#########conditon1:	only one function
	if ($j==1) {
		if (@all_function ne "generatepbom") {
			if ($all_waiting[0]==0) {
				$real_color=$GREEN_OK;
				$real_comments=$comments_1;
			}else {
				if (($noprepare>=0)&&($noprepare<=5)) {
					$real_color=$GREEN_OK;
					$real_comments=$comments_2;
				} elsif (($noprepare>5)&&($noprepare<=10)) {
					$real_color=$YELLOW_WARNING;
					$real_comments=$comments_3;
				} elsif ($noprepare>10) {
					$real_color=$RED_CRITICAL;
					$real_comments=$comments_4;
				}
			}
			print HTMLADD "<tr><td rowspan=$j bgcolor=$real_color>$server_name</td><td rowspan=$j>$last_complete</td><td rowspan=$j>$nocomplete</td><td rowspan=$j>$last_prepare</td><td rowspan=$j>$noprepare</td>";
			print HTMLADD "<td bgcolor=$real_color>@all_function</td><td>@all_waiting</td><td>$real_comments</td></tr>";
		} else {
			if ($all_waiting[0]==0) {
					$real_color=$GREEN_OK;
					$real_comments=$comments_1;
				}else {
					if (($noprepare>=0)&&($noprepare<=10)) {
						$real_color=$GREEN_OK;
						$real_comments=$comments_5;
					} elsif (($noprepare>10)&&($noprepare<=60)) {
						$real_color=$YELLOW_WARNING;
						$real_comments=$comments_6;
					} elsif ($noprepare>60) {
						$real_color=$RED_CRITICAL;
						$real_comments=$comments_7;
					}
				}
				print HTMLADD "<tr><td rowspan=$j bgcolor=$real_color>$server_name</td><td rowspan=$j>$last_complete</td><td rowspan=$j>$nocomplete</td><td rowspan=$j>$last_prepare</td><td rowspan=$j>$noprepare</td>";
				print HTMLADD "<td bgcolor=$real_color>@all_function</td><td>@all_waiting</td><td>$real_comments</td></tr>";
		}
#########condition2:not only one function
	} else {
	my $real_color_main;
	my $temp_waiting;
	my $temp_function;
	my $l=0;
	my $m=0;
	foreach $temp_waiting (@all_waiting){
		$l++;
		if ($temp_waiting!=0) {
			if (($noprepare>=0)&&($noprepare<=5)) {
				$real_color_main=$GREEN_OK;
			} elsif (($noprepare>5)&&($noprepare<=10)) {
				$real_color_main=$YELLOW_WARNING;
			} elsif ($noprepare>10) {
				$real_color_main=$RED_CRITICAL;
			}
			last;
		} else {
		$real_color_main=$GREEN_OK;
		}
	}
	
	print HTMLADD "<tr><td rowspan=$j bgcolor=$real_color_main>$server_name</td><td rowspan=$j>$last_complete</td><td rowspan=$j>$nocomplete</td><td rowspan=$j>$last_prepare</td><td rowspan=$j>$noprepare</td>\n";
	foreach $temp_function (@all_function) {
		$temp_waiting=shift(@all_waiting);
		$m++;
		if ($temp_function eq "generatepbom") {
			if ($temp_waiting!=0) {
				if (($noprepare>=0)&&($noprepare<=10)) {
					$real_color=$GREEN_OK;
					$real_comments=$comments_5;
				} elsif (($noprepare>10)&&($noprepare<=60)) {
					$real_color=$YELLOW_WARNING;
					$real_comments=$comments_6;
				} elsif ($noprepare>60) {
					$real_color=$RED_CRITICAL;
					$real_comments=$comments_7;
				}
			} else {
				$real_color=$GREEN_OK;
				$real_comments=$comments_1;
			}
			print HTMLADD "<td bgcolor=$real_color>$temp_function</td><td>$temp_waiting</td><td>$real_comments</td></tr>\n";
		} else {
			if ($temp_waiting!=0) {
				if (($noprepare>=0)&&($noprepare<=5)) {
					$real_color=$GREEN_OK;
					$real_comments=$comments_2;
				} elsif (($noprepare>5)&&($noprepare<=10)) {
					$real_color=$YELLOW_WARNING;
					$real_comments=$comments_3;
				} elsif ($noprepare>10) {
					$real_color=$RED_CRITICAL;
					$real_comments=$comments_4;
				}
			} else {
				$real_color=$GREEN_OK;
				$real_comments=$comments_1;
			}
			print HTMLADD "<td bgcolor=$real_color>$temp_function</td><td>$temp_waiting</td><td>$real_comments</td></tr>\n";
		}
	}	
	}
}
print HTMLADD "</tbody></table>\n";
# print HTMLADD "<div style=position: absolute; bottom: 10px; right: 10px;font size=2 color=blue>dispatcher monitor2.0 by Jay</div>\n";
print HTMLADD "<div style=position: absolute; bottom: 10px; right: 10px;font size=2 color=blue>dispatcher monitor2.0</div>\n";
print HTMLADD "<div style=position: absolute; bottom: 10px; right: 10px;font size=2 color=blue>$year/$mon/$mday $hour:$min:$sec</div>\n";
print HTMLADD "</body></html>\n";

close HTMLWRITE;
close HTMLADD;
close HANDLE;
