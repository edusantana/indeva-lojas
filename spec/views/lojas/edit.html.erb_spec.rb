require 'rails_helper'

RSpec.describe "lojas/edit", type: :view do
  before(:each) do
    @loja = assign(:loja, Loja.create!(
      :nome => "MyString"
    ))
  end

  it "renders the edit loja form" do
    render

    assert_select "form[action=?][method=?]", loja_path(@loja), "post" do

      assert_select "input[name=?]", "loja[nome]"
    end
  end
end
