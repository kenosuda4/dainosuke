require "rails_helper"

RSpec.describe "products", type: :system do
  describe "GET /products" do
    it "プロダクト一覧が確認できること" do
      products = create_list(:product, 3)
      visit "/products"
      products.each do |product|
        expect(page).to have_content(product.name)
      end
    end
  end

  describe "GET /products/:id" do
    let(:product) { create(:product) }

    before do
      visit "/products/#{product.id}"
    end

    it "プロダクト詳細が確認できること" do
      expect(page).to have_content(product.name)
    end

    it "プロダクト削除ができること" do
      expect do
        click_on "Delete"
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content("Products")
      end.to change(Product, :count).by(-1)
    end
  end

  describe "GET /products/new" do
    context "有効なプロダクト名で作成する場合" do
      it "プロダクトが作成されること" do
        visit "/products/new"

        expect do
          fill_in "Name", with: "Product Name"
          click_on "Create Product"

          expect(page).to have_content("Product Name")
        end.to change(Product, :count).by(1)
      end
    end

    context "プロダクト名を空欄で作成する場合" do
      it "プロダクトが作成されないこと" do
        visit "/products/new"

        expect do
          fill_in "Name", with: ""
          click_on "Create Product"

          expect(page).to have_content("Name can't be blank")
        end.not_to change(Product, :count)
      end
    end
  end

  describe "GET /products/:id/edit" do
    let(:product) { create(:product) }

    context "有効なプロダクト名で更新する場合" do
      it "プロダクトが更新されること" do
        visit "/products/#{product.id}/edit"

        expect do
          fill_in "Name", with: "Updated Product Name"
          click_on "Update Product"

          expect(page).to have_content("Updated Product Name")
        end.to change { Product.find(product.id).name }.from(product.name).to("Updated Product Name")
      end
    end

    context "プロダクト名を空欄で更新する場合" do
      it "プロダクトが更新されないこと" do
        visit "/products/#{product.id}/edit"

        expect do
          fill_in "Name", with: ""
          click_on "Update Product"

          expect(page).to have_content("Name can't be blank")
        end.not_to(change { Product.find(product.id).name })
      end
    end
  end
end
