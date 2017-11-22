require 'rails_helper'

RSpec.describe "lojas/new", type: :view do
  before(:each) do
    assign(:loja, Loja.new(
      :nome => "MyString"
    ))
  end

  it "renders new loja form" do
    render

    assert_select "form[action=?][method=?]", lojas_path, "post" do

      assert_select "input[name=?]", "loja[nome]"
    end
  end
end
