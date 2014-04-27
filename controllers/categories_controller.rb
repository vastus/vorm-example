class CategoriesController < AppController
  # Index.
  get '/' do
    @categories = Category.all
    slim :'categories/index'
  end

  # Show.
  get '/categories/:id' do
    @category = Category.find(params[:id])
    slim :'categories/show'
  end

  # New.
  get '/categories/new' do
    authorize!
    @category = Category.new
    slim :'categories/new'
  end

  # Create.
  post '/categories' do
    authorize!
    @category = Category.new(params[:category])
    if @category.save
      redirect to(url('/'))
    else
      slim :'categories/new'
    end
  end

  # Edit.
  get '/categories/:id/edit' do
    authorize!
    @category = Category.find(params[:id])
    slim :'categories/edit'
  end

  # Update.
  put '/categories/:id' do
    authorize!
    @category = Category.find(params[:id])
    if @category.update(params[:category])
      redirect to(url('/'))
    else
      slim :'categories/edit'
    end
  end
  
  # Delete.
  get '/categories/:id/delete' do
    authorize!
    Category.destroy(params[:id])
    redirect to(url('/'))
  end
end

