describe Follow do
  it 'has a version number' do
    expect(Follow::VERSION).not_to be_nil
  end

  describe "#follow" do
    let(:klass) {
      Class.new do
        attr_reader :parent
        def initialize(parent) = @parent = parent
      end
    }
    
    # a
    #   b
    #     c
    # d
    let(:a) { klass.new(nil) }
    let(:b) { klass.new(a) }
    let(:c) { klass.new(b) }
    let(:d) { klass.new(d) }

    it "returns an enumerator" do
      expect(Follow.follow(a, :parent)).to be_a(Enumerator)
    end

    context "when object is nil" do
      it "returns []" do
        expect(Follow.follow(nil, :parent).to_a).to eq []
      end
    end

    context "when object is not nil" do
      it "includes the start-element" do
        expect(Follow.follow(a, :parent).to_a).to eq [a]
      end
      it "considers 'false' to be a real value" do
        enum = Follow.follow(false) { |value| value == false ? true : nil }
        expect(enum.to_a).to eq [false, true]
      end
    end

    context "with a method argument" do
      it "follows the method" do
        expect(Follow.follow(c, :parent).to_a).to eq [c, b, a]
      end
    end

    context "with a block" do
      it "follow the result of the block" do
        enum = Follow.follow(c) { |obj| obj.parent }
        expect(enum.to_a).to eq [c, b, a]
      end
    end

    context "with conflicting arguments" do
      it "raises an ArgumentError" do
        expect { Follow.follow(a, :parent) { |arg| ; } }.to raise_error ArgumentError
        expect { Follow.follow(a) }.to raise_error ArgumentError
      end
    end
  end
end
