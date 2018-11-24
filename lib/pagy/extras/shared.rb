# frozen_string_literal: true

require 'json'

class Pagy

  # Default :breakpoints
  VARS[:breakpoints] = { 0 => [1,4,4,1] }

  # Helper for building the page_nav with javascript. For example:
  # with an object like:
  #   Pagy.new count:1000, page: 20, breakpoints: {0 => [1,2,2,1], 350 => [2,3,3,2], 550 => [3,4,4,3]}
  # it returns something like:
  #   { :items  => [1, :gap, 18, 19, "20", 21, 22, 50, 2, 17, 23, 49, 3, 16, 24, 48],
  #     :series => { 0   =>[1, :gap, 18, 19, "20", 21, 22, :gap, 50],
  #                  350 =>[1, 2, :gap, 17, 18, 19, "20", 21, 22, 23, :gap, 49, 50],
  #                  550 =>[1, 2, 3, :gap, 16, 17, 18, 19, "20", 21, 22, 23, 24, :gap, 48, 49, 50] },
  #     :widths => [550, 350, 0] }
  # where :items  is the unordered array union of all the page numbers for all sizes (passed to the PagyResponsive javascript function)
  #       :series is the hash of the series keyed by width (used by the *_responsive helpers to create the JSON string)
  #       :widths is the desc-ordered array of widths (passed to the PagyResponsive javascript function)
  def responsive
    @responsive ||= {items: [], series: {}, widths:[]}.tap do |r|
      @vars[:breakpoints].key?(0) || raise(ArgumentError, "expected :breakpoints to contain the 0 size; got #{@vars[:breakpoints].inspect}")
      @vars[:breakpoints].each {|width, size| r[:items] |= r[:series][width] = series(size)}
      r[:widths] = r[:series].keys.sort!{|a,b| b <=> a}
    end
  end

  def self.deprecate(mod, old_meth, new_meth)
    mod.send(:define_method, old_meth) do |*args|
      Warning.warn "WARNING: The ##{old_meth} method is deprecated and will be removed in 2.0; please use ##{new_meth} instead.\n"
      send(new_meth, *args)
    end
  end

end
