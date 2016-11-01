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

  it 'ENV_SimpleTest bool' do
    allow(ENV).to receive(:each)
      .and_yield('ITEM_FALSE', 'false')
      .and_yield('ITEM_TRUE', 'true')
    expect(subject.item.false).to eq false
    expect(subject.item.true).to eq true
  end

  it 'YML/ENV_SimpleTest' do
    allow(File).to receive(:file?).and_return true
    allow(File).to receive(:read).and_return %(
---
file: yml
over: yml
)
    allow(ENV).to receive(:each)
      .and_yield('ENV', 'env')
      .and_yield('OVER', 'env')
    expect(subject.file).to eq 'yml'
    expect(subject.env).to eq 'env'
    expect(subject.over).to eq 'env'
  end

  it 'YML/ENV_SimpleTest with sub' do
    allow(File).to receive(:file?).and_return true
    allow(File).to receive(:read).and_return %(
---
item:
  file: yml
  over: yml
)
    allow(ENV).to receive(:each)
      .and_yield('ITEM_ENV', 'env')
      .and_yield('ITEM_OVER', 'env')
    expect(subject.item.file).to eq 'yml'
    expect(subject.item.env).to eq 'env'
    expect(subject.item.over).to eq 'env'
  end
  it 'check typing' do
    allow(File).to receive(:file?).and_return true
    allow(File).to receive(:read).and_return %(
---
yml:
  bool: true
  fixnum: 123
  float: 123.01
  string: string
)
    allow(ENV).to receive(:each)
      .and_yield('ENV_BOOL', 'true')
      .and_yield('ENV_FIXNUM', '123')
      .and_yield('ENV_FLOAT', '123.01')
      .and_yield('ENV_STRING', 'string')
    expect(subject.yml.bool.class).to eq TrueClass
    expect(subject.yml.fixnum.class).to eq Fixnum
    expect(subject.yml.float.class).to eq Float
    expect(subject.yml.string.class).to eq String

    expect(subject.env.bool.class).to eq TrueClass
    expect(subject.env.fixnum.class).to eq Fixnum
    expect(subject.env.float.class).to eq Float
    expect(subject.env.string.class).to eq String
  end
end
