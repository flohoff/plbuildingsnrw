

package MultiPolygon;
	use strict;
	use JSON;
	use Data::Dumper;
	use Geo::WKT;
	use Mojo::Log;

	sub new {
		my ($class, $row) = @_;

		my $self={
			row => $row,
			nid => -1,
			nodes => {},
			tags => {},
			parsed => from_json($row->{geojson}),
			log => Mojo::Log->new
		};
		bless $self, $class;

		$self->_parse();

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
		my ($self) = @_;

		my $geom=$self->{parsed}{coordinates};

		my $mp=$geom;
		if ($self->{parsed}{type} =~ /MultiPolygon/) {
			$mp=@{$geom}[0];
		}

		for my $ring ( @{$mp} ) {
			my @r;
			for my $pos ( @{$ring} ) {
				my $n=$self->node_new($pos);
				push @r, $n->{id};
			}
			push @{$self->{rings}}, \@r;
		}

		$self->{log}->debug("Count: %d\n", scalar @{$geom});
		$self->{log}->debug("Outer: %d\n", scalar @{$mp});
	}

	sub tags_add {
		my ($self, $tags) = @_;

		foreach my $k ( keys %{$tags} ) {
			$self->{tags}{$k}=$tags->{$k};
		}
	}

	sub tags {
		my ($self, $debug) = @_;

		my @tags;
		foreach my $k ( keys %{$self->{tags}} ) {
			push @tags, sprintf("\t<tag k=\"%s\" v=\"%s\"/>",
					$k, $self->{tags}{$k});
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
		my ($self, $debug, $tags) = @_;

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
				join("\n", $self->tags($debug, $tags))
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


