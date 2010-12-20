package Water;

use 5.010001;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Water ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(wbridge);

our $VERSION = '0.01';

sub wbridge{
    my ($v,$file,$dstart,$dend)=@_;
chomp($file);
chomp($dstart);
chomp($dend);
my @h=();
my @tmp=();
my @result=();
open(RD,"$file") or die "Cannot open the file";
while(<RD>){
push(@h,$_),if($_=~/^HETATM.*HOH/);
}
my $len=$#h;
for(my $i=0;$i<$len;$i++){
    my $flag=0;
    my @tmp=();
    my $val='';
	my $tmp1=$h[$i];
	for(my $j=0;$j<$len;$j++){
		my $di=calc($tmp1,$h[$j]);
		if($di >=$dstart && $di <=$dend){if($flag==0){push(@tmp,$h[$i]);delete $h[$i];$flag++;}else{
		push(@tmp,$h[$j]);delete $h[$j];
			}
		}
	}
for(my $k=0;$k<scalar(@tmp);$k++){
	for(my $j=0;$j<scalar(@h);$j++){
		my $di=calc($tmp[$k],$h[$j]);
        if($di >=$dstart && $di <=$dend){
		push(@tmp,$h[$j]);delete $h[$j];
		}		
	}
}
foreach my $dd (@tmp){
	$val.=substr($dd,21,5).",";$val=~s/\s//g;
}
chop $val;
#print($val."\n")if($val);
push(@result,$val."\n")if($val);
}
return @result;
}
sub calc{
       no warnings;
       my ($tmpv,$hv)=@_;
	   my $x1=substr($tmpv,30,8);$x1=~s/\s//g;
       my $x2=substr($hv,30,8);$x2=~s/\s+//;
       my $y1=substr($tmpv,38,8);$y1=~s/\s+//;
       my $y2=substr($hv,38,8);$y2=~s/\s+//;
       my $z1=substr($tmpv,46,8);$z1=~s/\s+//;
       my $z2=substr($hv,46,8);$z2=~s/\s+//;
       my $dis=sqrt((($x2-$x1)**2)+(($y2-$y1)**2)+(($z2-$z1)**2));
       return $dis;
}

# Preloaded methods go here.

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Water - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Water;
  @array=Water->wbridge("pdbfile path",start_distance,end_distance);
=head1 DESCRIPTION

This module if used for identify waterbridge in protein.
=head2 EXPORT

None by default.

@array=Water->wbridge("<path>/pdb1une.ent",2.25,3.6);
foreach(@array){
      print $_;
}

or

foreach(Water->wbridge("<path>/pdb1une.ent",2.25,3.6)){
    print $_;
}

This will give the list of residues.

=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Name :Saravanan, S E<br>
E-Mail: sesaravanan7@gmail.com

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Saravana S E

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.1 or,
at your option, any later version of Perl 5 you may have available.


=cut
