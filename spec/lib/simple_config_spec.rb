require 'spec_helper'

describe SimpleConfig do
  before :each do
    SimpleConfig.instance_variable_set(:@c, nil)
  end

  it 'default' do
    expect(subject.item).to eq nil
  end

  it 'check parse only on init' do
    expect(subject.item).to eq nil
    ENV['ITEM'] = 'value'
    expect(subject.item).to eq nil
  end

  it 'YML_SimpleTest' do
    allow(File).to receive(:file?).and_return true
    allow(File).to receive(:read).and_return %(
---
item1:
  sub1: value1
  sub2: value2
item2:
  sub1: value3
  sub2: value4
erb: <%= String %>
)
    expect(subject.item1.sub1).to eq 'value1'
    expect(subject.item1.sub2).to eq 'value2'
    expect(subject.item2.sub1).to eq 'value3'
    expect(subject.item2.sub2).to eq 'value4'
    expect(subject.erb).to eq 'String'
  end

  it 'ENV_SimpleTest' do
    allow(ENV).to receive(:each)
      .and_yield('ITEM_SUB1', 'value1')
      .and_yield('ITEM_SUB2', 'value2')
    expect(subject.item.sub1).to eq 'value1'
    expect(subject.item.sub2).to eq 'value2'
  end

  it 'YML/ENV_SimpleTest' do
    allow(File).to receive(:read).and_return %(
--
item: value
)
    allow(ENV).to receive(:each).and_yield('ITEM', 'override_value')
    expect(subject.item).to eq 'override_value'
  end

  it 'YML/ENV_SimpleTest with sub' do
    allow(File).to receive(:read).and_return %(
---
item:
  sub: value
)
    allow(ENV).to receive(:each).and_yield('ITEM_SUB', 'override_value')
    expect(subject.item.sub).to eq 'override_value'
  end
end
