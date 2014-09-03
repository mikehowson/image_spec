module ImageSpec

  require 'tempfile'
  require 'open3'

  class Comparison
    def initialize(expected, actual, max_acceptable_score = 0.01)
      @expected, @actual = expected, actual
      @max_acceptable_score = max_acceptable_score
    end

    def look_similar?
      score and (score < @max_acceptable_score)
    end

    def score
      raise "Expected image path is blank" unless @expected
      raise "Actual image path is blank" unless @actual

      [@expected, @actual].each do |path|
        raise "No such file! (#{path})" unless File.exists?(path.to_s)
      end

      raise "Files are not the same type!" unless same_type?

      raise "Files are not the same size" unless same_size?

      tempfile = Tempfile.new("diff")

      cmd = "compare -verbose -metric mae #{@expected} #{@actual} #{tempfile.path}"

      Open3.popen3(cmd) do |stdin, stdout, stderr|
        output = stderr.read
        return false if output =~ /images too dissimilar/

        output.match /^\s*all:.*\((.*)\)$/
        $1.to_f
      end
    end

    def same_type?
      File.extname(@expected) == File.extname(@actual)
    end

    def same_size?
      size_of(@expected) == size_of(@actual)
    end

    def size_of(image)
      `identify #{image}`.match /\b(\d+x\d+)\b/
      $1.split("x").map(&:to_i)
    end
  end
end

RSpec::Matchers.define(:look_like) do |exected_file_path|
  def max_acceptable_score
    0.01
  end

  match do |actual_file_path|
    @expected = exected_file_path
    @actual = actual_file_path
    comparison.look_similar?
  end

  def comparison
    ImageSpec::Comparison.new(@expected, @actual, max_acceptable_score)
  end

  failure_message_for_should do
    "Expected #{@actual} to look like #{@expected}. Comparison score should be less than #{max_acceptable_score} but was #{@score}"
  end
end

RSpec::Matchers.define(:have_image_that_looks_like) do |expected_file_path|
  match do |page|
    @page = page
    @expected_file_path = expected_file_path
    any_images_look_similar?
  end

  failure_message_for_should do
    "Expected one of the images on the page to look similar to #{expected_file_path}"
  end

  def any_images_look_similar?
    urls = page.all(:xpath, '//img/@src').map(&:text)
    actual_paths = image_paths(urls)

    actual_paths.any? do |actual_path|
      looks_like?(actual_path)
    end
  end

  def looks_like?(other_file)
    comparison = comparison_with(other_file)
    return false unless comparison.same_type? && comparison.same_size?
    comparison.look_similar?
  end

  def comparison_with(other_file)
    ImageSpec::Comparison.new(@expected_file_path, other_file)
  end

  def image_paths(urls)
    urls.map {|url| find_image_file(url) }
  end

  def find_image_file(url)
    clean_url = url.gsub(/\?\d+$/, '')
    if url =~ /^\/assets\//
      path = File.join(Rails.root, clean_url.gsub(/^\/assets\//, '/app/assets/images/'))
      return path if File.exists?(path)
    elsif url =~ /^\/images\//
      asset_path = File.join(Rails.root, clean_url.gsub(/^\/images\//, '/app/assets/images/'))
      return asset_path if File.exists?(asset_path)
    end
    rails_path = File.join(Rails.root, File.join('public', clean_url))
    if File.exists?(rails_path)
      rails_path
    else
      url
    end
  end
end

