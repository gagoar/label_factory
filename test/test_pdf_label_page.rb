# encoding: utf-8
require 'test/unit'
require 'pry'
require 'pry-nav'
require '/Users/gagoar/workspace/label_factory/lib/label_factory'

class TestPdfLabelBatch < Test::Unit::TestCase
  ROOT = File.expand_path(File.dirname(__FILE__) + "/../")
  def setup
  end

  def test_new_with_tempalte_name
    p = LabelFactory::Batch::Base.new("Avery 5366")
    assert p
    assert_equal p.template.name, "Avery 5366"
  end

  def test_new_with_alias_name
    p = LabelFactory::Batch::Base.new("Avery 8166")
    assert p
    assert_equal p.template.name, "Avery 5366"
  end

  def test_new_with_paper_type
    p = LabelFactory::Batch::Base.new("Avery 5366", {paper: 'Legal'})
    assert p
    assert_equal p.pdf.page_width, 612.0
    assert_equal p.pdf.page_height, 1008.0
  end

  def test_new_with_tempalte_not_found
    assert_raise(RuntimeError) {
      p = LabelFactory::Batch::Base.new('Some Non-Existing')
    }
  end

  #TODO other options are possible for pdf_options, we need to test those at some point

  def test_PdfLabelBatch_load_tempalte_set
    LabelFactory::Batch::Base.load_template_set("#{ROOT}/templates/avery-iso-templates.xml")
     #Avery 7160 is found in avery-iso-templates
     p = LabelFactory::Batch::Base.new("Avery 7160")
     assert p
     assert_equal p.pdf.page_width, 595.28
     assert_equal p.pdf.page_height, 841.89
     LabelFactory::Batch::Base.load_template_set("#{ROOT}/templates/avery-us-templates.xml")
   end

   def test_PdfLabelBatch_all_template_names
     #what happens if we havn't loaded a template yet?
     t = LabelFactory::Batch::Base.all_template_names
     assert t
     assert_equal t.class, Array
     assert_equal t.count, 292
     assert_equal t.first, "Avery 5160"
   end

  def test_add_label_3_by_10
    p = LabelFactory::Batch::Base.new("Avery 8160") # label is 2 x 10
    p.add_label("&*\%Positoin 15", position: 15) # should add col 2, row 1
    #does the use_margin = true work?
    p.add_label('With Margin', use_margin: true, position: 4)
    #with out the margin?
    p.add_label('No Margin', position: 5, use_margin: false)
    p.add_label('This is the song that never ends, yes it goes on and on my friends', position: 7 )
    p.add_label('X Offset = 4, Y Offset = -6', position: 9,  offset_x: 4, offset_y: -6)
    p.add_label('Centered', position: 26, justification: :center) # should add col 2, row 15
    p.add_label('[Right justified]', justification: :right, position: 28)# col 2, row 14, right justified.
    p.add_label('col 2 row 15', position: 29) # should add col 2, row 15
    p.add_label('This was added first and has a BIG font', position: 8,  font_size: 16)
    p.add_label('This was added last and has a small font', position: 8, font_size: 8, offset_y: -40)
    p.draw_boxes(false, true)
    #TODO Anybody out there think of a better way to test this?
    p.save_as("#{ROOT}/test_add_label_output.pdf")
  end

  def test_add_label_3_by_10_multi_page
    p = LabelFactory::Batch::Base.new("Avery 8160") # label is 2 x 10
    p.draw_boxes(false, true)
    p.add_label('Position 15', position: 15) # should add col 2, row 1
    #does the use_margin = true work?
    p.add_label('using margin', use_margin: true, position: 4)
    #with out the margin?
    p.add_label('No Margin', position: 5, use_margin: false)
    p.add_label('This should be on a new page', position: 48)
    p.add_label('This should be first a page 2', position: 30)
    #TODO Anybody out there think of a better way to test this?
    p.save_as("#{ROOT}/test_add_multi_page.pdf")
  end

  def test_add_labels_with_multiple_lines_align_and_font_types
    pdf = LabelFactory::Batch::Base.new('Avery 8160')
    pdf.draw_boxes(false, false)

    contents = [];
    contents << {text: 'This',  justification: :center, font_size: 8, font_type: 'Courier'}
    contents << {text: 'Is a', justification: :right, font_size: 8, font_type: 'Helvetica-BoldOblique'}
    contents << {text: 'Test', font_type: 'Times-Roman'}

    5.times do |i|
      pdf.add_multiline_label(contents,i)
    end
    pdf.save_as("#{ROOT}/test_add_labels_with_multiple_lines_align_and_font_types.pdf")
  end

  def test_multipage_2
    p = LabelFactory::Batch::Base.new("Avery 8160") # label is 2 x 10
    p.draw_boxes(false, true)
    100.times do |i|
      p.add_label("Position #{i}", position: i) # should add col 1, row 2
    end
    p.save_as("#{ROOT}/test_add_multi_page2.pdf")
  end

  def test_add_many_labels
    p = LabelFactory::Batch::Base.new("Avery 8160") # label is 2 x 10
    #without positoin, so start at 1
    p.add_many_labels('Hello Five Times!', count: 5)
    p.add_many_labels('Hellow four more times, starting at 15', count: 4, position: 15)
    p.save_as("#{ROOT}/test_add_many_label_output.pdf")
  end

  def test_draw_boxes
    p = LabelFactory::Batch::Base.new("Avery 5366") # label is 2 x 10
    p.draw_boxes
    p.save_as("#{ROOT}/test_draw_boxes_output.pdf")
  end

  def test_label_information_no_crash
    LabelFactory::Batch::Base.all_templates.each do |t|
      t.nx
      t.ny
      t.find_description
    end
  end
end
