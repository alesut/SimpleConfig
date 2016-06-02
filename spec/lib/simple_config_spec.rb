require 'spec_helper'

describe SimpleConfig do
  let(:subject) do
    allow(File).to receive(:read).and_return %(
---
item1:
  item1sub1: value1
  item1sub2: value2
item2:
  item2sub1: value3
  item2sub2: value4
item_arr:
  - value5
  - value6
erb: <%= String %>
)
    SimpleConfig
  end
  it 'check values' do
    expect(subject.item1.item1sub1).to eq 'value1'
    expect(subject.item1.item1sub2).to eq 'value2'
    expect(subject.item2.item2sub1).to eq 'value3'
    expect(subject.item2.item2sub2).to eq 'value4'
    expect(subject.erb).to eq 'String'
  end
  it 'check array items' do
    expect(subject.item_arr[0]).to eq 'value5'
    expect(subject.item_arr[1]).to eq 'value6'
    expect(subject.item_arr.class).to eq SimpleConfig::Array
    expect(subject.item_arr.to_sql).to eq %("value5","value6")
  end
end
