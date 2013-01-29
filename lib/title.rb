class Title

  LONG_FIXES = {
    /2 nd/i => '2nd',
    /3 rd/i => '3rd',
    /(\d+) th/i => '\1th',
    /\save(\.|\s|$)/i => ' Avenue ',
    /ctr/i => 'Center',
    /hblr/i => 'HBLR',
    /jct\./i => 'Junction',
    /^msu$/i => 'Montclair State University',
    /nj/i => 'NJ',
    /ny/i => 'NY',
    /phl\./i => 'Philadelphia',
    /\sst(\.|\s|$)/i => ' Street ',
    /\strans\s/i => 'Transit',
    /univ$/i => 'University',
  }

  SHORT_FIXES = {
    /\[rr\]/i => '',
    'Montclair State University' => 'MSU',
    /newark broad street/i => 'Newark Broad',
    /new jersey/i => 'NJ',
    /new york/i => 'NY',
    /\s+philadelphia/i => '',
    /\s+station/i => '',
    /trenton transit center/i => 'Trenton',
  }

  attr_reader :raw, :long, :short, :parameterized, :initials

  def initialize(raw)
    @raw = raw

    make_initials
    make_long
    make_short
    parameterize
  end

  def to_s
    [@raw, @long, @short, @parameterized, @initials].join("    ")
  end

  def make_initials
    @initials = @raw.
      parameterize.
      split(/\W/).
      map {|w| w.first}.
      join.
      upcase
  end

  def make_long
    @long = @raw.titleize

    LONG_FIXES.each do |regex, replacement|
      @long.gsub! regex, replacement
    end

    @long = @long.squeeze(' ').strip
  end

  def make_short
    @short = @long.clone

    SHORT_FIXES.each do |regex, replacement|
      @short.gsub! regex, replacement
    end

    @short = @short.squeeze(' ').strip
  end

  def parameterize
    @parameterized = @short.parameterize
  end

end
