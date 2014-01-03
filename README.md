# LabelFactory
[![Gem Version](https://badge.fury.io/rb/label_factory.png)](https://rubygems.org/gems/label_factory)[![Code Climate](https://codeclimate.com/github/eventioz/label_factory.png)](https://codeclimate.com/github/eventioz/label_factory)[![Dependency Status](https://gemnasium.com/eventioz/label_factory.png)](https://gemnasium.com/eventioz/label_factory)

create pdf labels with pure ruby

you can load your templates in [Glabels](http://www.glabels.org/) format or use the ones that we have already included

## Installation

Add this line to your application's Gemfile:

    gem 'label_factory'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install label_factory

## Usage

this example is taken from tests suit:

``` ruby
    p = LabelFactory::Batch::Base.new("Avery 8160") # label is 2 x 10
    p.draw_boxes(false, true)
    p.add_label("&*\%Positoin 15", position: 15) # should add col 2, row 1
    p.add_label('With Margin', use_margin: true, position: 4)
    p.add_label('No Margin', position: 5, use_margin: false)
    p.add_label('This is the song that never ends, yes it goes on and on my friends', position: 7 )
    p.add_label('X Offset = 4, Y Offset = -6', position: 9,  offset_x: 4, offset_y: -6)
    p.add_label('Centered', position: 26, justification: :center) # should add col 2, row 15
    p.add_label('[Right justified]', justification: :right, position: 28) # col 2, row 14, right justified.
    p.add_label('col 2 row 15', position: 29) # should add col 2, row 15
    p.add_label('This was added first and has a BIG font', position: 8,  font_size: 16)
    p.add_label('This was added last and has a small font', position: 8, font_size: 8, offset_y: -40)
    p.save_as('labels.pdf')
```

or multiple lines and fonts per line in a single label!

``` ruby
    pdf = LabelFactory::Batch::Base.new('Avery 8160')
    pdf.draw_boxes(false, false)
    contents = [];
    contents << {text: 'This', justification: :center, font_size: 8, font_type: 'Courier'}
    contents << {text: 'Is a', justification: :right, font_size: 8, font_type: 'Helvetica-BoldOblique'}
    contents << {text: 'Test', font_type: 'Times-Roman'}
    5.times do |i|
      pdf.add_multiline_label(contents,i)
    end

    pdf.save_as('other_labels.pdf')
```

## Credits

this gem is inspirated in [PDF-labels](http://rubyforge.org/projects/pdf-labels/)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/gagoar/label_factory/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

