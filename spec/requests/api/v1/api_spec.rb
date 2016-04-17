describe "Messages API" do
  it 'checks if the simplest text rendering works' do
    get 'v1/register'
    expect(response).to be_success
    #expect(response.body).to eq("Hello")
  end

end
