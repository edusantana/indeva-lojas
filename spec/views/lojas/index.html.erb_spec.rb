require 'rails_helper'

RSpec.describe "lojas/index", type: :view do
  before(:each) do
    assign(:lojas, [
      Loja.create!(
        :nome => "Nome"
      ),
      Loja.create!(
        :nome => "Nome"
      )
    ])
  end

  it "renders a list of lojas" do
    render
    assert_select "tr>td", :text => "Nome".to_s, :count => 2
  end
end
