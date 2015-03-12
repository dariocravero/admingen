VeloCulture::Admin.controllers :products do
  get :index do
    @title = "Products"
    @products = Product.all
    render 'products/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'product')
    @product = Product.new
    render 'products/new'
  end

  post :create do
    @product = Product.new(params[:product])
    if (@product.save rescue false)
      @title = pat(:create_title, :model => "product #{@product.id}")
      flash[:success] = pat(:create_success, :model => 'Product')
      params[:save_and_continue] ? redirect(url(:products, :index)) : redirect(url(:products, :edit, :id => @product.id))
    else
      @title = pat(:create_title, :model => 'product')
      flash.now[:error] = pat(:create_error, :model => 'product')
      render 'products/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "product #{params[:id]}")
    @product = Product[params[:id]]
    if @product
      render 'products/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'product', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "product #{params[:id]}")
    @product = Product[params[:id]]
    if @product
      if @product.modified! && @product.update(params[:product])
        flash[:success] = pat(:update_success, :model => 'Product', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:products, :index)) :
          redirect(url(:products, :edit, :id => @product.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'product')
        render 'products/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'product', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Products"
    product = Product[params[:id]]
    if product
      if product.destroy
        flash[:success] = pat(:delete_success, :model => 'Product', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'product')
      end
      redirect url(:products, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'product', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Products"
    unless params[:product_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'product')
      redirect(url(:products, :index))
    end
    ids = params[:product_ids].split(',').map(&:strip)
    products = Product.where(:id => ids)
    
    if products.destroy
    
      flash[:success] = pat(:destroy_many_success, :model => 'Products', :ids => "#{ids.to_sentence}")
    end
    redirect url(:products, :index)
  end
end
