require 'spec_helper'

describe MoviesController do
    describe 'searching for similar movies' do
        before :each do
            @fake_movies = [mock('Movie'), mock('Movie')]
            @fake_movie = FactoryGirl.create(:movie, :id => "1", :title => "Star Wars", :director => "George Lucas")
          end
        it 'should follow the route to the similar movies by director page' do
          Movie.should_receive(:similar).with("1").and_return(@fake_movies)
          get :similar, {:id => "1"}
          assert_routing('movies/1/similar', {:controller => 'movies', :action => 'similar', :id => '1'})
        end

        it 'should go back to the home page when no similar movies by director' do
          Movie.should_receive(:similar).with("1").and_return(nil)
          get :similar, {:id => "1"}
          assert_routing('movies', {:controller => 'movies', :action => 'index'})
        end

        it 'should select the Similiar Movies template for rendering' do
          Movie.should_receive(:similar).with("1").and_return(@fake_movies)
          get :similar, {:id => "1"}
          response.should render_template('similar')
        end

        it 'it should make the results available to the template' do
          Movie.should_receive(:similar).with("1").and_return(@fake_movies)
          get :similar, {:id => "1"}
          assigns(:movies).should == @fake_movies
        end
      end
  end
