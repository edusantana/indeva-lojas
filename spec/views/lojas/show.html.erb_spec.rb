require 'rails_helper'

RSpec.describe "lojas/show", type: :view do
  before(:each) do
    @loja = assign(:loja, Loja.create!(
      :nome => "Nome"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Nome/)
  end
end
