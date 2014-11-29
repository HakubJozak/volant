Factory.define :tag, :class => ColoredTag do |i|
  i.sequence(:name) { |n| "tag#{n}" }
end
