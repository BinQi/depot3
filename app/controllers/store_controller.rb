class StoreController < ApplicationController
  skip_before_filter :authorize
  
  def index
    if params[:set_locale]
      redirect_to store_path(locale: params[:set_locale])
      
    else
      if(params[:bookName] and params[:bookName].lstrip != "")
        @products = []
        products = Product.all
        products.each do |product|
          if(product.title.upcase.include?(params[:bookName].upcase))
            @products << product
          end
        end
        
        if(@products.length == 0)
          respond_to do |format|
            format.html{ redirect_to store_path, notice: "Can't Find Such A Title!" }
          end
        end
      else
        if(params[:genre])
          @products = Product.where(:genre => params[:genre])
          if(@products.length == 0)
            respond_to do |format|
              format.html{ redirect_to store_path, notice: "No Such Genre!" }
            end
          end
        else
          @products = Product.order(:title)
        end
      end
      @cart = current_cart
      if @products.class == ActiveRecord::Relation
        @products = @products.paginate page: params[:page], order: 'created_at desc', per_page: 5
      end
    end 
  end
  
  def show
    @product = Product.find(params[:id])
    @cart = current_cart
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end
  
  def showOrder
    if(params[:quantity])
      line_item = LineItem.find(params[:id]) 
      line_item.update_attribute(:quantity, params[:quantity].to_i)
      puts line_item.quantity
    end
    @cart = current_cart
  end
  
end
