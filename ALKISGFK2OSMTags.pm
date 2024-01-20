package ALKISGFK2OSMTags;

	# Unter Gebäudefunktion
	# https://www.bezreg-koeln.nrw.de/brk_internet/geobasis/liegenschaftskataster/alkis/vorgaben/pflichtenheft_03/anlage_03_alkis_nrw_ok_max_v6_0_1.htm
	my $funktion2type={
		'0' => { 'building' => 'yes' },
		'1313' => { 'building' => 'shed' },	# Gartenhaus
		'1610' => { 'building' => 'roof', 'layer' => '1' },
		'1611' => { 'building' => 'carport' },
		'1700' => { 'barrier'  => 'wall' },
		'2463' => { 'building' => 'garage' },
		'2523' => { 'building' => 'yes', 'power' => 'substation' },
		'2020' => { 'building' => 'office' },
		'2100' => { 'building' => 'commercial' },
		'2110' => { 'building' => 'industrial' },
		'2111' => { 'building' => 'industrial' },
		'2112' => { 'building' => 'industrial' },
		'2140' => { 'building' => 'warehouse' },
		'2143' => { 'building' => 'warehouse' },
		'2180' => { 'building' => 'commercial' },
		'2460' => { 'building' => 'garages' },
		'2700' => { 'building' => 'farm_auxiliary' },	# Gebäude für Land- und Forstwirtschaft
		'2720' => { 'building' => 'farm_auxiliary' },	# Land- und forstwirtschaftliches Betriebsgebäude
		'2729' => { 'building' => 'farm_auxiliary' },	# Wirtschaftsgebäude
		'2721' => { 'building' => 'barn' },		# Scheune
		'2723' => { 'building' => 'shed' },		# Schuppen
		'2724' => { 'building' => 'stable' },		# 'Stall' ist ein Gebäude, in dem Tiere untergebracht sind.
		'2726' => { 'building' => 'stable' },		# Scheune und Stall
		'2727' => { 'building' => 'stable' },		# Stall für Tiergroßhaltung
		'2740' => { 'building' => 'greenhouse' },	# Treibhaus, Gewächshaus
		'2741' => { 'building' => 'greenhouse' },	# Treibhaus, Gewächshaus
		'2742' => { 'building' => 'greenhouse' },	# Treibhaus, Gewächshaus
	};

	sub totag {
		my ($gfk) = @_;

		my $funktion=$gfk;
		if ($gfk =~ /_/) {
			my ($d, $f) = split(/_/, $gfk);
			$funktion=$f;
		}

		my $t=$funktion2type->{$funktion};
		if (!defined($t)) {
			$t=$funktion2type->{0};
		}

		return $t;
	}
1;
