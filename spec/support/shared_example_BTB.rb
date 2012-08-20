shared_examples 'a grid-view sample' do
  #
  # EXPECTATION: subject should be the div.sample[data-product-id='X']
  #

  it 'includes sample name' do
    subject.should have_content sample.name
  end

  it 'includes sample price' do
    subject.should have_content sample.price
  end

  it 'includes sample photo' do
    subject.should have_selector 'img'
  end

  it 'includes vote counts' do
    FactoryGirl.create(:vote, :picked, sample: sample)
    visit current_path

    subject.find('div.vote-count').text.should == '1'
  end

  it 'includes comment counts'do
    subject.find(".comments-count").should have_content "0"
  end
end

shared_examples 'a post-voting grid-view sample' do
  it 'displays notification buttons' do
    subject.should have_content 'Keep Me Posted'
  end

  it 'displays voting end date' do
    subject.should have_content 'Ended 01/14/12'
  end
end