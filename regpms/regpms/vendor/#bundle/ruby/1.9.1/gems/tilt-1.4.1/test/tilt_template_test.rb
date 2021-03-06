# coding: utf-8
require 'contest'
require 'tilt'
require 'tempfile'

class TiltTemplateTest < Test::Unit::TestCase

  class MockTemplate < Tilt::Template
    def prepare
    end
  end

  test "needs a file or block" do
    assert_raise(ArgumentError) { Tilt::Template.new }
  end

  test "initializing with a file" do
    inst = MockTemplate.new('foo.erb') {}
    assert_equal 'foo.erb', inst.file
  end

  test "initializing with a file and line" do
    inst = MockTemplate.new('foo.erb', 55) {}
    assert_equal 'foo.erb', inst.file
    assert_equal 55, inst.line
  end

  test "initializing with a tempfile" do
    tempfile = Tempfile.new('tilt_template_test')
    inst = MockTemplate.new(tempfile)
    assert_equal File.basename(tempfile.path), inst.basename
  end

  class SillyHash < Hash
    def path(arg)
    end
  end

  test "initialize with hash that implements #path" do
    options = SillyHash[:key => :value]
    inst = MockTemplate.new(options) {}
    assert_equal :value, inst.options[:key]
  end

  test "uses correct eval_file" do
    inst = MockTemplate.new('foo.erb', 55) {}
    assert_equal 'foo.erb', inst.eval_file
  end

  test "uses a default filename for #eval_file when no file provided" do
    inst = MockTemplate.new { 'Hi' }
    assert_not_nil inst.eval_file
    assert !inst.eval_file.include?("\n")
  end

  test "calculating template's #basename" do
    inst = MockTemplate.new('/tmp/templates/foo.html.erb') {}
    assert_equal 'foo.html.erb', inst.basename
  end

  test "calculating the template's #name" do
    inst = MockTemplate.new('/tmp/templates/foo.html.erb') {}
    assert_equal 'foo', inst.name
  end

  test "initializing with a data loading block" do
    MockTemplate.new { |template| "Hello World!" }
  end

  class InitializingMockTemplate < Tilt::Template
    @@initialized_count = 0
    def self.initialized_count
      @@initialized_count
    end

    def initialize_engine
      @@initialized_count += 1
    end

    def prepare
    end
  end

  test "one-time template engine initialization" do
    assert_nil InitializingMockTemplate.engine_initialized
    assert_equal 0, InitializingMockTemplate.initialized_count

    InitializingMockTemplate.new { "Hello World!" }
    assert InitializingMockTemplate.engine_initialized
    assert_equal 1, InitializingMockTemplate.initialized_count

    InitializingMockTemplate.new { "Hello World!" }
    assert_equal 1, InitializingMockTemplate.initialized_count
  end

  class PreparingMockTemplate < Tilt::Template
    include Test::Unit::Assertions
    def prepare
      assert !data.nil?
      @prepared = true
    end
    def prepared? ; @prepared ; end
  end

  test "raises NotImplementedError when #prepare not defined" do
    assert_raise(NotImplementedError) { Tilt::Template.new { |template| "Hello World!" } }
  end

  test "raises NotImplementedError when #evaluate or #template_source not defined" do
    inst = PreparingMockTemplate.new { |t| "Hello World!" }
    assert_raise(NotImplementedError) { inst.render }
    assert inst.prepared?
  end

  class SimpleMockTemplate < PreparingMockTemplate
    include Test::Unit::Assertions
    def evaluate(scope, locals, &block)
      assert prepared?
      assert !scope.nil?
      assert !locals.nil?
      "<em>#{@data}</em>"
    end
  end

  test "prepares and evaluates the template on #render" do
    inst = SimpleMockTemplate.new { |t| "Hello World!" }
    assert_equal "<em>Hello World!</em>", inst.render
    assert inst.prepared?
  end

  class SourceGeneratingMockTemplate < PreparingMockTemplate
    def precompiled_template(locals)
      "foo = [] ; foo << %Q{#{data}} ; foo.join"
    end
  end

  test "template_source with locals" do
    inst = SourceGeneratingMockTemplate.new { |t| 'Hey #{name}!' }
    assert_equal "Hey Joe!", inst.render(Object.new, :name => 'Joe')
    assert inst.prepared?
  end

  test "template_source with locals of strings" do
    inst = SourceGeneratingMockTemplate.new { |t| 'Hey #{name}!' }
    assert_equal "Hey Joe!", inst.render(Object.new, 'name' => 'Joe')
    assert inst.prepared?
  end

  test "template_source with locals having non-variable keys raises error" do
    inst = SourceGeneratingMockTemplate.new { |t| '1 + 2 = #{_answer}' }
    err = assert_raise(RuntimeError) { inst.render(Object.new, 'ANSWER' => 3) }
    assert_equal "invalid locals key: \"ANSWER\" (keys must be variable names)", err.message
    assert_equal "1 + 2 = 3", inst.render(Object.new, '_answer' => 3)
  end

  class CustomGeneratingMockTemplate < PreparingMockTemplate
    def precompiled_template(locals)
      data
    end

    def precompiled_preamble(locals)
      options.fetch(:preamble)
    end

    def precompiled_postamble(locals)
      options.fetch(:postamble)
    end
  end

  test "supports pre/postamble" do
    inst = CustomGeneratingMockTemplate.new(
      :preamble => 'buf = []',
      :postamble => 'buf.join'
    ) { 'buf << 1' }

    assert_equal "1", inst.render
  end

  # Special-case for Haml
  # https://github.com/rtomayko/tilt/issues/193
  test "supports Array pre/postambles" do
    inst = CustomGeneratingMockTemplate.new(
      :preamble => ['buf = ', '[]'],
      :postamble => ['buf.', 'join']
    ) { 'buf << 1' }

    # TODO: Use assert_output when we swicth to MiniTest
    warns = <<-EOF
