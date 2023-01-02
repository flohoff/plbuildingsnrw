

package MultiPolygon;
	use strict;
	use JSON;
	use Data::Dumper;
	use Geo::WKT;

	sub new {
		my ($class, $row) = @_;

		my $self={
			row => $row,
			nid => -1,
			nodes => {},
			parsed => from_json($row->{geojson}),
		};
		bless $self, $class;

		$self->_parse($row->{geojson});

		return $self;
	}

	my $nid=-1;

	sub node_new {
		my ($self, $pos) = @_;
	
		my $posid=sprintf("%s-%s", $pos->[0], $pos->[1]);

		if (defined($self->{nodes}{$posid})) {
			return $self->{nodes}{$posid};
		}

		my $n={
			id => $self->{nid}--,
			lon => $pos->[0],
			lat => $pos->[1]
		};

		$self->{nodes}{$posid}=$n;

		return $n;
	}

	sub _parse {
		my ($self, $string) = @_;

		my $geom=$self->{parsed}{coordinates};
		my $mp=@{$geom}[0];

		for my $ring ( @{$mp} ) {
			my @r;
			for my $pos ( @{$ring} ) {
				my $n=$self->node_new($pos);
				push @r, $n->{id};
			}
			push @{$self->{rings}}, \@r;
		}

		#printf("Count: %d\n", scalar @{$geom});
		#printf("Outer: %d\n", scalar @{$mp});
	}

	# Unter Gebäudefunktion
	# https://www.bezreg-koeln.nrw.de/brk_internet/geobasis/liegenschaftskataster/alkis/vorgaben/pflichtenheft_03/anlage_03_alkis_nrw_ok_max_v6_0_1.htm
	my $funktion2type={
		'0' => { 'building' => 'yes' },
		'1313' => { 'building' => 'shed' },	# Gartenhaus
		'1610' => { 'building' => 'roof', 'layer' => '1' },
		'1611' => { 'building' => 'carport' },
		'2463' => { 'building' => 'garage' },
		'2523' => { 'building' => 'yes', 'power' => 'substation' },
		'2700' => { 'building' => 'farm_auxiliary' },	# Gebäude für Land- und Forstwirtschaft
		'2720' => { 'building' => 'farm_auxiliary' },	# Land- und forstwirtschaftliches Betriebsgebäude
		'2721' => { 'building' => 'barn' },	# Scheune
		'2723' => { 'building' => 'shed' },	# Schuppen
		'2724' => { 'building' => 'stable' },	# 'Stall' ist ein Gebäude, in dem Tiere untergebracht sind.
		'2726' => { 'building' => 'stable' },	# Scheune und Stall
		'2727' => { 'building' => 'stable' },	# Stall für Tiergroßhaltung
		'2740' => { 'building' => 'greenhouse' },	# Treibhaus, Gewächshaus
		'2741' => { 'building' => 'greenhouse' },	# Treibhaus, Gewächshaus
		'2742' => { 'building' => 'greenhouse' },	# Treibhaus, Gewächshaus
	};

	sub tags {
		my ($self, $debug) = @_;

		my $gfk=$self->{row}{gfk};
		my ($dummy, $funktion) = split(/_/, $gfk);

		my $t=$funktion2type->{$funktion};
		if (!defined($t)) {
			$t=$funktion2type->{0};
		}

		my @tags;
		foreach my $k ( keys %{$t} ) {
			push @tags, sprintf("\t<tag k=\"%s\" v=\"%s\"/>",
					$k, $t->{$k});
		}

		if (defined($debug) && $debug) {
			foreach my $k ( keys %{$self->{row}} ) {
				my $v=$self->{row}{$k};

				next if ($v =~ /POLYGON/i);
				$v=~s/["<>\/]//g;

				push @tags, sprintf("\t<tag k=\"debug:%s\" v=\"%s\"/>",
					$k, $self->{row}{$k});
			}
		}

		return @tags;
	}

	sub osmxml {
		my ($self, $debug) = @_;

		my @nodes=map {
			sprintf('<node id="%d" lat="%f" lon="%f"/>',
				$_->{id}, $_->{lat}, $_->{lon});
		} sort { $b->{id} <=> $a->{id} } values %{$self->{nodes}};

		my @rings=map {
			my @nodes=map {
				sprintf("\t<nd ref=\"%s\"/>", $_);
			} @{$_};
			sprintf("<way id=\"%s\">\n%s\n%s\n</way>\n",
				$self->{nid}--,
				join("\n", @nodes),
				join("\n", $self->tags($debug))
				);
		} @{$self->{rings}};

		# <tag k="building" v="house"/>
		return "<?xml version=\"1.0\"?>\n"
			. "<osm version=\"0.6\">\n"
			. join("\n", @nodes) 
			. "\n" 
			. join("\n", @rings)
			. "</osm>\n";
	};

1;


