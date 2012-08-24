require 'spec_helper'

describe Movie do
    describe 'searching for similar movies' do
        before :each do
            @fake_movies = [mock('Movie'), mock('Movie')]
            @fake_movie = FactoryGirl.create(:movie, :id => "1", :title => "Star Wars", :director => "George Lucas")
          end

        it 'should find the similar movies by director' do
          Movie.should_receive(:find).with("1").and_return(@fake_movie)
          Movie.should_receive(:find_all_by_director).with(@fake_movie.director).and_return(@fake_movies)
          Movie.similar("1").should == @fake_movies
        end
        

      end
  end
