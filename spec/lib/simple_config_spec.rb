require 'spec_helper'

describe SimpleConfig do
  it 'SimpleTest' do
    allow(File).to receive(:read).and_return %(
---
item1:
  item1sub1: value1
  item1sub2: value2
item2:
  item2sub1: value3
  item2sub2: value4
erb: <%= String %>
)
    expect(subject.item1.item1sub1).to eq 'value1'
    expect(subject.item1.item1sub2).to eq 'value2'
    expect(subject.item2.item2sub1).to eq 'value3'
    expect(subject.item2.item2sub2).to eq 'value4'
    expect(subject.erb).to eq 'String'
  end
end
