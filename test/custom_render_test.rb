# coding: UTF-8
require 'test_helper'

class CustomRenderTest < Redcarpet::TestCase
  class SimpleRender < Redcarpet::Render::HTML
    def emphasis(text)
      "<em class=\"cool\">#{text}</em>"
    end
  end

  def test_simple_overload
    md = Redcarpet::Markdown.new(SimpleRender)
    html_equal "<p>This is <em class=\"cool\">just</em> a test</p>\n",
      md.render("This is *just* a test")
  end

  class NilPreprocessRenderer < Redcarpet::Render::HTML
    def preprocess(fulldoc)
      nil
    end
  end

  def test_preprocess_returning_nil
    md = Redcarpet::Markdown.new(NilPreprocessRenderer)
    assert_equal(nil,md.render("Anything"))
  end

  class TestNormalTextRender < Redcarpet::Render::HTML
    def normal_text(text)
      text.gsub(/@\w+/) do |str|
        "<a>#{str}</a>"
      end
    end
  end

  def test_normal_text_getting_whole_text_when_no_intra_emphasis
    md = Redcarpet::Markdown.new(TestNormalTextRender, no_intra_emphasis: true)
    assert_equal("<p><a>@user_name</a></p>\n", md.render("@user_name"))
  end

  def test_normal_text_working_as_before
    md = Redcarpet::Markdown.new(TestNormalTextRender, no_intra_emphasis: false)
    assert_equal("<p><a>@user</a>_name</p>\n", md.render("@user_name"))
  end
end