precompiled_preamble should return String (not Array)
precompiled_postamble should return String (not Array)
EOF

    begin
      require 'stringio'
      $stderr = StringIO.new
      assert_equal "1", inst.render
      assert_equal warns, $stderr.string
    ensure
      $stderr = STDERR
    end
  end

  class Person
    CONSTANT = "Bob"

    attr_accessor :name
    def initialize(name)
      @name = name
    end
  end

  test "template_source with an object scope" do
    inst = SourceGeneratingMockTemplate.new { |t| 'Hey #{@name}!' }
    scope = Person.new('Joe')
    assert_equal "Hey Joe!", inst.render(scope)
  end

  test "template_source with a block for yield" do
    inst = SourceGeneratingMockTemplate.new { |t| 'Hey #{yield}!' }
    assert_equal "Hey Joe!", inst.render(Object.new){ 'Joe' }
  end

  test "template which accesses a constant" do
    inst = SourceGeneratingMockTemplate.new { |t| 'Hey #{CONSTANT}!' }
    assert_equal "Hey Bob!", inst.render(Person.new("Joe"))
  end

  ##
  # Encodings

  class DynamicMockTemplate < MockTemplate
    def precompiled_template(locals)
      options[:code]
    end
  end

  class UTF8Template < MockTemplate
    def default_encoding
      Encoding::UTF_8
    end
  end

  if ''.respond_to?(:encoding)
    original_encoding = Encoding.default_external

    setup do
      @file = Tempfile.open('template')
      @file.puts "stuff"
      @file.close
      @template = @file.path
    end

    teardown do
      Encoding.default_external = original_encoding
      Encoding.default_internal = nil
      @file.delete
    end

    test "reading from file assumes default external encoding" do
      Encoding.default_external = 'Big5'
      inst = MockTemplate.new(@template)
      assert_equal 'Big5', inst.data.encoding.to_s
    end

    test "reading from file with a :default_encoding overrides default external" do
      Encoding.default_external = 'Big5'
      inst = MockTemplate.new(@template, :default_encoding => 'GBK')
      assert_equal 'GBK', inst.data.encoding.to_s
    end

    test "reading from file with default_internal set does no transcoding" do
      Encoding.default_internal = 'utf-8'
      Encoding.default_external = 'Big5'
      inst = MockTemplate.new(@template)
      assert_equal 'Big5', inst.data.encoding.to_s
    end

    test "using provided template data verbatim when given as string" do
      Encoding.default_internal = 'Big5'
      inst = MockTemplate.new(@template) { "blah".force_encoding('GBK') }
      assert_equal 'GBK', inst.data.encoding.to_s
    end

    test "uses the template from the generated source code" do
      tmpl = "??????"
      code = tmpl.inspect.encode('Shift_JIS')
      inst = DynamicMockTemplate.new(:code => code) { '' }
      res = inst.render
      assert_equal 'Shift_JIS', res.encoding.to_s
      assert_equal tmpl, res.encode(tmpl.encoding)
    end

    test "uses the magic comment from the generated source code" do
      tmpl = "??????"
      code = ("# coding: Shift_JIS\n" + tmpl.inspect).encode('Shift_JIS')
      # Set it to an incorrect encoding
      code.force_encoding('UTF-8')

      inst = DynamicMockTemplate.new(:code => code) { '' }
      res = inst.render
      assert_equal 'Shift_JIS', res.encoding.to_s
      assert_equal tmpl, res.encode(tmpl.encoding)
    end

    test "uses #default_encoding instead of default_external" do
      Encoding.default_external = 'Big5'
      inst = UTF8Template.new(@template)
      assert_equal 'UTF-8', inst.data.encoding.to_s
    end

    test "uses #default_encoding instead of current encoding" do
      tmpl = "".force_encoding('Big5')
      inst = UTF8Template.new(@template) { tmpl }
      assert_equal 'UTF-8', inst.data.encoding.to_s
    end

    test "raises error if the encoding is not valid" do
      assert_raises(Encoding::InvalidByteSequenceError) do
        UTF8Template.new(@template) { "\xe4" }
      end
    end
  end
end
