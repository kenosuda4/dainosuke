class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @products = Product.all
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @button_text = "登録"
    puts "コントローラー: button_text = #{@button_text}"
    @product = Product.new(product_params)
    if @product.save
      respond_to do |format|
        format.turbo_stream
        # format.html { redirect_to @product, notice: 'Product was successfully create.' }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def update
    @button_text = "更新"
    if @product.update(product_params)
      # Hotwirteのrutbo_streamで部分的にレンダリングする
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace("product_#{@product.id}", partial: "products/form", locals: { product: @product, button_text: @button_text })
        }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to products_url
  end

  # 一覧表示画面での更新
  def update_name
    @button_text = "更新"
    @product = Product.find(params[:id])
    @product.update(name: params[:name])
    # Hotwirteのturbo_streamで部分的にレンダリングする
    respond_to do |format|
      # render turbo_stream: turbo_stream.replace("product_#{@product.id}", partial: "products/form", locals: { product: @product, button_text: @button_text })
      format.turbo_stream { render turbo_stream: turbo_stream.update("product_#{@product.id}", partial: "products/form", locals: { product: @product, button_text: @button_text }) }
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.expect(product: [:name])
  end
end
