package ALKISGFK2OSMTags;

	# Unter Gebäudefunktion
	# https://www.bezreg-koeln.nrw.de/brk_internet/geobasis/liegenschaftskataster/alkis/vorgaben/pflichtenheft_03/anlage_03_alkis_nrw_ok_max_v6_0_1.htm
	my $funktion2type={
		'0' => { 'building' => 'yes' },
		'1201' => { 'building' => 'silo' },	# Silo
		'1205' => { 'building' => 'tank' },	# Tank
		'1210' => { 'building' => 'farm' },	# Land- und forstwirtschaftliches Wohn- und Betriebsgebäude
		'1221' => { 'building' => 'farm' },	# Land- und forstwirtschaftliches Wohn- und Betriebsgebäude
		'1311' => { 'building' => 'cabin' },	# Ferienhaus
		'1312' => { 'building' => 'cabin' },	# Wochenendhaus
		'1313' => { 'building' => 'shed' },	# Gartenhaus
		'1400' => { 'building' => 'power' },	# Umformer
		'1610' => { 'building' => 'roof', 'layer' => '1' },
		'1611' => { 'building' => 'carport' },
		'1700' => { 'barrier'  => 'wall' },
		'2463' => { 'building' => 'garage' },
		'2523' => { 'building' => 'yes', 'power' => 'substation' },
		'2000' => { 'building' => 'commercial' },
		'2020' => { 'building' => 'office' },
		'2054' => { 'building' => 'shop' },
		'2081' => { 'building' => 'restaurant' },
		'2100' => { 'building' => 'commercial' },
		'2110' => { 'building' => 'industrial' },
		'2111' => { 'building' => 'industrial' },
		'2112' => { 'building' => 'industrial' },
		'2120' => { 'building' => 'workshop' },
		'2140' => { 'building' => 'warehouse' },
		'2143' => { 'building' => 'warehouse' },
		'2180' => { 'building' => 'commercial' },
		'2460' => { 'building' => 'garages' },
		'2463' => { 'building' => 'garages' },
		'2520' => { 'building' => 'power' },
		'2523' => { 'building' => 'power' },
		'2700' => { 'building' => 'farm_auxiliary' },	# Gebäude für Land- und Forstwirtschaft
		'2720' => { 'building' => 'farm_auxiliary' },	# Land- und forstwirtschaftliches Betriebsgebäude
		'2721' => { 'building' => 'barn' },		# Scheune
		'2723' => { 'building' => 'shed' },		# Schuppen
		'2724' => { 'building' => 'stable' },		# 'Stall' ist ein Gebäude, in dem Tiere untergebracht sind.
		'2726' => { 'building' => 'stable' },		# Scheune und Stall
		'2727' => { 'building' => 'stable' },		# Stall für Tiergroßhaltung
		'2729' => { 'building' => 'farm_auxiliary' },	# Wirtschaftsgebäude
		'2740' => { 'building' => 'greenhouse' },	# Treibhaus, Gewächshaus
		'2741' => { 'building' => 'greenhouse' },	# Treibhaus, Gewächshaus
		'2742' => { 'building' => 'greenhouse' },	# Treibhaus, Gewächshaus
		'3020' => { 'building' => 'school' },		# Gebäude für Bildung und Forschung
		'3021' => { 'building' => 'school' },		# Allgemein bildende Schule
		'3034' => { 'building' => 'museum' },		# Museum
		'3041' => { 'building' => 'church' },		# Kirche
		'3065' => { 'building' => 'kindergarden' },	# Kinderkrippe, Kindergarten, Kindertagesstätte
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
