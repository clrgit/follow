# frozen_string_literal: true

require_relative "follow/version"

module Follow
  class FollowEnumerator < Enumerator
    def initialize(object, method = nil, &block)
      closure = method ? lambda { |object| object.__send__(method) } : block
      super() { |yielder|
        while !object.nil?
          yielder << object
          object = closure.call(object)
        end
      }
    end
  end

  def follow(object, method = nil, &block)
    method.nil? == block_given? or raise ArgumentError, "Requires either a method argument or a block"
    FollowEnumerator.new(object, method, &block)
  end

  module_function :follow
  public :follow
end
